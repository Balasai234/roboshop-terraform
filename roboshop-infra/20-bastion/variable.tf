variable "project" {
  default = "roboshop"
  type        = string
  
}

variable "environment" {
  default = "dev"
  type        = string

}
variable "var_tags" {
  type = map(string)
  default = {
    Project     = "Roboshop"
    Environment = "development"
    terraform   = "true"
  }
  
}