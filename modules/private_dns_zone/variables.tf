variable "name" {
  type = string
}
variable "resource_group_name" {
  type = string
}
variable "tags" {
  default = {}
}

variable "virtual_networks_to_link" {
  type    = map(any)
  default = {}
}
