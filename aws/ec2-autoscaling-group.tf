resource "aws_key_pair" "weather_service" {
  key_name   = "weather-service-deploy-user-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCvA+Fi1/d65EbhJoj5aJI/FVXAqtfOk8M3E0evm/TiMiaA3s1gDHAnA3JjEw2wwOGvTreQPYOZe1p0B7Aly68VYNg8k5RxWqYuT7VT9EwlAvkr9U1ulwxCkny3Vq+TVEY5RAcp0Fe1vqCED6AXy0c43HBhxK4AfVleiy7ZvV1FqFTlgrxLvAGFtFrL75WlDrOmihUER1sd3sM30nDYuO5zlry+729vr16s84dIDzFbOS18nbdPuUrO32U49R45ypkfrwdBHG59vVXTJXwlfEpQ40Z/7iucotRitDmal0hAd4Q6FWeIfxtDaF/XX6G7rz+1TazjYw8JeHVbqHXRANez9w95q//T2kZEzu51zTbDDahjee39QZuDZPVhKb4u1tbzaVwNq7z5u8nEmbSyQyyjWu7g3ygJiiUQCVPZTDyY39O/Y1iTHzA9C4XaNoguLGCpOVxVbv7DAh5sFtT9vGEY96i6QBb8G6Ct/Nb8UILvSAPvSgK1EccVP3wvdjobBXohNgRKQiT4pIfC5WSSgC94K8uuCeGPkhcK3rKVKkNcX86jbhqsJtDUbZ05/6bDxLS3hDBPYSBeZpK9XEPjh2TkSk31oJmrOPbL36O+0hVFzBzU6n43wXdRai50bfBZt6bOazoJkjkPKiL6HbBXwDnGdARWZMmaMyTS/wZGXxOevQ== daniel.hiller.1972@gmail.com"
}

resource "aws_launch_configuration" "weather_service" {
  security_groups = [
    "${aws_security_group.instance.id}",
  ]

  associate_public_ip_address = true

  name   = "${aws_ecs_cluster.weather_service.name}-ecs-cluster-lc"
  image_id      = "${data.aws_ami.amazon_linux_ecs.image_id}"
  instance_type = "t2.micro"

  key_name = "${aws_key_pair.weather_service.key_name}"

  iam_instance_profile = "${aws_iam_instance_profile.ecs_cluster.name}"

  user_data = "#!/bin/bash\necho ECS_CLUSTER=${aws_ecs_cluster.weather_service.name} > /etc/ecs/ecs.config"

  lifecycle {
    create_before_destroy = true
  }

}

resource "aws_autoscaling_group" "weather_service" {
  name = "${aws_ecs_cluster.weather_service.name}-ecs-cluster-asg"
  vpc_zone_identifier  = ["${aws_subnet.weather_service.*.id}"]
  desired_capacity   = 2
  max_size           = 3
  min_size           = 1

  launch_configuration = "${aws_launch_configuration.weather_service.name}"
}