# public key for access ec2 instance via ssh
resource "aws_key_pair" "devops" {
  key_name   = "${var.tag_env}-devops"
  public_key = var.id_rsa
}
