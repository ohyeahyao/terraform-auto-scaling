variable "general_autoscaling_group" {
  type = object({
    names  = list(string)
    emails = list(string)
  })
  default = {
    names  = [],
    emails = []
  }
}
