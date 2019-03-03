data "aws_availability_zones" "available" {}

resource "aws_vpc" "weather_service" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "weather_service" {
  count             = "${var.az_count}"
  cidr_block        = "${cidrsubnet(aws_vpc.weather_service.cidr_block, 8, count.index)}"
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  vpc_id            = "${aws_vpc.weather_service.id}"
}

resource "aws_internet_gateway" "weather_service" {
  vpc_id = "${aws_vpc.weather_service.id}"
}

resource "aws_route_table" "weather_service" {
  vpc_id = "${aws_vpc.weather_service.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.weather_service.id}"
  }
}

resource "aws_route_table_association" "weather_service" {
  count          = "${var.az_count}"
  subnet_id      = "${element(aws_subnet.weather_service.*.id, count.index)}"
  route_table_id = "${aws_route_table.weather_service.id}"
}