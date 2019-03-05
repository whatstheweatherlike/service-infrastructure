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

On AWS Console under ECS you should see cluster `weather-service` now. One service `weather-service` should be ACTIVE. When clicking on it you should see the load balancer target group. When clicking on that, the load balancer should appear in the details section, if clicked the DNS name should appear.

Then after some time this should work:
```bash
$ curl -L --insecure -v http://weather-service-lb-xxxx.elb.amazonaws.com/weather-at/0.1,0.2
*   Trying <ip-address>...
* TCP_NODELAY set
* Connected to weather-service-lb-xxxx.elb.amazonaws.com (<ip-address>) port 80 (#0)
> GET /weather-at/0.1,0.2 HTTP/1.1
> Host: weather-service-lb-xxxx.elb.amazonaws.com
> User-Agent: curl/7.54.0
> Accept: */*
>
< HTTP/1.1 301 Moved Permanently
.....
* Ignoring the response-body
....
* SSL connection using TLSv1.2 / ECDHE-RSA-AES128-GCM-SHA256
* ALPN, server accepted to use h2
* Server certificate:
.....
* Using HTTP2, server supports multi-use
* Connection state changed (HTTP/2 confirmed)
* Copying HTTP/2 data in stream buffer to connection buffer after upgrade: len=0
* Using Stream ID: 1 (easy handle 0x7fac91000400)
> GET /weather-at/0.1,0.2 HTTP/2
> Host: weather-service-lb-xxxx.elb.amazonaws.com
> User-Agent: curl/7.54.0
> Accept: */*
>
* Connection state changed (MAX_CONCURRENT_STREAMS updated)!
< HTTP/2 200
< date: Tue, 05 Mar 2019 04:23:40 GMT
< content-type: application/json;charset=UTF-8
< content-disposition: inline;filename=f.txt
<
* Connection #1 to host weather-service-lb-xxxx.elb.amazonaws.com left intact
{"coord":{"lat":0.1,"lon":0.2},"weather":[{"id":804,"main":"Clouds","description":"overcast clouds","icon":"04n"}],"main":{"temp":28.79,"pressure":1010.34,"humidity":100.0,"temp_min":28.79,"temp_max":28.79,"sea_level":1010.34,"grnd_level":1010.35},"id":6295630,"name":"Earth","wind":{"speed":2.77,"deg":245},"clouds":{"all":88},"rain":null,"snow":null,"dt":1551759820,"cod":200}
```

**Destruction:**

```bash
$ ./terraform destroy
```
