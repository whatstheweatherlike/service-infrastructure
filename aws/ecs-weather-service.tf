resource "aws_ecs_service" "weather_service" {
  name            = "weather-service"
  cluster         = "${aws_ecs_cluster.weather_service.id}"
  task_definition = "${aws_ecs_task_definition.weather_service.arn}"
  desired_count   = 2
  depends_on      = ["aws_autoscaling_group.weather_service"]

  ordered_placement_strategy {
    type  = "spread"
    field = "instanceId"
  }

  load_balancer {
    target_group_arn = "${aws_lb_target_group.weather_service.arn}"
    container_name   = "weather-service-latest"
    container_port   = 8080
  }

}

resource "aws_ecs_task_definition" "weather_service" {
  family                = "weather-service"
  container_definitions = "${module.weather_service_container_definition.json}"

  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone in [eu-central-1a, eu-central-1b, eu-central-1c]"
  }

  // FIXME container definitions force new task definition creation everytime, maybe need to use json instead?
  lifecycle {
    ignore_changes = [
//      "container_definitions"
    ]
  }

}

module "weather_service_container_definition" {
  source  = "git::https://github.com/cloudposse/terraform-aws-ecs-container-definition.git"

  container_name  = "weather-service-latest"
  container_image = "docker.io/whatstheweatherlike/weather-service:latest"

  container_memory = 512

  environment = [{
    name  = "APPID"
    value = "${var.APPID}"
  }]

  port_mappings = [{
    containerPort = 8080
    hostPort      = 8080
    protocol      = "tcp"
  }]

  healthcheck = {
    command = ["curl -f http://localhost:8080/actuator/health || exit 1"],
    interval = 60,
    retries = 3,
    startPeriod = 60
  }

  log_options = {
    awslogs-region = "${var.aws_region}"
    awslogs-group = "/ecs/${aws_ecs_cluster.weather_service.name}"
  }

}

resource "aws_lb" "weather_service" {
  name               = "weather-service-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.lb.id}"]
  subnets            = ["${aws_subnet.weather_service.*.id}"]

  enable_deletion_protection = false
}

resource "aws_iam_server_certificate" "weather_service" {
  name_prefix      = "weather-service-cert"
  certificate_body = "${file("cert/cert.pem")}"
  private_key      = "${file("cert/key.pem")}"

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_lb_listener" "weather_service" {
  load_balancer_arn = "${aws_lb.weather_service.id}"
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn = "${aws_iam_server_certificate.weather_service.arn}"

  default_action {
    target_group_arn = "${aws_lb_target_group.weather_service.id}"
    type             = "forward"
  }
}

resource "aws_lb_listener" "weather_service_http_redirect" {
  load_balancer_arn = "${aws_lb.weather_service.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_target_group" "weather_service" {
  name     = "weather-service-target-group"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = "${aws_vpc.weather_service.id}"

  health_check = {
    path = "/actuator/health",
    port = 8080
  }
}

resource "aws_security_group" "lb" {
  description = "controls access to the application ELB"

  vpc_id = "${aws_vpc.weather_service.id}"
  name   = "weather-service-ecs-lbsg"

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }
}

