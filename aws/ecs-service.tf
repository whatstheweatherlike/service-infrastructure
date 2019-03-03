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