variable "security_group_id" {
  type = string
}

variable "launch_template" {
  type = object({
    name            = string
    instance_type   = string
    hostname_prefix = string
    image_id        = string
  })
}

variable "key_name" {
  type = string
}
