output "vpc_id" {
  description = "vpc id"
  value       = aws_vpc.main.id
}

output "subnet_ids" {
  value = {
    for k, v in aws_subnet.main : k => v.id
  }
}

output "apache_ec2s" {
  value = {
    for k, v in aws_instance.apache_ec2 : k => v.id
  }
}

output "alb_dns_name" {
  value = aws_lb.main.dns_name
}

output "alb_arn" {
  value = aws_lb.main.arn
}
