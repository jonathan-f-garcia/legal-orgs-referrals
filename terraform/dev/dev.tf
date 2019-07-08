// This block tells Terraform that we're going to provision AWS resources.
provider "aws" {
  region = "us-east-1"
  version = "~> 2.18"
}

// Create a variable for our version and domain name because we'll be using it a lot.
variable "app_version" {
}

variable "domain_name" {
}

resource "aws_s3_bucket" "jpfg" {
  // Our bucket's name is going to be the same as our site's domain name.
  bucket = "${var.domain_name}.${var.app_version}"
  // Tag our project for cost-allocation purposes
  tags = {
    Project = "${var.domain_name}"
    Version = "${var.app_version}"
    Environment = "Development"
  }
  // Because we want our site to be available on the internet, we set this so
  // anyone can read this bucket.
  acl    = "public-read"
  // We also need to create a policy that allows anyone to view the content.
  // This is basically duplicating what we did in the ACL but it's required by
  // AWS. This post: http://amzn.to/2Fa04ul explains why.
  policy = <<POLICY
{
  "Version":"2012-10-17",
  "Statement":[
    {
      "Sid":"AddPerm",
      "Effect":"Allow",
      "Principal": "*",
      "Action":["s3:GetObject"],
      "Resource":["arn:aws:s3:::${var.domain_name}.${var.app_version}/*"]
    }
  ]
}
POLICY

  // S3 understands what it means to host a website.
  website {
    // Here we tell S3 what to use when a request comes in to the root
    // ex. https://www.runatlantis.io
    index_document = "choose-issue.html"
    // The page to serve up if a request results in an error or a non-existing
    // page.
    // error_document = "404.html"
  }
}