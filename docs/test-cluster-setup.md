# Test Cluster Setup
It's important to be able to set up a test cluster to play with, tear down, stand up again.  There are
tools you can use to set up test clusters like minikube and Docker Desktop.  There is even a way to setup
a completely containerized cluster.  I am working on a configuration using multiple VMs, which is closer
to how you would establish a cluster in production.

## Summary of Steps
### For each machine in the cluster
1. Root access
   - The newest Fedora installations under VMware use the same password for the non-root user that is set
     up and for the root user.  We might want to change the password for the root user.
   - Ubuntu does not set a password for the root user when a VM is created under VMware Workstation.  We
     need to set the root password.
1. Change the hostname
   How important are the contents of /etc/hosts?
   - Immediately, the contents of /etc/hosts can be recreated, overwriting whatever is in currently in
     the file.  I would want 127.0.0.1, 127.0.1.1, and ::1 (even though we are not using any IPv6
     networking).
   - It is convenient if the cluster members can _at least_ locate the cluster master(s).
   - If we are using static addresses for each of the cluster members, we will know the addresses for the
     cluster master(s).
   - If we start with a clone of a base k8s VM, the /etc/hosts file would already be set up properly.
     Otherwise, it would be easy to append the k8s master address(es) to the file as each subsequent
     machine is set up.
1. Replace /etc/hosts with standard file with the machine's new name
1. Configure with a static IP address
    * May need to set up NetworkManager first
1. Disable Swap
```bash
sed -i '/^[^#]/ s/\(^.*swap.*$\)/#\ \1/' /etc/fstab
```
Then reboot!
1. Upgrade all common applications
1. Install vim & customize
1. Install dircolors
1. Install PD
1. Install custom git config
1. (Optional) Set up custom prompt
1. Install docker
   I would prefer to do this from the docker repository and not from the OS package repos.
1. Install kubelet, kubeadm, kubectl
1. Lock versions of kubelet, kubeadm, and kubectl so that they will not be updated automatically but need
   to be updated specifically.
1. Make name of k8s master resolvable (_e.g._ use `/etc/hosts`)

### K8s Master
1. Initialize the cluster
1. Make `kubectl` available to a regular user
1. Set bash up shell completiong
1. Install Pod Network Add-on

### Add Worker Nodes


## Hostnames
## Networking
## Disable Swap
## Common Installation
## Initiatlize Cluster on Master Node
## Set Up K8s Networking with Calico
## Set Up Worker Node
## Add Worker Node
## Add Master Node
