# RPM Build - Proof of Concept

Proof of Concept for RPM package creation for CentOS and RHEL to deploy Python based Apps.

All details are based on http://ftp.rpm.org/max-rpm/ch-rpm-inside.html

The goal of this POC is to create a more or less general appoach to handle installations of script based products / utils. 


## Current Status

A RPM could be created in a few seconds. Currently with the package only a small "hello world" shell script s installed.

The scripts like makefile an spec are working.
Currently the whole _src_ folder is packaged and installed on the target system. 

## TODO
* build an rpm on a Ubuntu Machine via docker
* build on checkin via pipeline
* do it with a real python app (hello world) incl. dependencies
* after installation the command should be executable from path
* register a service could be nice to have

## Dependencies

There are only less dependencies. Based on the software we are using (Python 3) we need a interpreter and pip. And for the build action the _rpmbuiild_ package.

This can be installed with:

> yum install rpm-build

## Create an RPM

To create an RPM you can use the ````make rpm```` command.

In some of the next builds i will separate the makefile for rpm and the makefile for the software

The whole build process is running on the local checkout folder. There is no need to have an additional account or root privileges.

**Important**
The file attributes from the src folder are applied to the installed files on the target system. Make sure that you mark an executable file as executable also in src/.

### local test installation

After the rpm is created, you can install it on your local system. 

````
sudo yum --disablerepo=* localinstall rpmbuild/RPMS/noarch/blndev-poc-1.0.dev-99.noarch.rpm
````

### Remove installed package

It's the same procedure as the installation of a regular installed repo. 

Just execute:
``` 
sudo yum remove blndev-poc
````


For a real world solution including, build steps, you should separate the rpm creation and the build of the software.

# How to use it

Just copy all scripts to your personal repo. It will package every file in src/ folder and build an rpm out of it.


## What to change to use it on your code

There a few minor things you have to change.

## Names

The spec file in the root folder must have the same name as the "rpm_root_name" variable in the makefile (line 9).
You must change the variables in the header of the makefile and in the spec file to build your rpm.
There is no need to change paths etc.

## Post Install Action

You will find the following section in the spec file:

````bash
%post
echo "--------------------------------------------------------"
echo "   %{name} installed in  %{_prefix}"
echo "--------------------------------------------------------"
````

This Section is executed AFTER the installation on the target system. Is a good area to start / stop services or manipulate configuration files.


## Uninstall Action

In the spec file is also the following section:

````bash
%postun
# your uninstall routine
rm -rf %{_prefix}/%{name}
rmdir %{_prefix} --ignore-fail-on-non-empty
````

That is the uninstall procedure. The rm and rmdir commands are used to remove the install folder. If there is something more to do, do it before.
