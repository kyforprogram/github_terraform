################################################################################
# Module VPC
################################################################################
resource "aws_vpc" "main" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-vpc"
    }
  )
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-igw"
    }
  )
}
################################################################################
# Module サブネット
################################################################################
resource "aws_subnet" "main" {
  for_each = var.subnets

  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.az
  map_public_ip_on_launch = each.value.type == "public"

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-${each.key}"
      Type = each.value.type
    }
  )
}

################################################################################
# Module ルートテーブル
################################################################################
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-public-rt"
    }
  )
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  tags = merge(
    var.tags,
    {
      Name = "${var.name}-private-rt"
    }
  )
}

resource "aws_route_table" "private_db" {
  vpc_id = aws_vpc.main.id
  tags = merge(
    var.tags,
    {
      Name = "${var.name}-private-db-rt"
    }
  )
}

################################################################################
# Module ルートテーブル 関連付け
################################################################################
resource "aws_route_table_association" "public" {
  for_each = {
    for k, v in var.subnets : k =>v
    if v.type == "public"
  }

  subnet_id      = aws_subnet.main[each.key].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  for_each = {
    for k, v in var.subnets : k =>v
    if v.type == "private"
  }

  subnet_id      = aws_subnet.main[each.key].id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_db" {
  for_each = {
    for k, v in var.subnets : k =>v
    if v.type == "private_db"
  }

  subnet_id      = aws_subnet.main[each.key].id
  route_table_id = aws_route_table.private_db.id
}

################################################################################
# Module セキュリティグループ
################################################################################
 data "http" "my_ip" {
   url = "https://checkip.amazonaws.com"
 }

locals {
  my_ip = "${chomp(date.http.my_ip.response_body)}/32"  
}

 resource "aws_security_group" "alb" {
  name = "${var.name}-sg-alb"
  vpc_id = aws_vpc.main.id

  ingress = {
      description = "HTTP from internet"
      from_port = "80"
      to_port = "80"
      protcol = "tcp"
      cidr_block = [local.my_ip]
  }

  egress = {
    from_port = "0"
    to_port = "0"
    protcol = "-1"
    cidr_block = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-sg-alb"
    }
  )
 }