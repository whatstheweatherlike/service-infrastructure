resource "aws_ecs_service" "weather-service" {
  name            = "weather-service"
  cluster         = "${aws_ecs_cluster.weather-service.id}"
  task_definition = "${aws_ecs_task_definition.weather-service.arn}"
  desired_count   = 3
//  iam_role        = "arn:aws:iam::839822666115:role/aws-service-role/ecs.amazonaws.com/AWSServiceRoleForECS"
  depends_on      = ["aws_autoscaling_group.ecs-cluster-weather-service"]

  ordered_placement_strategy {
    type  = "binpack"
    field = "cpu"
  }

//  load_balancer {
//    target_group_arn = "${aws_lb_target_group.foo.arn}"
//    container_name   = "mongo"
//    container_port   = 8080
//  }

}