output "vpc_id" {
  value = module.arch.vpc_id
}

output "vpc_cidr" {
  value = module.arch.vpc_cidr
}

output "igw_id" {
  value = module.arch.igw_id
}

output "public_subnet_ids" {
  value = module.arch.public_subnet_ids
}

output "public_subnet_cidrs" {
  value = module.arch.public_subnet_cidrs
}

output "natgw_id" {
  value = module.arch.natgw_id
}

output "private_subnet_ids" {
  value = module.arch.private_subnet_ids
}

output "private_subnet_cidrs" {
  value = module.arch.private_subnet_cidrs
}
