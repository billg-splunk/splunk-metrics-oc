# postgresql

This example uses docker and docker-compose to show how PostgreSQL can be collected by the OTel Collector.

## Pre-requisites
You need docker to run this example.

## To use

* Edit ```.env``` and supply your realm and token
* Run ```./start.sh```

## Results
You will get your Postgres Dashboards populated.

## When Done

* Run ```./stop.sh```

## Notes
Review [postgresql.yaml](config/postgresql.yaml) to see how this is configured in the otel collector.

Review [docker-compose.yml](docker-compose.yml) and [01_configure_postgres.sh](sql/01_configure_postgres.sh) to see how Postgres needs to be configured for the receiver to collect what it needs to.

This example was made for non-production use (plaintext passwords, non-persistent data, etc.)