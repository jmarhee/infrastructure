# Krebstar Lab

This is a repository of the roles used to configure various class of machines in the Krebstar lab (`krebstar.internal`), but are generalized for public use. All unique data is provided to the role in a top-level playbook, not within the roles contained here.

## Roles

The following roles are available:

### Docker

The `docker` role configures Docker, and adds non-root user to the `docker` group. Usage looks like this:

```yaml
- hosts:
   - docker_hosts
 become: true
 roles:
         - { role: docker, docker_user: "jmarhee" }
```

### Sudoers

The `sudoers` role creates a `NOPASSWD:ALL` permissed non-root user in the `sudoers` group:

```yaml
- hosts:
   - all
 become: true
 roles:
         - { role: sudoers, nonroot_super_user: "jmarhee" }
```

### DNS

The `dns` role caches by configuration your DNS entries for an internal resolver powered by dnsmasq. You define your records using a standard dict, passed in the `vars` block of your playbook to the role:

```yaml
 - hosts:
     - dns_servers
   become: true
   roles:
           - { role: dns }
   vars:
     records:
       swarm.east.krebstar.internal: 
         hostname: "swarm.east.krebstar.internal"
         address: "192.168.122.129"
         description: "Swarm Manager Dashboard"
       dns.east.krebstar.internal: 
         hostname: "dns.krebstar.internal"
         address: "192.168.122.130"
         description: "DNS Server"
       storage.west.krebstar.internal:
         hostname: "anton.mli.krebstar.internal"
         address: "192.168.0.30"
         description: "Read Only Storage Viewer"
```

where `hostname`, `address`, and `description` are required values. `description` is added as a comment to the config file placed at `/etc/dnsmasq.d/{{ hostname }}.conf`

### Self-Signed Cert Service

The `cert-service` role generates an Nginx server block, and a certificate, for services being proxied to. You will only need to define a `common_name` and `backend_addr`:

```yaml
 - hosts:
     - swarm_leaders
   become: true
   roles:
           - { role: cert-service, common_name: "data.east.krebstar.internal", backend_addr: "http://192.168.122.120:8888" }
```

### CA-Signed Cert Service

The `ca-signed-cert-service` role uses a predefined CA keypair to sign a certificate. Like the `cert-service` role, a `common_name` and `backend_addr` is required, but also a `ca_cert_name` and `ca_key_path`:

```yaml
 - hosts:
      - drone_ci
   become: true
   vars:
    ca_cert_name: "rootCA"
    ca_key_path: "/etc/ssl/private/rootCA.key"
   roles:
          - { role: ca-signed-cert-service, common_name: "drone.krebstar.internal", backend_addr: "http://127.0.0.1:80" }
```
