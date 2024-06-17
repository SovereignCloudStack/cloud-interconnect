# Cloud interconnection 

This repository contains a collection of scripts, configurations, and Vagrantfiles for setting up and experimenting with various OVN and BGP scenarios.

The technical solution for Cloud Interconnect has been presented on https://www.meetup.com/open-operations-meetup/events/300324062/. Slides can be found here - https://scs.community/assets/slides/20240422-SCS-Cloud-Interconnectivity-5cd7fd2d3567f2ced997ef34dbaf7c687132c17ad2883fb0a61ca2bff3d4ccb7570ce9c5ff4c91bfec41d9804b4ad549709ed648dbcd738475f9dab8fa50ee93.pdf

## Goal

This repository contains code and script to create a virtual devstack environment which simulates two cloud providers connected via L3 VPN (MPLS). Devstack clouds have been configured with networking-bgpvpn plugin. OVN-BGP-Agent and FRR to enable this interconnectivity. 

## Getting Started

Please refer to files in each directory for specific instructions on how to use the scripts and configurations.
The [devstack-ovn-bgp-agent](devstack-ovn-bgp-agent/) directory contains the latest scripts, configurations and instructions for setting up a devstack environment with OVN BGP agent.

## Prerequisites

- Vagrant
- VirtualBox or Libvirt
- Git

## References

This repository is based on https://github.com/luis5tb/vagrants.

Software:
- [networking-bgpvpn](https://docs.openstack.org/networking-bgpvpn/latest/)
- [ovn-bgp-agent](https://opendev.org/openstack/ovn-bgp-agent)
- [frr](https://docs.frrouting.org/)
- [scs](https://scs.community/)
- [openstack](https://www.openstack.org/)
- [neutron](https://docs.openstack.org/neutron/latest/)