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

  // FIXME Error: aws_ecs_task_definition.weather-service: ECS Task Definition container_definitions is invalid: Error decoding JSON: json: cannot unmarshal string into Go struct field HealthCheck.Command of type []*string
  healthcheck = {
    //    command = "curl -f http://localhost/actuator/health || exit 1",
    //    interval = "60",
    //    retries = 3,
    //    startPeriod = 60
  }

  log_options = {
    awslogs-region = "eu-central-1"
    awslogs-group = "/ecs/weather-service"
  }

}

output "container-definition-json" {
  value = "${module.weather-service-container-definition.json}"
}
