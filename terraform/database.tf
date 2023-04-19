resource "aws_db_instance" "primary" {
  storage_type            = "gp2"
  allocated_storage       = 10
  max_allocated_storage   = 10
  backup_retention_period = 30
  //deletion_protection     = true
  identifier              = var.rds_name
  engine                  = var.database_engine
  engine_version          = var.database_engine_version
  instance_class          = var.database_instance_class
  db_name                 = aws_ssm_parameter.keycloak_database_name.value
  username                = aws_ssm_parameter.keycloak_database_username.value
  password                = aws_ssm_parameter.keycloak_database_password.value
  //multi_az                = true      # commented because it adds additional 15-20 minutes to create RDS instance
  availability_zone       = local.availability_zones[0]
  db_subnet_group_name    = aws_db_subnet_group.this.name
  vpc_security_group_ids  = [ aws_security_group.keycloak_database.id ]
  publicly_accessible     = false
  storage_encrypted       = true
//  kms_key_id              = aws_kms_key.database_encrypt_key.arn    # or storage_encrypted = true See documentation
  maintenance_window      = "Sun:02:00-Sun:04:00"
  enabled_cloudwatch_logs_exports = [ "error", "slowquery" ]     # audit, error, general, slowquery
  skip_final_snapshot     = true

  tags = {
    Name        = "keycloak_primary_db"
    terraform   = "true"
    environment = var.environment
    project     = var.project_name
  }
}

resource "aws_db_subnet_group" "this" {
  name          = "keycloak_db_subnet_group"
  subnet_ids    = [ for subnet in aws_subnet.private : subnet.id ]

  tags = {
    Name        = "keycloak_db_subnet_group"
    terraform   = "true"
    environment = var.environment
    project     = var.project_name
  }
}