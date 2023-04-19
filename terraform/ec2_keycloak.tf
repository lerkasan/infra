resource "aws_instance" "keycloak_server" {
  for_each                    = toset(local.availability_zones)

  availability_zone           = each.value
  subnet_id                   = aws_subnet.private[each.value].id
  associate_public_ip_address = false
  ami                         = data.aws_ami.this.id
  instance_type               = var.ec2_instance_type
  user_data                   = data.cloudinit_config.user_data.rendered
  key_name                    = var.keycloak_server_private_ssh_key_name
  vpc_security_group_ids      = [ aws_security_group.keycloak_server.id ]
  monitoring                  = true

  tags = {
    Name        = "keycloak_server"
    terraform   = "true"
    environment = var.environment
    project     = var.project_name
  }
}