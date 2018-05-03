Setup an EC2 instance
---------------------
Create first an EC2 instance from a Debian-based flavor.
- Make sure that the EC2 is available publicly via SSH. Then, copy the SSH Key provided by Cloud9 when trying to connect to an existing instance in `~/.ssh/authorized_keys`
- Install a capable machine depending on the project. A project using Docker extensively requires both extra hard-drive space and memory.

Installation script
-------------------
The script will install zsh and setup a elixir/phoenix development environment.

```
cd
wget https://raw.githubusercontent.com/civilcode/cloud9-bootstrap/master/install.sh
sh ./install.sh
```

Format watcher for linux
--------------------------------

Script skeleton for incremental `mix format` when a file is touched.
``` {.bash}
#!/bin/bash

inotifywait -m ~/environment -e modify,create -e moved_to |
    while read path action file; do
        if [[ $file =~ \.ex$ ]]; then
                echo "('$action') The file '$path/$file' will be formatted"
                mix format $path/$file
        fi
    done
```

Testing
--------------------------------
The script has been primarily tested with a CentOS distribution, which is a RHEL-based distribution using the `yum` package manager. The default distribution used by Cloud9 uses this also uses the `yum` package manager.
## Installation on VirtualBox
- Download an ISO (Everything or possibly Minimal) from a mirror: http://centos.mirror.iweb.ca/7/isos/x86_64/
- Setup a machine with sufficient hard drive space (~15Gb if Everything) and memory (~4Gb)
- Set the optical drive of the machine with the downloaded ISO
- Start the Virtual Machine(VM) and follow the installation instructions
- Once installed, you might want a desktop environment with the Guest Additions installed
- Guest Additions installation by the command line:
  - Find a suitable ISO for your version at https://download.virtualbox.org/virtualbox/
  - Set that ISO to the optical drive of the virtual machine
  - Create a mount directory ar `mkdir -p /opt/cdrom`
  - Mount the iso on the guest with `mount /mnt/cdrom /opt/cdrom`
  - Run `/opt/cdrom/VBoxLinuxAdditions.run`
  - You might want need to install requiring tools: `yum install dkms gcc make kernel-dev bzip2 binutils patch libomp glic-headers glibc-devel kernel-headers`
- Install a desktop environment:
  - Activate the network by running `dhclient`
  - Install the Gnome environment `yum -y groups install "GNOME Desktop"` (for other desktop environment, check [this](https://unix.stackexchange.com/questions/181503/how-to-install-desktop-environments-on-centos-7#181504))
  - launch X11 with `startx`
