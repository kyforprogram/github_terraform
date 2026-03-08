variable "name" {
  type = string
}

variable "cidr_block" {
  type = string
}

variable "tags" {
  type = map(string)
}
variable "subnets" {
  type = map(object({
    type = string
    az   = string
    cidr = string
  }))
}