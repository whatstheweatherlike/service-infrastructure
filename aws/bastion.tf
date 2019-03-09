resource "aws_key_pair" "weather_service" {
  key_name   = "weather-service-deploy-user-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCvA+Fi1/d65EbhJoj5aJI/FVXAqtfOk8M3E0evm/TiMiaA3s1gDHAnA3JjEw2wwOGvTreQPYOZe1p0B7Aly68VYNg8k5RxWqYuT7VT9EwlAvkr9U1ulwxCkny3Vq+TVEY5RAcp0Fe1vqCED6AXy0c43HBhxK4AfVleiy7ZvV1FqFTlgrxLvAGFtFrL75WlDrOmihUER1sd3sM30nDYuO5zlry+729vr16s84dIDzFbOS18nbdPuUrO32U49R45ypkfrwdBHG59vVXTJXwlfEpQ40Z/7iucotRitDmal0hAd4Q6FWeIfxtDaF/XX6G7rz+1TazjYw8JeHVbqHXRANez9w95q//T2kZEzu51zTbDDahjee39QZuDZPVhKb4u1tbzaVwNq7z5u8nEmbSyQyyjWu7g3ygJiiUQCVPZTDyY39O/Y1iTHzA9C4XaNoguLGCpOVxVbv7DAh5sFtT9vGEY96i6QBb8G6Ct/Nb8UILvSAPvSgK1EccVP3wvdjobBXohNgRKQiT4pIfC5WSSgC94K8uuCeGPkhcK3rKVKkNcX86jbhqsJtDUbZ05/6bDxLS3hDBPYSBeZpK9XEPjh2TkSk31oJmrOPbL36O+0hVFzBzU6n43wXdRai50bfBZt6bOazoJkjkPKiL6HbBXwDnGdARWZMmaMyTS/wZGXxOevQ== daniel.hiller.1972@gmail.com"
}

data "aws_ami" "bastion" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ami-hvm-*-x86_64-ebs"]
  }

}
resource "aws_launch_configuration" "bastion" {
  security_groups = [
    "${aws_security_group.bastion.id}",
  ]

  associate_public_ip_address = true

  name   = "${aws_ecs_cluster.weather_service.name}-bastion-lc"
  image_id      = "${data.aws_ami.bastion.image_id}"
  instance_type = "t2.micro"

  key_name = "${aws_key_pair.weather_service.key_name}"

  lifecycle {
    create_before_destroy = true
  }

}

resource "aws_autoscaling_group" "bastion" {
  name = "${aws_ecs_cluster.weather_service.name}-bastion-asg"
  vpc_zone_identifier  = ["${aws_subnet.weather_service.*.id}"]
  desired_capacity   = 0
  max_size           = 1
  min_size           = 0

  launch_configuration = "${aws_launch_configuration.bastion.name}"
}

resource "aws_security_group" "bastion" {
  description = "controls direct access to bastion instance"
  vpc_id      = "${aws_vpc.weather_service.id}"
  name        = "weather-service-bastion-inst-sg"

  ingress {
    protocol  = "tcp"
    from_port = 22
    to_port   = 22

    cidr_blocks = ["${var.deployer_cidr}"]
  }

  egress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22

    cidr_blocks = ["${aws_vpc.weather_service.cidr_block}"]
  }
}
