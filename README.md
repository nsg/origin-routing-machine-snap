# Origin Routing Machine (ORM)
[![Snap Status](https://build.snapcraft.io/badge/nsg/origin-routing-machine-snap.svg)](https://build.snapcraft.io/user/nsg/origin-routing-machine-snap) [![origin-routing-machine](https://snapcraft.io//origin-routing-machine/badge.svg)](https://snapcraft.io/origin-routing-machine)

ORM is a reverse proxy configuration generator. It generates configuration for HAProxy and Varnish to perform HTTP routing and rewriting, backed by a user friendly YAML config format called ORM rules with built-in collision detection.

For more information see the documentation in the upstream repository at [github.com/SVT/orm](https://github.com/SVT/orm/blob/1.2.0/README.md).

This snap only contains the ORM python package, HAProxy and Varnish need to be installed separately.

## ORM traffic flow

ORM is just a python application that reads YAML files, verifies them and then outputs HAProxy and Varnish configuration files. The traffic flows like the graph below, ORM assumes HAProxy and Varnish is installed on the same system.

```
                    Client
                       |
                       V
             +----> HAProxy    TLS termination and ingress
            /          |
           /           V
YAML --(ORM)------> Varnish    Rule engine and rewrites
           \           |
            \          V
             +----> HAproxy    Backend load balancing and routing
                       |
                       V
                    Server
```

## Install ORM
```
snap install origin-routing-machine
```

## Install HAProxy and Varnish

The [README](https://github.com/SVT/orm/blob/1.2.0/README.md) suggest to look at [deployment example](https://github.com/SVT/orm/tree/1.2.0/example). From this I see that is uses the Docker image [haproxy:alpine](https://hub.docker.com/_/haproxy) (latest version) and [custom Docker image](https://github.com/SVT/orm/blob/1.2.0/example/varnish/Dockerfile) using Varnish 6 + the module vmod_var 1.3. [Running](https://github.com/SVT/orm/blob/1.2.0/docs/running.md) also suggests to look at the [lxd folder](https://github.com/SVT/orm/tree/1.2.0/lxd). If Ansible & LXD is not your thing it can be a little hard to understand, but LXD is used to test ORM so I assume these versions are more tested. If you [look here](https://github.com/SVT/orm/blob/1.2.0/lxd/ansible/group_vars/all.yml) you see that in LXD HAProxy 1.8, Varnish 5.2.1 and vmod_var 1.2 is used.

From this, I assume HAproxy 1.8+, Varnish 5.2.1+ and any compatible vmod_var works with ORM. I [have asked](https://github.com/SVT/orm/issues/44) upstream to clarify this. There is also an [sample varnish.service](https://github.com/SVT/orm/blob/1.2.0/lxd/ansible/templates/varnish.service.j2) provided in the lxd directory.

## Use ORM

The command is called `origin-routing-machine`, do a `origin-routing-machine --help` to see the help page. Remember that this snap is contained inside a sandbox so it can't write to places like /etc/haproxy and so on. How to solve this is out of scope of this snap, but the easiest way is probably to either move the file your self, or just update the config path in HAProxy/Varnish.

Go to a writable location, if you intend to run this as a service, `/var/snap/origin-routing-machine/current/` is probably a better place.

```
$ cd ~/snap/origin-routing-machine/current/
```
Now run this command to generate a few sample ORM rules to get you started:

```
origin-routing-machine.generate-samples
```

And try them out!

```
origin-routing-machine --globals-path globals.yml --orm-rules-path 'sample-rules/*.yml' --output-dir .
```

If everything worked you should have a `haproxy.cfg` and a `varnish.vcl` ready for deployment.

For more information see [README](https://github.com/SVT/orm/blob/1.2.0/README.md) and [the cookbook](https://github.com/SVT/orm/blob/1.2.0/docs/rules-cookbook.md).
