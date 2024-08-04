locals {
  public_key = file("${path.module}/files/ssh-devops.pub")
}

resource "aws_key_pair" "devops" {
  key_name   = "tf-devops"
  public_key = local.public_key

  tags = {
    CreatedBy = "Terraform"
  }
}
