Raspberry Pi Cluster Setup
=========

Setup and configure a node that will belong to a Raspberry Pi cluster

## Requirements

- Raspberry Pi 3 (ARM v7)  
- Stretch image (currently using [Raspbian 9.8 (stretch)](https://downloads.raspberrypi.org/raspbian_lite/images/raspbian_lite-2019-04-09/))
- Static IP address and hostname of new node being configured.
- Public keys from host applying configuration must exist on all nodes being configured.  
- Add IPs of new nodes to the hosts file specified below.

## Pre-configuration Steps
(The preconfiguration steps below assume a Mac OS)

1. Flash image onto disk
```bash

$ diskutil list # Identify target disk, /dev/disk6 in this example

$ diskutil unmountDisk /dev/disk6
Unmount of all volumes on disk6 was successful
 
$ sudo dd if=/Downloads/2019-04-08-raspbian-stretch-lite.img of=/dev/disk6

```
2. Enable SSH.  Recently flashed disk will automatically mount a `boot` volume
```bash
$ touch /Volumes/boot/ssh
```

3. Unmount disk, plug into raspberry pi and plug in power

4. Configure static IP address (IP can be found via router or if Pi is plugged into monitor, IP will be shown)
```bash
$ vi /etc/dhcpcd.conf
 
static ip_address=192.168.0.101/24
static routers=192.168.0.1
static domain_name_servers=8.8.8.8 8.8.4.4
```
5. Configure hostname
```bash
$ sudo raspi-config
```

6. Copy private key to node (copy from existing node or from applying host):
```bash
$ cat .ssh/authorized_keys
 
...
 
$ touch .ssh/authorized_keys
$ chmod 644 .ssh/authorized_keys
```

7. Reboot node
8. Follow steps below


## Build
```bash
$ docker build -t rpi-cluster-setup:test .
````  

## Apply configuration

```bash
docker run --rm -it -v $(pwd):/data -v ~/.ssh:/keys rpi-cluster-setup:test /bin/bash

ansible-playbook /data/playbook.yml -i /data/hosts -u pi --vault-id @prompt --private-key \<path to private key here\>
```

To target a specific task:
```bash
$ ansible-playbook /data/playbook.yml -i /data/hosts -u pi --vault-id @prompt --private-key <path to private key here> --tags "container-image-registry"
```

## Post-configuration Steps

1. Configure storage access

2. Add node to Kubernetes Cluster.  From master node:
```bash
$ kubeadm token create --print-join-command
kubeadm join 192.168.0.100:6443 --token bgo6nm.oanwz3a1vpedjgno     --discovery-token-ca-cert-hash sha256:58f814efe4245395c52f8da27251374b718d39fdb3d15d9dba08922178b1eec9
```

then, from new node:
```bash
$ kubeadm join 192.168.0.100:6443 --token bgo6nm.oanwz3a1vpedjgno     --discovery-token-ca-cert-hash sha256:58f814efe4245395c52f8da27251374b718d39fdb3d15d9dba08922178b1eec9
```

3. Add labels to new node
```bash
kubectl label nodes node-3 network=gbit
```

### Adding a new Secret
```bash
$ ansible-vault encrypt_string --vault-id @prompt "10.10.10.1" --name 'container_images_host_ip'
```
* Must use the same password as prompted during "Run" section.
