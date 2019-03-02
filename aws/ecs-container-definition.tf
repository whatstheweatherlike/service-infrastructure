module "weather-service-container-definition" {
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
    hostPort      = 80
    protocol      = "tcp"
  }]

  healthcheck = {
    command = ["curl -f http://localhost/actuator/health || exit 1"],
    interval = 60,
    retries = 3,
    startPeriod = 60
  }

  log_options = {
    awslogs-region = "${var.aws_region}"
    awslogs-group = "/ecs/${aws_ecs_cluster.weather-service.name}"
  }

}