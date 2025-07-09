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
variable "zone_id" {
  type = string
  default = "Z05939662N1222ETTVGZT"
}
variable "zone_name" {
  type = string
  default = "roboshop.fun"
}