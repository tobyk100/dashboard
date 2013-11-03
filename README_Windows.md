## Development QuickStart for Windows Machines

Usage of many of the tools on Windows requires a few additional steps. We'll keep those steps up to date here.

### Background

While the instructions are similar to those used to set up the VirtualBox/Vagrant setup for non-Windows
machines there are some common errors and a series of workarounds for those errors which needs to be
expressed to make setup easy. The goal of this tutorial is to set up a clean Windows machine from scratch
so that it can host a local copy of the Dashboard/Blockly webserver for debugging and editing purposes.

A shortened set of instructions can be found in the [general Readme][1]

### Setup Instructions

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

[1]: https://github.com/code-dot-org/dashboard/blob/master/README.md
[2]: http://www.git-scm.com/download/win
