output "public_instance_ids" {
  value = module.instance.public_instance_ids
}

output "public_instance_ips" {
  value = module.instance.public_instance_ips
}

output "webserver5_id" {
  value = module.instance.webserver5_id
}

output "webserver5_ip" {
  value = module.instance.webserver5_ip
}

output "vm6_id" {
  value = module.instance.vm6_id
}

output "vm6_ip" {
  value = module.instance.vm6_ip
}

output "loadbalancer_dns" {
  value = module.loadbalancer.load_balancer_dns
}

output "loadbalancer_arn" {
  value = module.loadbalancer.load_balancer_arn
}

output "targetgroup_arn" {
  value = module.loadbalancer.target_group_arn
}

output "template_arn" {
  value = module.autoscalinggroup.template_arn
}

output "autoscaling_arn" {
  value = module.autoscalinggroup.autoscaling_group_arn
}
