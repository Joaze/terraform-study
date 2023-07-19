resource "aws_s3_bucket" "web-app" {
#  bucket = "web-app"
  bucket_prefix = "web-app-data-terraform"
  force_destroy = true

  tags = {
    Name        = "web-app"
    Environment = "Production"
  }
}

resource "aws_s3_bucket_versioning" "versioning_web-app" {
  bucket = aws_s3_bucket.web-app.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "crypto-conf-web-app" {
  bucket = aws_s3_bucket.web-app.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "AES256"
    }
  }
}
