data "aws_ami" "prometheus" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ami-hvm-*-x86_64-ebs"]
  }

}

data "template_file" "prometheus_config" {
  template = "${file("prometheus.yml.tpl")}"
  vars {
    hosts = "'${join(":8080', '", data.aws_instances.weather_service_ecs_cluster.private_ips)}:8080'"
  }
}

data "template_file" "prometheus_user_data" {
  template = "${file("prometheus_user_data.tpl")}"
  vars {
    prometheus_config = "${data.template_file.prometheus_config.rendered}"
  }
}

resource "aws_launch_configuration" "prometheus" {
  security_groups = [
    "${aws_security_group.prometheus.id}",
  ]

  associate_public_ip_address = true

  name   = "${aws_ecs_cluster.weather_service.name}-prometheus-lc"
  image_id      = "${data.aws_ami.prometheus.image_id}"
  instance_type = "t2.micro"

  key_name = "${aws_key_pair.weather_service.key_name}"

  user_data = "${data.template_file.prometheus_user_data.rendered}"

  lifecycle {
    create_before_destroy = true
  }

}

resource "aws_autoscaling_group" "prometheus" {
  name = "${aws_ecs_cluster.weather_service.name}-prometheus-asg"
  vpc_zone_identifier  = ["${aws_subnet.weather_service.*.id}"]
  desired_capacity   = 0
  max_size           = 1
  min_size           = 0

  launch_configuration = "${aws_launch_configuration.prometheus.name}"
}

resource "aws_security_group" "prometheus" {
  description = "controls direct access to prometheus instance"
  vpc_id      = "${aws_vpc.weather_service.id}"
  name        = "weather-service-prometheus-inst-sg"

  ingress {
    protocol  = "tcp"
    from_port = 22
    to_port   = 22

    cidr_blocks = ["${aws_vpc.weather_service.cidr_block}"]
  }

  egress {
    description = "to scrape weather-service targets"
    protocol    = "tcp"
    from_port   = 8080
    to_port     = 8080

    cidr_blocks = ["${aws_vpc.weather_service.cidr_block}"]
  }

  egress {
    description = "to download prometheus from github"
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

}
