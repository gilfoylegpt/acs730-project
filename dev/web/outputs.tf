output "public_instance_ids" {
  value = module.dev-instance.public_instance_ids
}

output "public_instance_ips" {
  value = module.dev-instance.public_instance_ips
}

output "webserver5_id" {
  value = module.dev-instance.webserver5_id
}

output "webserver5_ip" {
  value = module.dev-instance.webserver5_ip
}

output "vm6_id" {
  value = module.dev-instance.vm6_id
}

output "vm6_ip" {
  value = module.dev-instance.vm6_ip
}

output "loadbalancer_dns" {
  value = module.dev-loadblancer.load_balancer_dns
}

output "loadbalancer_arn" {
  value = module.dev-loadblancer.load_balancer_arn
}

output "targetgroup_arn" {
  value = module.dev-loadblancer.target_group_arn
}
