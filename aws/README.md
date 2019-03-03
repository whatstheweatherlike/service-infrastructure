whatstheweatherlike AWS experiments
===

Infrastructure creation code for hosting the [`weather-service` REST backend](https://github.com/whatstheweatherlike/weather-service) in [AWS](http://aws.amazon.com) via an [ECS](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ECS_clusters.html) [EC2](https://aws.amazon.com/ec2/) cluster behind an [ALB](https://docs.aws.amazon.com/elasticloadbalancing/latest/application/introduction.html).

Requirements:
* an [aws account](https://portal.aws.amazon.com/gp/aws/developer/registration/index.html)
* terraform install \
  `brew install terraform`
* aws cli \
  'brew install awscli'
* an appid required to use [The Openweathermap API](https://openweathermap.org/api)

In a nutshell
---

**Prerequisites:**

Currently there need to be created the service roles for the ECS manually. This is done during the first tutorial where
the first cluster is created from within the AWS console.

**Creation:**

```bash
$ ./terraform plan
$ ./terraform apply
```

**Destruction:**

```bash
$ ./terraform destroy
```
