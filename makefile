VERSION = 1.0
VERSION_MINOR = dev
RPM_ROOT_NAME = blndev-poc
RPM_TARGET_VERSION = ${VERSION}.${VERSION_MINOR}
DIRECTORY_ROOT = dist
RPM_ROOT_DIR = ${DIRECTORY_ROOT}/$(RPM_ROOT_NAME)-${RPM_TARGET_VERSION}

info:
	echo "POC"

rpm:
	rm -rf ${RPM_ROOT_DIR} #maybe replace that with a srcbuild/ dir or dist/ in the local folder
	mkdir --parents ${RPM_ROOT_DIR}
	cp src/* ${RPM_ROOT_DIR} --recursive
	# now the build and test should run
	# remove all of the temporary stuff and files not to be published
	tar -C ${DIRECTORY_ROOT} -cf ${RPM_ROOT_NAME}-${RPM_TARGET_VERSION}.tar ${RPM_ROOT_NAME}-${RPM_TARGET_VERSION} || [[ \\$? -eq 1 ]]
	gzip ${RPM_ROOT_NAME}-${RPM_TARGET_VERSION}.tar
	mkdir -p rpmbuild/{BUILD,RPMS,SOURCES,SPECS,SRPMS}
	mv ${RPM_ROOT_NAME}-${RPM_TARGET_VERSION}.tar.gz rpmbuild/SOURCES
	cp ${RPM_ROOT_NAME}.spec rpmbuild/SPECS
	#chgrp -R root rpmbuild/
	rpmbuild --define '_topdir %(pwd)/rpmbuild' --define 'version ${RPM_TARGET_VERSION}' --define 'release ${BUILD_NUMBER}' -ba rpmbuild/SPECS/${RPM_ROOT_NAME}.spec
	PM_ROOT_DIR stage finished!"
	
