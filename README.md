# Cross-plateform-Kubernetes-Cluster-Installer

The goal of this project is to build an automated distributed, scalable kubernetes cluster to deploy projects on it.
The challenge is that that environment is multi-node and multi-machine.

This project contains a `Vagrantfile` and associated `Ansible` playbook scripts
to provisioning Kubernetes' cluster using `VirtualBox` as provider.

Different Vms are created, provisionned with a specific Os system.

I've used ansible as provision system, to auto-configure the Vms as master or worker.

Ansible is only Linus compatible, that's why, the ansible was installed into the different Vms.
And executed into it to install the required tools, and run the approprite script.

### Prerequisites
You need the following installed to use this playground.
- `Vagrant`, version 1.9.3 or better. Earlier versions of vagrant do not work
with the Vagrant Ubuntu 16.04 box and network configuration.
- `VirtualBox`, tested with Version 5.1.18 r114002
- Internet access, this playground pulls Vagrant boxes from the Internet as well
as installs Ubuntu application packages from the Internet.

### Bringing Up The cluster
To bring up the cluster, clone this repository to a working directory.

```
git https://github.com/zouariste/Cross-plateform-Kubernetes-Cluster-Installer.git
```
Change into the working directory and `vagrant up`

```
cd Cross-plateform-Kubernetes-Cluster-Installer

vagrant up
```

Vagrant will start three machines. Each machine will have a NAT-ed network
interface, through which it can access the Internet, and a `private-network`
interface in the subnet 192.168.2.50/24. The private network is used for
intra-cluster communication.

The machines created are:

| NAME              | IP ADDRESS   | ROLE           |
| ---               | ---          | ---            |
| Server-1-MASTER   | 192.168.2.50 | Cluster Master |
| Server-1-WORKER-1 | 192.168.2.51 | Cluster Worker |
| Server-1-WORKER-2 | 192.168.2.52 | Cluster Worker |

As the cluster brought up the cluster master (**master**) will perform a `kubeadm
init` and the cluster workers will perform a `kubeadmin join`. This cluster is
using a static Kubernetes cluster token.

To check the node created ssh to the master node and:
```
vagrant@Server-1-MASTER:~$ kubectl get nodes

NAME                STATUS   ROLES    AGE   VERSION
master              Ready    master   53m   v1.18.2
server-1-worker-1   Ready    <none>   49m   v1.18.2
```
