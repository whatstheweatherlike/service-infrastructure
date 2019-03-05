whatstheweatherlike AWS experiments
===

Infrastructure creation code for hosting the [`weather-service` REST backend](https://github.com/whatstheweatherlike/weather-service) in [AWS](http://aws.amazon.com) via an [ECS](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ECS_clusters.html) [EC2](https://aws.amazon.com/ec2/) cluster behind an [ALB](https://docs.aws.amazon.com/elasticloadbalancing/latest/application/introduction.html).

Requirements:
* an [aws account](https://portal.aws.amazon.com/gp/aws/developer/registration/index.html)
* terraform install \
  `brew install terraform`
* aws cli \
  `brew install awscli`
* an appid required to use [The Openweathermap API](https://openweathermap.org/api)
* an environment variable `APPID` set to above mentioned value \
  `export APPID=your_app_id`

In a nutshell
---

**Prerequisites:**

Currently the service roles for ECS need to be created manually. This is done while running [Getting started with ECS](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ECS_GetStarted_EC2.html). There the first cluster is created from within the AWS console.

**Creation:**

```bash
$ cd cert
$ ./create-self-signed-cert.sh
$ cd ..
$ ./terraform plan
$ ./terraform apply
```

**Destruction:**

```bash
$ ./terraform destroy
```
