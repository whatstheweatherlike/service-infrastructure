resource "aws_ecs_cluster" "weather_service" {
  name = "weather-service"
}

resource "aws_autoscaling_group" "weather_service" {
  name = "${aws_ecs_cluster.weather_service.name}-ecs-cluster-asg"
  vpc_zone_identifier  = ["${aws_subnet.weather_service.*.id}"]
  desired_capacity   = 2
  max_size           = 3
  min_size           = 1

  launch_configuration = "${aws_launch_configuration.weather_service.name}"
}

resource "aws_launch_configuration" "weather_service" {
  security_groups = [
    "${aws_security_group.ecs_ec2_instance.id}",
  ]

  associate_public_ip_address = true

  name   = "${aws_ecs_cluster.weather_service.name}-ecs-cluster-lc"
  image_id      = "${data.aws_ami.ecs_image.image_id}"
  instance_type = "t2.micro"

  key_name = "${aws_key_pair.weather_service.key_name}"

  iam_instance_profile = "${aws_iam_instance_profile.ecs_cluster.name}"

  user_data = "#!/bin/bash\necho ECS_CLUSTER=${aws_ecs_cluster.weather_service.name} > /etc/ecs/ecs.config"

  lifecycle {
    create_before_destroy = true
  }

}

data "aws_ami" "ecs_image" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ami-*-amazon-ecs-optimized"]
  }

}

resource "aws_security_group" "ecs_ec2_instance" {
  description = "controls direct access to ecs cluster ec2 instances"
  vpc_id      = "${aws_vpc.weather_service.id}"
  name        = "weather-service-ecs-ec2-inst-sg"

  ingress {
    protocol  = "tcp"
    from_port = 22
    to_port   = 22

    cidr_blocks = ["${aws_vpc.weather_service.cidr_block}"]
  }

  ingress {
    protocol  = "tcp"
    from_port = 8080
    to_port   = 8080

    security_groups = [
      "${aws_security_group.lb.id}",
    ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_iam_instance_profile" "ecs_cluster" {
  name = "${aws_ecs_cluster.weather_service.name}-ecs-cluster-ip"
  role = "${aws_iam_role.ecs_cluster.name}"
}

resource "aws_iam_role_policy_attachment" "ecs_ec2_role" {
  role       = "${aws_iam_role.ecs_cluster.id}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_role_policy_attachment" "ecs_ec2_cloudwatch_role" {
  role       = "${aws_iam_role.ecs_cluster.id}"
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}

resource "aws_iam_role" "ecs_cluster" {
  name = "${aws_ecs_cluster.weather_service.name}-ecs-cluster-iam-role"

  assume_role_policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": ["ec2.amazonaws.com"]
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}
