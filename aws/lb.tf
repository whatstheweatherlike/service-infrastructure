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

resource "aws_lb" "weather_service" {
  name               = "weather-service-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.lb.id}"]
  subnets            = ["${aws_subnet.weather_service.*.id}"]

  enable_deletion_protection = false
}

resource "aws_lb_listener" "weather_service" {
  load_balancer_arn = "${aws_lb.weather_service.id}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_lb_target_group.weather_service.id}"
    type             = "forward"
  }
}
