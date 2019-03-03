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
      "container_definitions"
    ]
  }
}