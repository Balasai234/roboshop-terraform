variable "project" {
  description = "The name of the project"
  type        = string
  default     = "roboshop"
}
variable "environment" {
  description = "The environment for the project (e.g., dev, prod)"
  type        = string
  default     = "dev"
  
}
variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24","10.0.2.0/24"]
}
variable "private_subnet_cidrs" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.5.0/24","10.0.7.0/24"]
}
variable "database_subnet_cidrs" {
  description = "List of CIDR blocks for database subnets"
  type        = list(string)
  default     = ["10.0.10.0/24","10.0.11.0/24"]
}