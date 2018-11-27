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
ansible-playbook playbook.yml -i \<hosts file\> --private-key \<private key here\>
