# Collectd Custom

Collectd custom can be used to execute scripts and that are then converted to metrics.

See [documentation here](https://docs.splunk.com/Observability/gdi/collectd/collectd.html).

This example will show configuring a probe to check multiple domains. It was initially created by Rich Young and enhanced for OTel by Achim Staebler.

You may need to install parallel:
```
sudo apt install parallel
```

Also check permissions on the two files created (shell script and targets).

## OTel Config Snippet
```
receivers:
  smartagent/probe:
    type: collectd/custom
    template: |
      LoadPlugin exec
      <Plugin exec>
        Exec "splunk-otel-collector" "/usr/local/bin/probe"
      </Plugin>

processors:
  metricstransform/probes:
    transforms:
      - include: ^gauge\.(?P<target>.*)$
        match_type: regexp
        action: combine
        new_name: ping.latency
        submatch_case: lower

service:
  pipelines:
    metrics/probes:
      receivers: [smartagent/probe]
      processors: [memory_limiter, batch, resourcedetection, metricstransform/probes]
      exporters: [signalfx]
```

## /usr/local/bin/probe
```
#!/usr/bin/env bash

HOSTNAME="${COLLECTD_HOSTNAME:-$(hostname -f)}"
INTERVAL="${COLLECTD_INTERVAL:-10}"
TARGETS=/usr/local/etc/ping-targets
PING=/usr/bin/ping

_get_latency() {
    TARGET=$1
    AVERAGE=$($PING -c1 $TARGET | tail -n 1 | awk '{print $4}' | cut -d '/' -f 2)
    if [ "$AVERAGE" ]; then
        echo "PUTVAL "'"'"${HOSTNAME}/ping-average/gauge-${TARGET}"'"'" interval=${INTERVAL} N:${AVERAGE}"
    fi
}

export HOSTNAME INTERVAL PING
export -f _get_latency

while sleep "$INTERVAL"; do
   parallel -a $TARGETS _get_latency
done
```

## /usr/local/etc/ping-targets
```
google.com
yahoo.com
```

## Result
The result is a metric called ```ping.latency``` with a dimension of ```target```.
