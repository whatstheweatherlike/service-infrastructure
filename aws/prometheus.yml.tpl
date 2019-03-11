global:
  scrape_interval: 15s
  external_labels:
    monitor: 'weather-service'

scrape_configs:
  - job_name: 'weather-service'
    static_configs:
      - targets: [${hosts}]