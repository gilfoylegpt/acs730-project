output "default_tags" {
  value = var.default_tags
}

output "prefix" {
  value = var.prefix
}

output "latest_amazon_linux" {
  value = data.aws_ami.latest_amazon_linux
}

output "azones" {
  value = data.aws_availability_zones.azones
}

