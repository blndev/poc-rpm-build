# poc-rpm-build
Proof of Concept for RPM Creation for CentOS and RHEL to deploy Python based Apps

## Dependencies

> yum install rpm-build

## Create RPM

make rpm


### local test installation

install

````
sudo yum --disablerepo=* localinstall rpmbuild/RPMS/noarch/blndev-poc-1.0.dev-99.noarch.rpm
````

remove

``` 
sudo yum remove blndev-poc
````


# TODO
* refactoring makefile
* think about: use prefix with name and version instead of parent folder??
* think about: build in spec file from sources via make vs. copy build results
** maybe use a second makefile in src folder or have the rpm stuff in an rpm folder which is excluded from source tar.gz
* do it with a real python app (hello world) incl. dependencies
* after installation the command should be executable from path
* register a service could be nice to have

