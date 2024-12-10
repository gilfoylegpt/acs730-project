output "vpc_id" {
  value = module.network.vpc_id
}

output "vpc_cidr" {
  value = module.network.vpc_cidr
}

output "igw_id" {
  value = module.network.igw_id
}

output "public_subnet_ids" {
  value = module.network.public_subnet_ids
}

output "public_subnet_cidrs" {
  value = module.network.public_subnet_cidrs
}

output "natgw_id" {
  value = module.network.natgw_id
}

output "private_subnet_ids" {
  value = module.network.private_subnet_ids
}

output "private_subnet_cidrs" {
  value = module.network.private_subnet_cidrs
}
