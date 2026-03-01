terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region  = "ap-northeast-1"
}

resource "aws_s3_bucket" "private_bucket" {
  bucket = "yohei-terraform-private-bucket-20260301"

  tags = {
    Name = "yohei-private-bucket"
    Env  = "test"
  }
}

# パブリックアクセス完全ブロック
resource "aws_s3_bucket_public_access_block" "block" {
  bucket = aws_s3_bucket.private_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
