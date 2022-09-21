# Collectd nfsiostat

Collectd custom can be used with collectd plugins, like [nfsiostat](https://github.com/cernops/collectd-nfsiostat).

See [documentation here](https://docs.splunk.com/Observability/gdi/collectd/collectd.html).

This example will show how to configure this for the OTel Collector

## OTel Config Snippet
```
receivers:
  smartagent/nfsiostat:
    type: collectd/custom
    template: |
      TypesDB "/home/ubuntu/collectd-nfsiostat/resources/nfsiostat_types.db"
      <LoadPlugin python>
        Globals true
      </LoadPlugin>
      <Plugin "python">
        LogTraces true
        Interactive false
        Import "collectd_nfsiostat"
        <Module "collectd_nfsiostat">
          Mountpoints "/myshareclient"
          NFSOps "READLINK" "GETATTR"
        </Module>
      </Plugin>

service:
  pipelines:
    metrics:
      receivers: [hostmetrics, otlp, signalfx, smartagent/signalfx-forwarder, smartagent/nfsiostat]
      processors: [memory_limiter, batch, resourcedetection]
      exporters: [signalfx]
```

## Install the plugin
This example should install the plugin into the path of the agent-bundle.

You would need to ensure those same files are deployed with each agent that needs the plugin.
```
cd ~
git clone https://github.com/cernops/collectd-nfsiostat.git
cd collectd-nfsiostat/
sudo /usr/lib/splunk-otel-collector/agent-bundle/bin/python setup.py install
```

## Setup nfs client and server
```
sudo apt update
sudo apt install -y nfs-common nfs-kernel-server
```

## Setup share
```
sudo mkdir -p /home/ubuntu/myshare
sudo chown nobody:nogroup /home/ubuntu/myshare
sudo chmod 777 /home/ubuntu/myshare
sudo vi /etc/exports
```
And add the following line:
```
/home/ubuntu/myshare  127.0.0.1
```
And restart:
```
sudo exportfs -a
sudo systemctl restart nfs-kernel-server
```

## Setup mount
```
sudo mkdir -p /myshareclient
sudo chown nobody:nogroup /myshareclient
sudo mount -t nfs localhost:/home/ubuntu/myshare /myshareclient
```

## Restart the agent
```
sudo systemctl restart splunk-otel-collector.service 
```

## Result
Metrics will be created for the share, for example:
```
queue.GETATTR
rtt.GETATTR
execute.GETATTR
errs.GETATTR
timeouts.GETATTR
ops.GETATTR

queue.READLINK
rtt.READLINK
execute.READLINK
errs.READLINK
timeouts.READLINK
ops.READLINK
```

Create/edit/read files to see the metrics change.