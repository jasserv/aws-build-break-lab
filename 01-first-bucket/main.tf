# ---------------------------------------------------------
# PROVIDER: tells Terraform which cloud to talk to and how
# ---------------------------------------------------------
variable "floci_endpoint" {
  description = "URL of the local FLOCI AWS simulator"
  type        = string
  default     = "http://localhost:4566"
}

provider "aws" {
  region     = "ap-southeast-1" # AWS region (Singapore). Floci accepts any region
  access_key = "test"           # fake credentials, because Floci doesn't check them
  secret_key = "test"

  skip_credentials_validation = true # don't ask real AWS "are these keys valid?"
  skip_requesting_account_id  = true # don't ask real AWS for the account ID
  s3_use_path_style           = true # use localhost:4566/bucket instead of bucket.localhost

  endpoints {
    s3  = var.floci_endpoint
    iam = var.floci_endpoint
    sts = var.floci_endpoint
  }

}

# ---------------------------------------------------------
# 1. THE BUCKET AND A FILE INSIDE IT
# ---------------------------------------------------------
resource "aws_s3_bucket" "data" {
  bucket = "lab-data-bucket" # the real bucket name in Floci (must be unique and lowercase)

  # force_destroy = true       # optional: lets "terraform destroy" delete a bucket
  # even if it contains files Terraform didn't create
}

resource "aws_s3_object" "hello" {
  bucket  = aws_s3_bucket.data.id # put it in the bucket above (this link also sets build order)
  key     = "hello.txt"           # the file name inside the bucket
  content = "hello from floci"    # the text stored in the file
}

# ---------------------------------------------------------
# 2. THE USER WHO SHOULD ONLY BE ABLE TO READ
# ---------------------------------------------------------
resource "aws_iam_user" "reader" {
  name = "lab-reader" # the IAM user's name
}

resource "aws_iam_access_key" "reader" {
  user = aws_iam_user.reader.name # create an access key + secret for that user
  # (these are what the AWS CLI "reader" profile uses)
}

# ---------------------------------------------------------
# 3. THE PERMISSIONS (the policy attached to the user)
# ---------------------------------------------------------
resource "aws_iam_user_policy" "reader_policy" {
  name = "read-only"              # the policy's name
  user = aws_iam_user.reader.name # attach it to the reader user

  # jsonencode converts Terraform syntax into the JSON that AWS policies require
  policy = jsonencode({
    Version = "2012-10-17" # policy language version; always use this value

    Statement = [
      {
        Effect   = "Allow"                # this rule grants permission (the other option is "Deny")
        Action   = ["s3:ListBucket"]      # allowed action: see which files are in the bucket
        Resource = aws_s3_bucket.data.arn # applies to the BUCKET itself (no /*)
      },
      {
        Effect   = "Allow"
        Action   = ["s3:GetObject"]              # allowed action: read/download a file
        Resource = "${aws_s3_bucket.data.arn}/*" # applies to the FILES inside (note the /*)
      }
    ]
    # No s3:PutObject anywhere, so uploads are denied. AWS denies anything not explicitly allowed
  })
}

# ---------------------------------------------------------
# OUTPUTS: values Terraform prints after "apply"
# ---------------------------------------------------------
output "reader_access_key" {
  value = aws_iam_access_key.reader.id # the access key ID (like a username)
}

output "reader_secret_key" {
  value     = aws_iam_access_key.reader.secret # the secret key (like a password)
  sensitive = true                             # hide it from screen output; read it with
  # "terraform output -raw reader_secret_key"
}