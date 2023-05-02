variable "pip_name" {
    default = "vpn-gw-pip"
}
variable "resource_group_name" {
    type = string
}
variable "location" {
    type = string
}
variable "name" {
    type = string
}
variable "type" {
    type = string
    default = "vpn"
}
variable "vpn_type" {
    type = string
    default = "RouteBased"
}
variable "active_active" {
    type = bool
    default = false
}
variable "enable_bgp" {
    type = bool
    default = false
}
variable "sku" {
    type = string
    default = "VpnGw2"

}
variable "subnet_id" {
    type = string
}
 variable "tags" {
    default = {}
 }