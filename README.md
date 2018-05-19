# poc-rpm-build
Proof of Concept for RPM package creation for CentOS and RHEL to deploy Python based Apps.

All details are based on http://ftp.rpm.org/max-rpm/ch-rpm-inside.html

The goal of this POC is to create a more or less general appoach to handle installations of python based products. 

## Dependencies

There are only less dependencies. Based on the software we are using (Python 3) we need a interpreter and pip. And for the build action the _rpmbuiild_ package.

This can be installed with:

> yum install rpm-build

## Current Status

A RPM could be builded. Currently with the package only a small "hello world" shell script s installed.

The basic scripts like makefile an spec are working.
In the next steps i will separate the makefile for the rpm and the software. Then the whole software buidl will be executed also via the spec file.
Currently the whole _src_ folder is packaged and installed on the target system. 

## TODO
* refactoring makefile
* think about: use prefix with name and version instead of parent folder??
* think about: build in spec file from sources via make vs. copy build results
** maybe use a second makefile in src folder or have the rpm stuff in an rpm folder which is excluded from source tar.gz
* do it with a real python app (hello world) incl. dependencies
* after installation the command should be executable from path
* register a service could be nice to have


# Create a RPM

To create an RPM you can use the ````make rpm```` command.

In some of the next builds i will separate the makefile for rpm and the makefile for the software

The whole build process is running on the local checkout folder. There is no need to have an additional account or root privileges.

## local test installation

After the rpm is created, you can install it on your local system. 

````
sudo yum --disablerepo=* localinstall rpmbuild/RPMS/noarch/blndev-poc-1.0.dev-99.noarch.rpm
````

Remove installed package

It's the same procedure as the installation of a regular installed repo. 

Just execute:
``` 
sudo yum remove blndev-poc
````

