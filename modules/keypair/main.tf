resource "aws_key_pair" "sshkey" {
  key_name   = "${var.env}-sshkey"
  public_key = file("${path.module}/lab.pub")
  tags = merge(
    var.default_tags, {
      "Name" = "${var.prefix}-${var.env}-sshkey"
    }
  )
}
