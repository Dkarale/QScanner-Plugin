# TD-15: Terraform config with intentional cloud misconfigurations for compliance testing
#
# FAIL controls (expected in scan results):
#   CIS AWS - S3 bucket public access not blocked
#   CIS AWS - S3 bucket versioning disabled
#   CIS AWS - Security group allows unrestricted SSH (0.0.0.0/0 on port 22)
#   CIS AWS - CloudTrail logging disabled
#   NIST AI RMF - Unencrypted S3 bucket (no server-side encryption)

provider "aws" {
  region = "us-east-1"
}

# FAIL: S3 bucket with public access and no versioning, no encryption
resource "aws_s3_bucket" "vulnerable_bucket" {
  bucket = "qscanner-test-vulnerable-bucket"
  acl    = "public-read"

  tags = {
    Name        = "qscanner-test"
    Environment = "test"
  }
}

# FAIL: No server-side encryption configured
# (aws_s3_bucket_server_side_encryption_configuration block intentionally missing)

# FAIL: No versioning
# (aws_s3_bucket_versioning block intentionally missing)

# FAIL: Security group allowing unrestricted SSH and all outbound traffic
resource "aws_security_group" "vulnerable_sg" {
  name        = "qscanner-test-sg"
  description = "Vulnerable security group for compliance testing"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # FAIL: unrestricted SSH
  }

  ingress {
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # FAIL: unrestricted RDP
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# FAIL: CloudTrail with logging disabled
resource "aws_cloudtrail" "vulnerable_trail" {
  name                          = "qscanner-test-trail"
  s3_bucket_name                = aws_s3_bucket.vulnerable_bucket.id
  include_global_service_events = false
  enable_logging                = false  # FAIL: logging disabled
  enable_log_file_validation    = false  # FAIL: no log file validation
}
