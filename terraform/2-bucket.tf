
#  creating S3 input/output Buckets

resource "aws_s3_bucket" "input_bucket" {
  bucket = "doc-uploads-${random_string.suffix.result}"
  force_destroy = true
}

resource "aws_s3_bucket" "output_bucket" {
  bucket = "doc-translated-${random_string.suffix.result}"
  force_destroy = true
}
#  Random Suffix (unique bucket names)
resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}
