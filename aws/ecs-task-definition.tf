resource "aws_ecs_task_definition" "weather-service" {
  family                = "weather-service"
  container_definitions = "${module.weather-service-container-definition.json}"

  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone in [eu-central-1a, eu-central-1b, eu-central-1c]"
  }
}