output "public_instance_ids" {
  value = module.service.public_instance_ids
}

output "public_instance_ips" {
  value = module.service.public_instance_ips
}

output "webserver5_id" {
  value = module.service.webserver5_id
}

output "webserver5_ip" {
  value = module.service.webserver5_ip
}

output "vm6_id" {
  value = module.service.vm6_id
}

output "vm6_ip" {
  value = module.service.vm6_ip
}

output "loadbalancer_dns" {
  value = module.service.loadbalancer_dns
}

output "loadbalancer_arn" {
  value = module.service.loadbalancer_arn
}

output "targetgroup_arn" {
  value = module.service.targetgroup_arn
}

output "template_arn" {
  value = module.service.template_arn
}

output "autoscaling_arn" {
  value = module.service.autoscaling_arn
}
