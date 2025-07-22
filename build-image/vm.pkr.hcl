packer {
    required_plugins {
        qemu = {
            version = "~> 1"
            source  = "github.com/hashicorp/qemu"
        }
        vagrant = {
            version = "~> 1"
            source = "github.com/hashicorp/vagrant"
        }
        virtualbox = {
            version = "~> 1"
            source  = "github.com/hashicorp/virtualbox"
        }
    }
}

source "virtualbox-iso" "practice-vm" {
    vm_name = "practice-vm"
    guest_os_type = "Ubuntu_64"
    hard_drive_discard = true
    format = "ova"
    iso_url = "https://releases.ubuntu.com/jammy/ubuntu-22.04.5-desktop-amd64.iso"
    iso_checksum            = "file:https://releases.ubuntu.com/jammy/SHA256SUMS"
    output_directory = "build"
    headless = true
    memory = 4096
    cpus = 4
    vboxmanage = [
        ["modifyvm", "{{.Name}}", "--vram", "128"]
    ]
    vrdp_bind_address = "0.0.0.0"
    communicator = "ssh"
    ssh_pty = true
    ssh_username = "ubuntu"
    ssh_password = "ubuntu"
    ssh_timeout = "10h"
    shutdown_command  = "echo 'ubuntu' | sudo -S shutdown -P now"
    shutdown_timeout = "10h"
    http_directory = "cloud-init"
    boot_command = [
        "<wait>e",
        "<wait><down><down><down><end><left><left><left><left> autoinstall ip=dhcp cloud-config-url=http://{{.HTTPIP}}:{{.HTTPPort}}/autoinstall.yaml<wait><f10><wait>"
    ]
}

build {
    sources = ["sources.virtualbox-iso.practice-vm"]

    # Setup for development
    provisioner "shell" {
        inline = [
            # Disable auto-dimming the screen
            "gsettings set org.gnome.desktop.session idle-delay 0",

            # Enable dark mode by default
            "gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'",

            # Fix the boot lagging issue (we already have NetworkManager)
            "echo 'ubuntu' | sudo -S systemctl disable systemd-networkd",

            # Patch compiler error
            "echo 'ubuntu' | sudo -S ln -s /usr/include/x86_64-linux-gnu/asm /usr/include/asm",

            # Setup Virtualbox clipboard
            "echo 'ubuntu' | sudo -S VBoxClient --clipboard",

            # Pull down the required repository
            "git clone https://github.com/easy-ebpf/lab ~/Desktop/lab",

            # Install additional tools
            "curl https://storage.googleapis.com/git-repo-downloads/repo > /bin/repo && chmod a+x /bin/repo",
            "sudo -u ubuntu bash scripts/setup-repo.sh"
        ]
    }

    # Optimize VM size
    provisioner "shell" {
        inline = [
            "echo 'ubuntu' | sudo -S apt-get autoremove",
            "echo 'ubuntu' | sudo -S apt-get clean",
            "echo 'ubuntu' | sudo -S rm -rf /var/log/*",
            "echo 'ubuntu' | sudo -S fstrim /"
        ]
    }
}
