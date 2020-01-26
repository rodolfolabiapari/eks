output "bastion_ip" {
  value = module.bastion.public_ip
}

output "bastion_sg" {
  value = module.bastion.security_groups
}