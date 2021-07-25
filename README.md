Raspberry Pi Cluster Setup
=========

Setup and configure a node that will belong to a Raspberry Pi cluster

Requirements
------------

Raspberry Pi 3 (ARM v7)  
Stretch  

Static IP address and hostname of new node configured.  

Public keys must exist on all nodes being configured.  
Add IPs of new nodes to hosts file  

Run
--------------
```bash
ansible-playbook playbook.yml -i \<hosts file\> --vault-id @prompt --private-key \<path to private key here\>
```

To target a specific task:
```bash
$ ansible-playbook playbook.yml -i <path to hosts file> --vault-id @prompt --private-key <path to private key here> --tags "container-image-registry"
```

Adding a new Secret
--------------
```bash
$ ansible-vault encrypt_string --vault-id @prompt "10.10.10.1" --name 'container_images_host_ip'
```
* Must use the same password as prompted during "Run" section.
