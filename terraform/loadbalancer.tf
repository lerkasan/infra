resource "aws_lb" "this" {
  name               = "keycloak-lb"
  internal           = false
  load_balancer_type = "network"
//  load_balancer_type = "application"
//  security_groups    = [ aws_security_group.keycloak_alb.id ]
//  subnets            = [ for subnet in aws_subnet.public : subnet.id ]
  //enable_deletion_protection = true

  dynamic "subnet_mapping" {
    for_each = aws_subnet.public
    content {
      subnet_id     = subnet_mapping.value.id
      allocation_id = aws_eip.lb[subnet_mapping.key].id
    }
  }

//  subnet_id     = aws_subnet.public.id
//  allocation_id = aws_eip.lb.id

  tags = {
    Name        = "keycloak_lb"
    terraform   = "true"
    environment = var.environment
    project     = var.project_name
  }
}

resource "aws_lb_target_group" "this" {
  port     = var.https_port
//  protocol = "HTTPS" // only for application load balancer
  protocol = "TCP"
  vpc_id   = aws_vpc.this.id

  health_check {
    healthy_threshold   = 5
    interval            = 60
    matcher              = "200"
    path                = "/"
    protocol            = "HTTPS"
    timeout             = 10
    unhealthy_threshold = 4
  }

  tags = {
    Name        = "keycloak_tg"
    terraform   = "true"
    environment = var.environment
    project     = var.project_name
  }
}

resource "aws_lb_target_group_attachment" "http" {
  for_each         = toset(local.availability_zones)

  target_group_arn = aws_lb_target_group.this.arn
  target_id        = aws_instance.keycloak_server[each.value].id
  port             = var.http_port
}

resource "aws_lb_target_group_attachment" "https" {
  for_each         = toset(local.availability_zones)

  target_group_arn = aws_lb_target_group.this.arn
  target_id        = aws_instance.keycloak_server[each.value].id
  port             = var.https_port
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.this.arn
  port              = var.https_port
//  protocol          = "HTTPS" // only for application load balancer
  protocol          = "TCP" // only for network load balancer

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }

  tags = {
    Name        = "keycloak_lb_listener"
    terraform   = "true"
    environment = var.environment
    project     = var.project_name
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = var.http_port
  //  protocol          = "HTTPS // only for application load balancer
  protocol          = "TCP" // only for application load balancer

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }

  tags = {
    Name        = "keycloak_lb_listener"
    terraform   = "true"
    environment = var.environment
    project     = var.project_name
  }
}

data "aws_route53_zone" "this" {
  name         = "lerkasan.de"
  private_zone = false
}

resource "aws_route53_record" "this" {
  zone_id = data.aws_route53_zone.this.zone_id
  name    = "keycloak.${data.aws_route53_zone.this.name}"
  type    = "A"
  ttl     = "300"
  records = [ for eip in aws_eip.lb : eip.public_ip ]
}