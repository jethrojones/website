---
last_modified_at:
permalink: AIforLinux
description: installing Omarchy on a T2 2019 Intel MacBook Air. This detailed walkthrough, supported by AI insights, navigates the complexities of setting up a new operating system on older hardware. Learn from the challenges and solutions encountered during the installation process, including bootloader setup, macOS blessing, user configuration, networking, and more. Perfect for tech enthusiasts looking to breathe new life into their MacBook Air with Arch Linux and Omarchy.
title: Should I use AI for to Install Omarchy on a MacBook Air with a T2 Chip?
image:
published: "true"
sitemap: "true"
excerpt_separator: <!--more-->
category:
tags:
date: 2025-08-27
layout: note
---
I've tried this a couple times, and it just didn't work. So I figured I would try to document it. 

Big thanks to ChatGPT for helping me figure out a lot of things to accomplish this difficult task of installing a new operating system on an old machine. This stretched me. 

I've been going back and forth about when to use AI and when not to use it. It's not always easy to know the right answer. 

[[Ethan Mollick on Knowing When to Use AI]] said that you shouldn't use it for those things for which a productive struggle would be valuable. 

This was a case of unproductive struggle if I had refrained from using AI! 

I would have just given up. 

AI gave me enough support that I could get over the hump and actually finish installing it. If you take a look at my very [long ChatGPT thread](https://chatgpt.com/share/68b0cf65-ebc8-800f-893f-8f0b822269ae), you will see that there were many times where I literally had no idea at all what was wrong. Taking a picture with my phone and continuing the conversation with ChatGPT was truly remarkable. 

I have enough experience with coding, command line, and Linux to know that it is exceptionally frustrating for me. 

This took several hours and lots of hard work to make it happen. 

I started by following this great resource [t2Linux](https://wiki.t2linux.org/guides/preinstall/). This links to the pre-install guide. 

I flashed a drive using [BalenaEtcher](https://etcher.balena.io/), as [described here](https://learn.omacom.io/2/the-omarchy-manual/50/getting-started).

Then I rebooted the mac  with the Arch install on a a connected USB drive by holding down the option key and chose the far right EFI option. 

I followed this [guide](https://wiki.t2linux.org/distributions/arch/installation/): steps 1, 2, 3 (didn't partition, but did format and mount my selected drive) 

I follwoed the rest of the guide, but got caught up on this step: 3B: Mount the EFI partition. 

I had to mount it with this command: 

```
sudo mkdir -p /mnt/boot
sudo mount /dev/nvme0n1p1 /mnt/boot
```

Doing that made it so that the boot loader would mount. 

After working through all of that with ChatGPT, I had it create a step-by-step solution for me, as seen below, with a few comments added in by me. 

Should I have written this all out by myself? Perhaps. Would it have helped me learn even more? Probably. Would it have been as helpful and clear? Probably not. 

# Arch + Omarchy Install Guide for T2 MacBook Air

## 1. Bootloader (systemd-boot)

1. Mount partitions:
    
    `mount /dev/nvme0n1p4 /mnt mount /dev/nvme0n1p1 /mnt/boot arch-chroot /mnt`
    
2. Install systemd-boot:
    
    `bootctl --esp-path=/boot install`
    
3. Create boot entry `/boot/efi/loader/entries/arch.conf`:
    
    `title   Arch Linux linux   /vmlinuz-linux-t2 initrd  /initramfs-linux-t2.img options root=UUID=<your-root-uuid> rw quiet splash intel_iommu=on iommu=pt pcie_ports=compat`
    
    Replace `<your-root-uuid>` with `blkid` output.
    
4. Verify:
    
    `bootctl list --esp-path=/boot/efi`
    

---

## 2. macOS Blessing

If Mac keeps booting into macOS:

`sudo bless --mount /Volumes/EFI\ 1 --setBoot --file /Volumes/EFI\ 1/EFI/systemd/systemd-bootx64.efi --shortform nvram -p | grep efi-boot-device`

---

## 3. Users + Sudo

`pacman -S sudo gum useradd -m -G wheel -s /bin/bash jethro passwd jethro`

Enable wheel in sudoers:

`EDITOR=nano visudo`

Uncomment:

`%wheel ALL=(ALL:ALL) ALL`

---

## 4. Networking

### Ethernet (systemd-networkd)

Create `/etc/systemd/network/20-wired.network`:

`[Match] Name=enp6s0u1u4 [Network] DHCP=ipv4`

Enable:

`systemctl enable --now systemd-networkd systemctl enable --now systemd-resolved ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf`

### Wi-Fi (iwd)

Connect with:

`iwctl station wlan0 scan station wlan0 get-networks station wlan0 connect "SSID"`

### Force IPv4

Edit `/etc/iwd/main.conf`:

`[General] EnableNetworkConfiguration=true  [Network] EnableIPv6=false`

Restart:

`systemctl restart iwd systemctl restart systemd-resolved`

Verify:

`ip addr show wlan0 ping -4 -c3 google.com`

---

## 5. Install NetworkManager (optional, easier Wi-Fi)

After you have internet:

`pacman -S networkmanager systemctl enable --now NetworkManager`

Then you can use:

`nmcli device wifi connect "SSID" password "password"`

---

## 6. Install Omarchy

Run as your **user** (not root):

`curl -fsSL https://omarchy.org/install | bash`

This pulls from GitHub and installs Omarchy into your environment.

{% if page.image %} <img src="{{ page.image }}" alt=""> {% endif %}