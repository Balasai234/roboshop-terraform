variable "project" {
  type = string
    default = "roboshop"
}
variable "environment" {
  type = string
  default = "dev"
}
variable "frontend_sg_name" {
  type = string
  default = "roboshop-sg"
  
}
variable "frontend_sg_description" {
  type = string
  default = "Security group for Roboshop application"
}
variable "bastion_sg_name" {
  type = string
  default = "bastion-sg"
  
}
variable "bastion_sg_description" {
  type = string
  default = "Security group for Bastion host"
}
variable "mongodb_ports_vpn" {
  type = list(string)
  default = ["27017","22"]
}
variable "redis_ports_vpn" {
  type = list(string)
  default = ["6379","22"]
}
variable "mysql_ports_vpn" {
    default = ["22", "3306"]
}
variable "rabbitmq_ports_vpn" {
  type = list(string)
  default = ["5672","22"]
  
}