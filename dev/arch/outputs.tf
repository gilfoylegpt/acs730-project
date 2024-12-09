output "vpc_id" {
  value = module.dev-arch.vpc_id
}

output "vpc_cidr" {
  value = module.dev-arch.vpc_cidr
}

output "igw_id" {
  value = module.dev-arch.igw_id
}

output "public_subnet_ids" {
  value = module.dev-arch.public_subnet_ids
}

output "public_subnet_cidrs" {
  value = module.dev-arch.public_subnet_cidrs
}

output "natgw_id" {
  value = module.dev-arch.natgw_id
}

output "private_subnet_ids" {
  value = module.dev-arch.private_subnet_ids
}

output "private_subnet_cidrs" {
  value = module.dev-arch.private_subnet_cidrs
}
