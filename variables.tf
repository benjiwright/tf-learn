variable "subnet_prefix" {
  description = "cidr blocks for subnet"
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
  type        = list(string)
}

# AWS authentication variables
variable "aws_access_key" {
  type        = string
  description = "AWS Access Key"
}
variable "aws_secret_key" {
  type        = string
  description = "AWS Secret Key"
}
variable "aws_region" {
  type        = string
  description = "AWS Region"
  default     = "us-west-2"
}
variable "aws_azs" {
  type        = list(string)
  description = "AWS Availability Zones"
  default     = ["us-west-2a", "us-west-2b"]
}
