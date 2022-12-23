variable "rds" {
  default     = {}
  description = "A map of RDS configuraion."
  type        = map(any)
}

variable "aws_region" {
  type        = string
  description = "AWS region"
}

variable "default_tags" {
  type        = map(string)
  default     = {}
  description = "Standard tags to add to deployed resources"
}
