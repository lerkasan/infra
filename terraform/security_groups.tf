resource "aws_security_group" "keycloak_server" {
  name        = "keycloak_server_security_group"
  description = "Security group for keycloak server"
  vpc_id      = aws_vpc.this.id

  tags = {
    Name        = "keycloak_appserver_sg"
    terraform   = "true"
    environment = var.environment
    project     = var.project_name
  }

  # Dependency is used to ensure that VPC has an Internet gateway
  depends_on  = [ aws_internet_gateway.this ]
}

// only for Application LB, not Network LB
resource "aws_security_group" "keycloak_alb" {
  name        = "demo_alb_security_group"
  description = "demo security group for loadbalancer"
  vpc_id      = aws_vpc.this.id

  tags = {
    Name        = "keycloak_alb_sg"
    terraform   = "true"
    environment = var.environment
    project     = var.project_name
  }

  # Dependency is used to ensure that VPC has an Internet gateway
  depends_on  = [ aws_internet_gateway.this ]
}

resource "aws_security_group" "keycloak_database" {
  name        = "keycloak_database_security_group"
  description = "security group for keycloak database"
  vpc_id      = aws_vpc.this.id

  tags = {
    Name        = "keycloak_database_sg"
    terraform   = "true"
    environment = var.environment
    project     = var.project_name
  }
}

resource "aws_security_group" "bastion" {
  name        = "bastion_security_group"
  description = "security group for bastion"
  vpc_id      = aws_vpc.this.id

  tags = {
    Name        = "bastion_sg"
    terraform   = "true"
    environment = var.environment
    project     = var.project_name
  }
}
