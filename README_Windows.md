## Development QuickStart for Windows Machines

Usage of many of the tools on Windows requires a few additional steps. We'll keep those steps up to date here.

### Background

While the instructions are similar to those used to set up the VirtualBox/Vagrant setup for non-Windows
machines there are some common errors and a series of workarounds for those errors which needs to be
expressed to make setup easy. The goal of this tutorial is to set up a clean Windows machine from scratch
so that it can host a local copy of the Dashboard/Blockly webserver for debugging and editing purposes.

A shortened set of instructions can be found in the [general Readme][1]

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

[1]: https://github.com/code-dot-org/dashboard/blob/master/README.md
[2]: http://www.git-scm.com/download/win
