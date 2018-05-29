#!/usr/bin/env bash
 
set -eux
yum -y install epel-release 
 
 PACKAGES="
gcc
python-devel
zlib-devel
rpm-build
make
python-setuptools
python-pip
"
for i in $(seq 5)
do
    yum -y install ${PACKAGES} &amp;&amp; break
done
 
#mysql_install_db &amp;&amp; mysqld --user=root &amp;
#timeout=300
#while [ ${timeout} -gt 0 ] ; do mysqladmin ping &amp;&amp; break; sleep 1; timeout=$((${timeout} - 1)); done
 
cp -Rv . /repo/
#pip install /tmp/twindb-backup
 
make -C /code/distribute/rpm/makefile rpm
 
cp -R /code/rpmbuild/rpms /tmp/rpms/