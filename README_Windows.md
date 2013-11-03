## Development QuickStart for Windows Machines

Usage of many of the tools on Windows requires a few additional steps. We'll keep those steps up to date here.

### Background

While the instructions are similar to those used to set up the VirtualBox/Vagrant setup for non-Windows
machines there are some common errors and a series of workarounds for those errors which needs to be
expressed to make setup easy. The goal of this tutorial is to set up a clean Windows machine from scratch
so that it can host a local copy of the Dashboard/Blockly webserver for debugging and editing purposes.

A shortened set of instructions can be found in the [general Readme][1]

### Supported Configurations

Be sure to turn on harware virtualization in your BIOS. This step was resulting in a blank screen on an
older system since we are standing up a 64-bit base OS. Also make sure your base OS is 64-bit.

Windows 8 - Works with an updated Vagrantfile to include the following port forwarding

```
config.vm.forward_port 3000, 8080
```

Windows 7 - Works with an updated Vagrantfile to include the following port forwarding

```
config.vm.forward_port 3000, 8080
```

For debugging VM failures it is useful to see the GUI. The default is headless so you have to change the
Vagrantfile if you want additional debugging support. Also, the environment variable VAGRANT_LOG=[ERROR|INFO]
can be useful as well.

```
config.vm.boot_mode = :gui
```

### Setup Instructions

#### Git Tools Setup

Setup requires Git and a Vagrant compatible version of SSH. While there are many versions of Git for Windows,
including distributions through GitHub that try to simplify the process for a Windows machine, these are not
necessarily going to let you get through all of the following steps without having to do additional work. For
that reason I recommend grabbing the standard Git distribution from:

[Git-SCM for Windows][2]

The default settings will work, but on the step "Adjusting your PATH Environment" I suggest taking the third
option which will set up your path to make both Git and the Unix tools available from your command prompt.
This simplifies running `vagrant ssh` later.

When "Configuring the line ending conversions" select the default which will convert the line-endings to Windows
format when opening files, but will convert back to Unix style line endings when committing. We've uploaded
a .gitattributes file which prevents this from breaking the .sh files needed by later steps.

#### Virtual Box

Virtual Box is a cross platform VM host. While HyperV could be used on Windows it would complicate the setup
steps and make it difficult to share setup across all of the contributors to the project.

[Install Virtual Box](https://www.virtualbox.org/wiki/Downloads)

You'll be asked to elevate and to install a series of device drivers. They are all necessary for Virtual Box
to function correctly so install them all. From multiple install phases this step has never required a reboot.

#### Vagrant

Vagrant is a VM management system which utilizes a base virtual machine and then provisions it with additional
services. Vagrant will require a reboot so after this step you'll have to restart, but all of the tools
necessary to complete the setup of the web server will now be on your machine and the following phases should
be more streamlined.

[Install Vagrant](http://downloads.vagrantup.com/)

Note: Use the MSI installer for whatever the latest version is. At the time of writing it was 1.3.5.

#### Command Line Setup

From this point you'll mostly be in the command line. Launch your favorite command prompt and quickly test to make
sure Git, Vagrant and SSH are actually available along your path.

```
git --version
vagrant --version
ssh
```

Assuming everything is good you continue. The next step is to sync the dashboard repository locally.

```
REM Clone the Dashboard into a local repository
cd /d <drive>:\<project root>
git clone https://github.com/code-dot-org/dashboard.git
cd dashboard
```

The next steps will setup the VM. This step will use the values in `Vagrantfile` from the enlistment. Note
that after rebooting your machine or setting up your VM again you may find it in a baseline state and have
to repeat these steps numerous times. There are recommendations later in the file for how to suspend and resume
your VM but depending on the circumstances these may not work.

Before running `vagrant up` ensure there is a forward port specified in the `Vagrantfile`. Open it up in your
editor and either find or add the following line.

```
config.vm.forward_port 3000, 8080
```

Now run `vagrant up` which will fetch and install the base VM. This step can take several minutes or longer
depending on your network bandwidth. The baseline will then be provisioned and a private host only network
will be set up so you can connect to the VM after you configure and launch rails in a later step.

```
vagrant up
```

Setup is going to fail with some output like the following:

```
Stderr: 0%...
Progress state: E_INVALIDARG
VBoxManage.exe: error: Failed to create the host-only adapter
...
```

At this point you need to use the VirtualBox UI to fix some settings. Once launched go to the File -> Preferences
menu and then select the Network tab from the left pane. There will now be two tabs in the right pane, the
first for "NAT Networks" and the second for "Host-only Networks". Choose the second tab. There will now be multiple
adapters in here. Delete all of the numbered adapters and then edit the last remaining one. Note you can build this
adapter setup before hand and skip the failure stage as well.

For the IPv4 Address use: 192.168.60.10

On the DHCP Server tab: Uncheck Enable Server

If you can't launch the VirtualBox UI then you have to kill all of the VirtualBox processes from the task manager.
Note, that both the Vagrant commands the and UI fight for control of a single COM server and so you have to exit
one before using the other. So after finishing up with the adapter configuration, go ahead and exit the UI. You
should now continue with the vagrant setup.

```
REM Setting up the virtual box now that we have a virtual network adapter prepared
vagrant up
> [default] Importing base box 'raring64'...
> ...
> [default] Waiting for machine to boot. This may take a few minutes...
```

This stage includes provisioning and so it will take quite some time even after waiting for the machine to boot
since both the `server_setup.sh` and `dev_setup.sh` scripts are going to be run before returning control to the
console.

Note: If you get a timeout such as the following, then you are in a state where the VM is not bootable for
whatever reason. You must have skipped the hardware virtualization step or you are running an unsupported
configuration that we haven't tested. I recommend running `vagrant destroy` and starting again. Optionally
delete all VM's and files from the UI so they can be recreated.

```
> Timed out while waiting for the machine to boot.
```

#### VM Configuration

From this point on we'll be working inside of the VM. To enter the VM you'll use the `vagrant ssh` command. Note
commands preceded by a $ are now be executed inside of the ssh terminal and not on the local Windows box.

```
vagrant ssh

$ rake db:create db:migrate seed:all youtube:thumbnails
$ rails server
```

#### Browser Configuration

Due to the port forwarding from host:8080 to guest:3000 you can now launch a browser and view the compiled site.

```
http://localhost:8080
```

### Notes

Current instructions are incomplete as they lack instructions for compiling Blockly.

[1]: https://github.com/code-dot-org/dashboard/blob/master/README.md
[2]: http://www.git-scm.com/download/win
