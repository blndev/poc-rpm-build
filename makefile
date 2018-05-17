VERSION = 1.0
VERSION_MINOR = "dev"
DIRECTORY_ROOT = "/tmp/poc-rpmbuild-tmp"
RPM_ROOT_NAME = "blndev-poc"
RPM_TARGET_VERSION = "${VERSION}.${VERSION_MINOR}"
RPM_ROOT_DIR = "${DIRECTORY_ROOT}-${RPM_TARGET_VERSION}"

info:
	echo "POC"

rpm:
	rm -rf ${RPM_ROOT_DIR} #maybe replace that with a srcbuild/ dir or dist/ in the local folder
	mkdir ${RPM_ROOT_DIR}
	cp src/* ${RPM_ROOT_DIR} --recursive
	# now the build and test should run
	# remove all of the temporary stuff and files not to be published
	tar cf ${RPM_ROOT_NAME}-${RPM_TARGET_VERSION}.tar ${RPM_ROOT_DIR} || [[ \\$? -eq 1 ]]
	gzip ${RPM_ROOT_NAME}-${RPM_TARGET_VERSION}.tar
	mkdir -p rpmbuild/{BUILD,RPMS,SOURCES,SPECS,SRPMS}
	mv ${RPM_ROOT_NAME}-${RPM_TARGET_VERSION}.tar.gz rpmbuild/SOURCES
	cp rpm.spec rpmbuild/SPECS
	#chgrp -R root rpmbuild/
	rpmbuild --define '_topdir %(pwd)/rpmbuild' --define 'version ${RPM_TARGET_VERSION}' --define 'release ${BUILD_NUMBER}' -ba rpmbuild/SPECS/${RPM_ROOT_NAME}.spec
	PM_ROOT_DIR stage finished!"
	