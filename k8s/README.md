whatstheweatherlike Kubernetes experiments
===

Infrastructure creation code for `weather-service` in Kubernetes.

Requirements:
* [minikube](https://kubernetes.io/docs/setup/minikube/)
* an appid required to use [The Openweathermap API](https://openweathermap.org/api)

In a nutshell
---

**`test_in_minikube.sh` - Run weather_service in minikube**

Use `test_in_minikube.sh` to create a minikube deployment and expose the service, then execute a GET request against the REST service.

The script will exit with a non zero code if the service responds with anything else than HTTP status 200.

TODO:
[ ] include prometheus
