# Deployment

The recommended way to deploy OpenMU is through Docker. Depending on the scale
you need, we provide multiple ways to do that.

## All-in-one

The [all-in-one deployment](/all-in-one/) is recommended, if you want to host on
a small machine with a low amount of players.
In this case, all kinds of OpenMU subsystems (ConnectServer, GameServer, LoginServer,
AdminPanel, ...) are running in one process.

### Pros

* No communication overhead between subsystems, therefore slightly faster
* Simpler deployment
* Smaller memory footprint. Since we run all in one process, we don't have the
  overhead of multiple processes, runtimes and can share data.
* Easier to observe and debug, no additional tools required
  
### Cons

* Harder to scale - only by scaling up your single machine
* Lower resiliency. If one subsystem crashes the process, the whole thing goes
  down
* It's a more or less self-contained system which is harder to extend

## All-in-one with Traefik as Reverse Proxy

The [all-in-one with traefik deployment](/deploy/all-in-one-traefik/) is recommended,
if you want to host on a small machine with a low amount of players and want to host
your MuOnline Website on the same machine.

Once Traefik works as a Reverse Proxy, you can handle miltiple website without
change the default port to HTTP/HTTPS connections.

Addin a few labels to your container, you will tell Traefik how to handle incoming
requests and he will redirect to the correct website.

### Pros

* No communication overhead between subsystems, therefore slightly faster
* Simpler deployment
* Smaller memory footprint. Since we run all in one process, we don't have the
  overhead of multiple processes, runtimes and can share data.
* Easier to observe and debug, no additional tools required
* You can have multi websites with auto renew SSL Certificates
* Expose only 80 and 443 ports for websites and admin panel.
  Traefik knows what to do
  
### Cons

* Harder to scale - only by scaling up your single machine
* Lower resiliency. If one subsystem crashes the process, the whole thing goes
  down
* It's a more or less self-contained system which is harder to extend
