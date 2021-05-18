# apache

This example uses multipass and an apache install to demonstrate how the apache monitor can be used.

## Install the Splunk OTel Connector
* Create an ubuntu vm

```
multipass launch -n apache-example -d 4G -m 4G
multipass shell apache-example
```
* In Splunk IM, go to the **Data Setup** page, select **Linux**, optionally select an access token and click **Next**, and copy the setup code and paste it in your vm. (You can instead copy the command below and replace **\<REALM>** with your realm and **\<ACCESS_TOKEN>** with yiour token.)

```
curl -sSL https://dl.signalfx.com/splunk-otel-collector.sh > /tmp/splunk-otel-collector.sh && \
sudo sh /tmp/splunk-otel-collector.sh --realm <REALM> -- <ACCESS_TOKEN> --mode agent --without-fluentd
```
* Verify your agent is working with ```journalctl -u splunk-otel-collector -f```
  * Confirm 'Everything is ready'
* Verify host is visible in Splunk IM - Infrastructure / My Data Center (Hosts). It may take a few minutes to appear.

## Install Apache
* Run the following to install Apache

```
sudo apt update
sudo apt -y install apache2
```


## Verify it is running

```
curl -s localhost | grep title
```

and confirm you see something like: **Apache2 Ubuntu Default Page: It works**

# Apache Configuration and OTelCol Monitor Configuration 
The instructions below are based on the documentation, but the latest information will always be available in documentation and should be followed.

## Apache Configuration

* mod_status should already be enabled
* Add the following to /etc/apache2/apache2.conf

```
ExtendedStatus on
<Location /mod_status>
SetHandler server-status
</Location>
```
* Restart apache with ```sudo apachectl restart```
* Test mod_status with ```curl localhost/mod_status?auto```
  * You should see lines like: ```ServerVersion: Apache/2.4.41 (Ubuntu)```


## OTel Collector Configuration

* Edit ```/etc/otel/collector/agent_config.yaml``` and add the following to the ```receivers``` section:

```
receivers:
  smartagent/apache:
    type: collectd/apache
    host: localhost
    port: 80
```
* Add the new receiver to the pipeline (service/pipelines/metrics/receivers). For example:

```
receivers: [hostmetrics, otlp, prometheus, signalfx, smartagent/signalfx-forwarder, smartagent/apache]
```

* Restart the agent

```
sudo systemctl restart splunk-otel-collector 
```

## Verify Results
* Login to Splunk Infrastructure
  * Navigate to **Dashboards**, Open **Apache** and click on **Apache Web Servers**
