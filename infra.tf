# Route 53 Hosted Zone
# 4 records

provider "aws" {
    region = "ap-southeast-2"
    default_tags {
        tags = {
            Project = "presidential-debate"
        }
    }
}

terraform {
  backend "s3" {
    bucket = "terraform-state-backend-jc"
    key    = "presidential-debates/terraform.tfstate"
    region = "ap-southeast-2"
  }
}

resource "aws_s3_bucket" "redirect" {
    bucket = "www.theworstdebate.com"
    force_destroy = true
    website {
        redirect_all_requests_to = "http://theworstdebate.com"
    }
}

resource "aws_s3_bucket" "host" {
    bucket = "theworstdebate.com"
    acl = "public-read"
    force_destroy = true
    policy = file("host-policy.json")
    website {
        index_document = "index.html"
    }
}

resource "aws_s3_bucket_object" "index" {
  bucket = aws_s3_bucket.host.id
  key    = "index.html"
  source = "index.html"
}
