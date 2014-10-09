puppet-grafanadash
==================

This is just a dev module; it installs a very simple configuration of
graphite, grafana, and elasticsearch.  Tested only on a clean cent6 box.

WARNING: totally insecure.  Turns off selinux and iptables.  Enables CORS on apache.

Usage:

    puppet module install cprice404-grafanadash

    puppet apply -e 'include grafanadash::dev'

Graphite will be started on port 80.  Grafana on port 10000.
