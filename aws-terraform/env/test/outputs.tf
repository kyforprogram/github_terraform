output "vpc_id" {
  value = module.vpc.vpc_id
}

output "subnet_ids" {
  value = module.vpc.subnet_ids
}

output "apache_ec2s" {
  value = module.vpc.apache_ec2s
}

output "alb_dns_name" {
  value = module.vpc.alb_dns_name
}

output "alb_arn" {
  value = module.vpc.alb_arn
}

