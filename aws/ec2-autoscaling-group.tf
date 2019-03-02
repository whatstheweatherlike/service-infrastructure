resource "aws_launch_configuration" "ecs-cluster-weather-service" {
  name   = "ecs-cluster-weather-service"
  image_id      = "${data.aws_ami.amazon_linux_ecs.image_id}"
  instance_type = "t2.micro"

  iam_instance_profile = "${aws_iam_instance_profile.ecs_cluster.name}"

  user_data = "#!/bin/bash\necho ECS_CLUSTER=${aws_ecs_cluster.weather-service.name} > /etc/ecs/ecs.config"

  lifecycle {
    create_before_destroy = true
  }

}

resource "aws_autoscaling_group" "ecs-cluster-weather-service" {
  name = "${aws_ecs_cluster.weather-service.name}"
  availability_zones = ["${var.aws_region}a", "${var.aws_region}b", "${var.aws_region}c"]
  desired_capacity   = 2
  max_size           = 3
  min_size           = 1

  launch_configuration = "${aws_launch_configuration.ecs-cluster-weather-service.name}"

}