# RPM Build - Proof of Concept

[![Build Status](https://travis-ci.org/blndev/poc-rpm-build.svg?branch=master)](https://travis-ci.org/blndev/poc-rpm-build)

All details are based on http://ftp.rpm.org/max-rpm/ch-rpm-inside.html

The goal of this POC is to create a more or less general approach to handle installations of script based products / utils. 

## Description

POC for building an RPM File to deploy simple apps in a professional way.
For a real world solution including, build steps, you should separate the rpm creation and the build of the software.

This sample / poc is packaging all files in the src/ folder and install it on the client side.
File attributes will be copied. So if you have marked a file in the src/ folder as executable, it will also be executable after installation.

### Current Status

A RPM could be created and the sources can be used as template.
Currently the whole _src_ folder is packaged and installed on the target system. 

The Gitlab Pipeline is well working.

### Open ToDo
* enable build of an rpm on a Ubuntu Machine via docker
* build via travis pipeline
* do it with a real python app (hello world) incl. dependencies
* after installation the command should be executable from path
* register a service could be nice addon

## How to use it

To build and test an rpm you can use the following commands:

````bash
make rpm
sudo yum --disablerepo=* localinstall dist/blndev-poc-1.0-0.noarch.rpm
/opt/blndev/blndev-poc/helloworld
sudo yum remove blndev-poc
````

will package every file in src/ folder and build an rpm out of it.

## Deployment Pipeline

Every push to git will trigger a build. When you are not on the master branch, the resulting rpm is stored as artefact and can be manually deployed to the server as "*x.y.zunstable" Version.
After merging to the master, the build is triggered again and the "x.y.zunstable" version is published to the development service.
When you now create a tag with the name "RELEASE-x.y.z" and the Version in the Tag fits the Version in the makefile, then the RPM is newly build and published to the staging system.

After manual and automated tests, you can manually release the same rpm without rebuilding it to production.  

## Which Files you must copy to your repo

* makefile - contains build and path logic
* *.spec file - contains logic for the rpm engine
* .gitlab-ci.yml - contains a gitlab pipeline which trigger the makefile / build
* .travis.yml - contains a travis - ci pipeline which trigger the makefile /build
* LICENSE - will be packaged into rpm
* changelog - will be packaged into rpm

Note:
>The spec file in the root folder must have the same name as the "RPM_PACKAGE_NAME" variable in the makefile, or you have to change the RPM_SPEC_FILE variable.

## What to change

There a few minor things you have to change. Most of them are Names.

### Configuration

You must change the variables in the header of the makefile and in the spec file to adapt it to your need.
There is no need to change paths etc.

The Version Number can be set via a Git Tag when using the gitlab pipeline.
If you are not using a gitlab pipeline you must change the version in the makefile.

### Post Install Action

You will find the following section in the spec file:

````bash
%post
echo "--------------------------------------------------------"
echo "   %{name} installed in  %{_prefix}"
echo "--------------------------------------------------------"
````

This Section is executed AFTER the installation on the target system. Is a good area to start / stop services or manipulate configuration files.

### Uninstall Action

In the spec file is also the following section:

````bash
%postun
# your uninstall routine
rm -rf %{_prefix}/%{name}
rmdir %{_prefix} --ignore-fail-on-non-empty
````

That is the uninstall procedure. The rm and rmdir commands are used to remove the install folder. If there is something more to do, do it before.