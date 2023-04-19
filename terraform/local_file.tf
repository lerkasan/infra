resource "local_file" "hosts_for_ansible_inventory" {
  filename = format("%s/%s", var.ansible_inventory_dir, var.dynamic_inventory_file)
//  filename = var.dynamic_inventory_file
  content  = templatefile("templates/hosts.tftpl", {
    bastion: aws_instance.bastion.public_ip
    keycloak_servers: [ for server in aws_instance.keycloak_server: server.private_ip ]
  })
}
