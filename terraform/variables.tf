variable "aws_region" {
  default = "ap-south-1"
}

variable "instance_type" {
  default = "t2.micro"
}
variable "key_name" {
  description = "Name of the existing AWS key pair"
  default     = "mykey"
}
variable "app_port" {
  default = 3000
}
