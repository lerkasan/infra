resource "aws_ssm_parameter" "keycloak_database_host" {
  name        = "keycloak_database_host"
  description = "Keycloak database host"
  type        = "SecureString"
//  key_id      = aws_kms_key.ssm_param_encrypt_key.id
  value       = aws_db_instance.primary.address

  tags = {
    Name        = "keycloak_database_host"
    terraform   = "true"
    environment = var.environment
    project     = var.project_name
  }
}

resource "aws_ssm_parameter" "keycloak_database_name" {
  name        = "keycloak_db_name"
  description = "Keycloak database name"
  type        = "SecureString"
  //  key_id      = aws_kms_key.ssm_param_encrypt_key.id
  value       = var.keycloak_database_name

  tags = {
    Name        = "keycloak_database_name"
    terraform   = "true"
    environment = var.environment
    project     = var.project_name
  }
}

resource "aws_ssm_parameter" "keycloak_database_username" {
  name        = "keycloak_db_username"
  description = "Keycloak database username"
  type        = "SecureString"
//  key_id      = aws_kms_key.ssm_param_encrypt_key.id
  value       = var.keycloak_database_username

  tags = {
    Name        = "keycloak_database_username"
    terraform   = "true"
    environment = var.environment
    project     = var.project_name
  }
}

resource "aws_ssm_parameter" "keycloak_database_password" {
  name        = "keycloak_db_password"
  description = "Keycloak database password"
  type        = "SecureString"
//  key_id      = aws_kms_key.ssm_param_encrypt_key.id
  value       = var.keycloak_database_password

  tags = {
    Name        = "keycloak_database_password"
    terraform   = "true"
    environment = var.environment
    project     = var.project_name
  }
}

resource "aws_ssm_parameter" "keycloak_admin_password" {
  name        = "keycloak_admin_password"
  description = "Keycloak admin password"
  type        = "SecureString"
  //  key_id      = aws_kms_key.ssm_param_encrypt_key.id
  value       = var.keycloak_admin_password

  tags = {
    Name        = "keycloak_admin_password"
    terraform   = "true"
    environment = var.environment
    project     = var.project_name
  }
}
