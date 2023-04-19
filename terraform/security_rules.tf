//  only for Application LB
//# -------------------- Keycloak load balancer rules ---------------------------
//
//resource "aws_security_group_rule" "lb_allow_inbound_https_from_all" {
//  type              = "ingress"
//  description       = "HTTPS ingress"
//  from_port         = var.https_port
//  to_port           = var.https_port
//  protocol          = "tcp"
//  cidr_blocks       = ["0.0.0.0/0"]
//  security_group_id = aws_security_group.keycloak_alb.id
//}
//
//resource "aws_security_group_rule" "lb_allow_inbound_http_from_all" {
//  type              = "ingress"
//  description       = "HTTP ingress"
//  from_port         = var.http_port
//  to_port           = var.http_port
//  protocol          = "tcp"
//  cidr_blocks       = ["0.0.0.0/0"]
//  security_group_id = aws_security_group.keycloak_alb.id
//}
//
//resource "aws_security_group_rule" "lb_allow_outbound_https_to_keycloak_server" {
//  type              = "egress"
//  description       = "HTTPS egress"
//  from_port         = var.https_port
//  to_port           = var.https_port
//  protocol          = "tcp"
//  source_security_group_id = aws_security_group.keycloak_server.id
//  security_group_id = aws_security_group.keycloak_alb.id
//}
//
//resource "aws_security_group_rule" "lb_allow_outbound_http_to_keycloak_server" {
//  type              = "egress"
//  description       = "HTTP egress"
//  from_port         = var.http_port
//  to_port           = var.http_port
//  protocol          = "tcp"
//  source_security_group_id = aws_security_group.keycloak_server.id
//  security_group_id = aws_security_group.keycloak_alb.id
//}

# -------------------- Keycloak server rules ---------------------------

// only for network load balancer, not application load balancer
resource "aws_security_group_rule" "keycloak_server_allow_inbound_https_from_all" {
  type              = "ingress"
  description       = "HTTPS ingress"
  from_port         = var.https_port
  to_port           = var.https_port
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.keycloak_server.id
}

// only for network load balancer, not application load balancer
resource "aws_security_group_rule" "keycloak_server_allow_inbound_http_from_all" {
  type              = "ingress"
  description       = "HTTP ingress"
  from_port         = var.http_port
  to_port           = var.http_port
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.keycloak_server.id
}

// only for application load balance, not network loadbalancer
//resource "aws_security_group_rule" "keycloak_server_allow_inbound_https_from_lb" {
//  type              = "ingress"
//  description       = "HTTPS ingress"
//  from_port         = var.https_port
//  to_port           = var.https_port
//  protocol          = "tcp"
//  source_security_group_id = aws_security_group.keycloak_alb.id
//  security_group_id = aws_security_group.keycloak_server.id
//}
//
// only for application load balance, not network loadbalancer
//resource "aws_security_group_rule" "keycloak_server_allow_inbound_http_from_lb" {
//  type              = "ingress"
//  description       = "HTTP ingress"
//  from_port         = var.http_port
//  to_port           = var.http_port
//  protocol          = "tcp"
//  source_security_group_id = aws_security_group.keycloak_alb.id
//  security_group_id = aws_security_group.keycloak_server.id
//}

resource "aws_security_group_rule" "keycloak_server_allow_outbound_https_to_all" {
  type              = "egress"
  description       = "HTTPS egress"
  from_port         = var.https_port
  to_port           = var.https_port
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.keycloak_server.id
}

resource "aws_security_group_rule" "keycloak_server_allow_outbound_http_to_all" {
  type              = "egress"
  description       = "HTTP egress"
  from_port         = var.http_port
  to_port           = var.http_port
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.keycloak_server.id
}

resource "aws_security_group_rule" "keycloak_allow_inbound_ssh_from_bastion" {
  type              = "ingress"
  description       = "SSH ingress"
  from_port         = var.ssh_port
  to_port           = var.ssh_port
  protocol          = "tcp"
  source_security_group_id = aws_security_group.bastion.id
  security_group_id = aws_security_group.keycloak_server.id
}

resource "aws_security_group_rule" "keycloak_server_allow_outbound_to_database" {
  type                     = "egress"
  description              = "MySQL egress"
  from_port                = var.mysql_port
  to_port                  = var.mysql_port
  protocol                 = "tcp"

  source_security_group_id = aws_security_group.keycloak_database.id
  security_group_id        = aws_security_group.keycloak_server.id
}

# -------------------- Keycloak database rules ---------------------------

resource "aws_security_group_rule" "database_allow_inbound_from_appserver" {
  type                     = "ingress"
  description              = "MySQL ingress"
  from_port                = var.mysql_port
  to_port                  = var.mysql_port
  protocol                 = "tcp"

  source_security_group_id = aws_security_group.keycloak_server.id
  security_group_id        = aws_security_group.keycloak_database.id
}

# --------------------- Bastion rules --------------------------

resource "aws_security_group_rule" "bastion_allow_inbound_ssh_from_admin_ip" {
  type              = "ingress"
  description       = "SSH ingress"
  from_port         = var.ssh_port
  to_port           = var.ssh_port
  protocol          = "tcp"
  cidr_blocks       = [format("%s/%s", local.admin_public_ip, 32)]
  security_group_id = aws_security_group.bastion.id
}

resource "aws_security_group_rule" "bastion_allow_outbound_ssh_to_keycloak_servers" {
  type              = "egress"
  description       = "SSH egress"
  from_port         = var.ssh_port
  to_port           = var.ssh_port
  protocol          = "tcp"
  source_security_group_id = aws_security_group.keycloak_server.id
  security_group_id = aws_security_group.bastion.id
}

resource "aws_security_group_rule" "bastion_allow_outbound_https_to_all" {
  type              = "egress"
  description       = "HTTPS egress"
  from_port         = var.https_port
  to_port           = var.https_port
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.bastion.id
}

resource "aws_security_group_rule" "bastion_allow_outbound_http_to_all" {
  type              = "egress"
  description       = "HTTP egress"
  from_port         = var.http_port
  to_port           = var.http_port
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.bastion.id
}
