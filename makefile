
# Major Version of your RPM 
VERSION = 1
# Minor Version
VERSION_MINOR = 0

# name of the resulting rpm and the installation folder
RPM_ROOT_NAME = blndev-poc

# build number should be set by a ci pipeline, just remove it from here
BUILD_NUMBER = 999

# ------------------------------------------------------------------------------
# fixed values, change only when required
DIRECTORY_ROOT = .tmp
RPM_TARGET_VERSION = ${VERSION}.${VERSION_MINOR}
RPM_FULL_NAME = ${RPM_ROOT_NAME}-${RPM_TARGET_VERSION}
RPM_ROOT_DIR = ${DIRECTORY_ROOT}/${RPM_FULL_NAME}
# ------------------------------------------------------------------------------

info:
	echo "Proof of Concept"

build:
	echo "no build step required"

rpm: build
	echo "starting rpm preparation"
	# --------------------------------------------------------------------------
	rm -rf ${RPM_ROOT_DIR} #maybe replace that with a srcbuild/ dir or dist/ in the local folder
	mkdir --parents ${RPM_ROOT_DIR}
	# run the build and copy the build result to ${RPM_ROOT_DIR}
	# in this sample there is no build so we just copy the sources for distribution
	cp src/* ${RPM_ROOT_DIR} --recursive
	cp LICENSE ${RPM_ROOT_DIR}
	# any other file that needs to be packaged?
	# --------------------------------------------------------------------------
	
	# --------------------------------------------------------------------------
	# do not change this
	# --------------------------------------------------------------------------
	# remove all of the temporary stuff and files not to be published
	tar -C ${DIRECTORY_ROOT} -cf ${RPM_FULL_NAME}.tar ${RPM_FULL_NAME} || [[ \\$? -eq 1 ]]
	gzip ${RPM_FULL_NAME}.tar
	mkdir -p rpmbuild/{BUILD,RPMS,SOURCES,SPECS,SRPMS}
	mv ${RPM_FULL_NAME}.tar.gz rpmbuild/SOURCES
	cp ${RPM_ROOT_NAME}.spec rpmbuild/SPECS
	rpmbuild --define '_topdir %(pwd)/rpmbuild' --define 'name ${RPM_ROOT_NAME}' --define 'version ${RPM_TARGET_VERSION}' --define 'release ${BUILD_NUMBER}' -ba rpmbuild/SPECS/${RPM_ROOT_NAME}.spec
	# --------------------------------------------------------------------------
	
