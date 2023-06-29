owner              = "yash"
aws_region_us_east = "us-east-1"
aws_region_us_west = "us-west-1"
bucket_name        = "ubuntu-focal-golden-image"
bucket_description = "Organizational foundational golden image, based on on Ubuntu 20.04"
tags = {
  owner          = "yash"
  ttl            = "-1"
  config-as-code = "packer"
  repo           = "ykhemani/packer-ubuntu-focal"
}
