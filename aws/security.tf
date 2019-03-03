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

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }
}

resource "aws_security_group" "instance" {
  description = "controls direct access to application instances"
  vpc_id      = "${aws_vpc.weather_service.id}"
  name        = "weather-service-ecs-instsg"

  ingress {
    protocol  = "tcp"
    from_port = 22
    to_port   = 22

    // FIXME: all access areas is not good!
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol  = "tcp"
    from_port = 32768
    to_port   = 61000

    security_groups = [
      "${aws_security_group.lb.id}",
    ]
  }

  ingress {
    protocol  = "tcp"
    from_port = 8080
    to_port   = 8080

    // FIXME: all access areas is not good!
    cidr_blocks = ["0.0.0.0/0"]

    //    security_groups = [
//      "${aws_security_group.lb.id}",
//    ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
