# Configure ovn-bgp agent with devstack
sudo sysctl -w net.ipv6.conf.all.disable_ipv6=0
sudo apt-get install -y git vim tmux

sudo mkdir /opt/stack
sudo chown vagrant:root /opt/stack
cd /opt/stack/
git clone https://opendev.org/openstack/ovn-bgp-agent

cd
git clone https://opendev.org/openstack/devstack

cd devstack

git checkout "stable/2024.1"

sudo tee ./local.conf <<EOF
[[local|localrc]]

HOST_IP=$(hostname -I | awk '{print $2}')

DATABASE_PASSWORD=password
RABBIT_PASSWORD=password
SERVICE_PASSWORD=password
SERVICE_TOKEN=password
ADMIN_PASSWORD=password

Q_AGENT=ovn
Q_ML2_PLUGIN_MECHANISM_DRIVERS=ovn,logger
Q_ML2_PLUGIN_TYPE_DRIVERS=local,flat,vlan,geneve
Q_ML2_TENANT_NETWORK_TYPE="geneve"

# Enable devstack spawn logging
LOGFILE=$DEST/logs/stack.sh.log

enable_service ovn-northd
enable_service ovn-controller
enable_service q-ovn-metadata-agent

# Use Neutron
enable_service q-svc

# Disable Neutron agents not used with OVN.
disable_service q-agt
disable_service q-l3
disable_service q-dhcp
disable_service q-meta

TARGET_BRANCH="stable/2024.1"

# Enable services, these services depend on neutron plugin.
enable_plugin neutron https://opendev.org/openstack/neutron "stable/2024.1"
enable_service q-trunk
enable_service q-dns
enable_service q-port-forwarding
enable_service q-qos
enable_service neutron-segments
enable_service q-log

# Horizon (the web UI) is enabled by default. You may want to disable
# it here to speed up DevStack a bit.
enable_service horizon
# disable_service horizon

# Cinder (OpenStack Block Storage) is disabled by default to speed up
# DevStack a bit. You may enable it here if you would like to use it.
disable_service cinder c-sch c-api c-vol
#enable_service cinder c-sch c-api c-vol

# Enable SSL/TLS
ENABLE_TLS=True
enable_service tls-proxy

# Enable ovn-bgp-agent
enable_plugin ovn-bgp-agent https://opendev.org/openstack/ovn-bgp-agent "stable/2024.1"

# Enable the networking-bgpvpn plugin
enable_plugin networking-bgpvpn https://git.openstack.org/openstack/networking-bgpvpn.git "stable/2024.1"


# Whether or not to build custom openvswitch kernel modules from the ovs git
# tree. This is disabled by default.  This is required unless your distro kernel
# includes ovs+conntrack support.  This support was first released in Linux 4.3,
# and will likely be backported by some distros.
# NOTE(mjozefcz): We need to compile the module for Ubuntu Bionic, because default
# shipped kernel module doesn't openflow meter action support.
OVN_BUILD_MODULES=True
OVN_BUILD_FROM_SOURCE=true
OVN_BRANCH=main
OVS_BRANCH=branch-3.3


# If the admin wants to enable this chassis to host gateway routers for
# external connectivity, then set ENABLE_CHASSIS_AS_GW to True.
# Then devstack will set ovn-cms-options with enable-chassis-as-gw
# in Open_vSwitch table's external_ids column.
# If this option is not set on any chassis, all the of them with bridge
# mappings configured will be eligible to host a gateway.
ENABLE_CHASSIS_AS_GW=True

[[post-config|$NOVA_CONF]]
[scheduler]
discover_hosts_in_cells_interval = 2
EOF