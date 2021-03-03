# Test Cluster Setup
It's important to be able to set up a test cluster to play with, tear down, stand up again.  There are
tools you can use to set up test clusters like minikube and Docker Desktop.  There is even a way to setup
a completely containerized cluster.  I am working on a configuration using multiple VMs, which is closer
to how you would establish a cluster in production.

## GUI on First Master
In a production system, where using the K8s Dashboard is not as important or where it can be configured
as a service with a certificate and TLS access, it is not necessary to provide a GUI on any of the K8s
nodes.  In a test lab, especially one designed to for learning K8s, however, it is important to have a
GUI on the first node in the cluster so that we can take advantage of GUI tools, such as the K8s
Dashboard, without having to know anything else, like how to expose it as a service.

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
    * Ubuntu Desktop already uses NetworkManager instead of systemd-networkd
1. Disable Swap
```bash
$ sed -i '/^[^#]/ s/\(^.*swap.*$\)/#\ \1/' /etc/fstab
```
    * On Fedora 33, the swap system has been moved to `systemd` and uses `zram0`.  Disable it with the
      following commands.
      ```bash
      $ systemctl stop swap-create@zram0
      $ touch /etc/systemd/zram-generator.conf
      $ dnf remove zram-generator-defaults
      ```

Then reboot!
1. Customize instance
    1. Upgrade all common applications
    1. Install vim & customize
    1. Install dircolors
    1. Install PD
    1. Install custom git config
    1. (Optional) Set up custom prompt
1. Install docker  
   * I would prefer to do this from the docker repository and not from the OS package repos.
   * [Install Docker from Docker Repository](https://docs.docker.com/engine/install/ubuntu/)
1. Install kubelet, kubeadm, kubectl
    * Need to disable selinux
    > Setting SELinux in permissive mode by running setenforce 0 and sed ... effectively disables it.
    > This is required to allow containers to access the host filesystem, which is needed by pod networks
    > for example. You have to do this until SELinux support is improved in the kubelet.
    >
    > You can leave SELinux enabled if you know how to configure it but it may require settings that are
    > not supported by kubeadm.

1. Lock versions of kubelet, kubeadm, and kubectl so that they will not be updated automatically but need
   to be updated specifically.
   * On Fedora, this is done with `--disableexcludes=kubernetes` and a line in the K8s repo config file.
1. Make name of k8s master resolvable (_e.g._ use `/etc/hosts`)
    - I find it useful to use aliases for each of the hosts.
        * Masters: k8s-m0#
        * Workers: k8s-w0#
      This way, the machine names can be whatever you want, while making it easy to reference the correct
      node in the cluster.


### K8s Master
1. Initialize the cluster
    - I find it useful to set the log level to 2 so that I can see the progress of the initialization. If
    you use the default output, the screen is just static for a long time without any feedback, which I
    do not like.
    `kubeadm -v 2 init --control-plane-endpoint k8s-m01:6443 --pod-network-cidr 10.0.0.0/16`
    > The pod network is completely separate from the host's and VM's networks.  It is a totally
    > separate, managed network space for K8s.
    - I am curious about creating multiple networks using VMware.
        * Each VM needs to access the internet.
        * Each VM needs to access the other machines in the network.
        * I need to be able to reach the network from the host to admin the cluster and to experience the
          value of running applications in the cluster.
        * It might be useful if the network could be isolated from other networks.
1. Make `kubectl` available to a regular user
1. Set bash up shell completiong
1. Install Pod Network Add-on

### Add Worker Nodes
1. Adding a worker node after the K8s master node's original join command has expired (24 hours)
    * kubeadm token create --print-join-command

1. 

## Hostnames
## Networking
## Disable Swap
## Common Installation
## Initiatlize Cluster on Master Node
## Set Up K8s Networking with Calico
## Set Up Worker Node
## Add Worker Node
## Add Master Node
