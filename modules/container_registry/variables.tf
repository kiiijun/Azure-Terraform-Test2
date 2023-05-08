variable "name" {
  default = "zentestacr"
  type    = string
}
variable "resource_group_name" {
  type = string
}
variable "location" {
  type = string
}
variable "sku" {
  default = "Premium"
  type    = string
}
variable "admin_enabled" {
  default = false
  type    = bool
}

