
# Major and Minor Version of your RPM, except a Gitlab Pipeline with Tags is used.
# Environment variables VERSION_MAJOR, VERSION_MINOR and VERSION_PATCH will be compared
#  with these settings.
# Doing so is useful to make sure that a git tag like "Release-2.1.4" fits with the
#  real built version.
RPM_MAJOR = 2
RPM_MINOR = 1
RPM_PATCH = 4


# The name of the resulting rpm and the installation folder.  It should fit to the
#  name of the spec file, or else you must modify RPM_SPEC_FILE
RPM_PACKAGE_NAME 	  = blndev-poc
RPM_PACKAGE_SUMMARY   = Proof of Concept to build an RPM
HELP_URL	  		  = https://github.com/blndev

# ------------------------------------------------------------------------------
# Note: dependencies and install folder can be change in spec file
#
# ------------------------------------------------------------------------------


# relative folder path which will be packaged. 
FOLDER_TO_DEPLOY = src


# ------------------------------------------------------------------------------
# fixed values; change only when required
BUILD_DIR = .tmp
DIST_DIR = dist
RPM_SPEC_FILE = ${RPM_PACKAGE_NAME}.spec
RPM_BUILD_DIR = .rpmbuild
RPM_TARGET_VERSION = ${VERSION_MAJOR}.${VERSION_MINOR}
RPM_FULL_NAME = ${RPM_PACKAGE_NAME}-${RPM_TARGET_VERSION}
RPM_TAR_SOURCE = ${BUILD_DIR}/${RPM_FULL_NAME}
# ------------------------------------------------------------------------------


info:
	@echo "Proof of Concept.\nRun make rpm to create a package"

compareVersion:
# ------------------------------------------------------------------------------
# compare ci info,  e.g. git tag with makefile settings
ifndef VERSION_MAJOR
define VERSION_MAJOR 
${RPM_MAJOR}
endef
else
ifneq (${VERSION_MAJOR}, ${RPM_MAJOR})
	$(error Major Version of Tag does not fit with makefile Version)
endif
endif

ifndef VERSION_MINOR
define VERSION_MINOR 
${RPM_MINOR}
endef
else
ifneq (${VERSION_MINOR}, ${RPM_MINOR})
	$(error Minor Version of Tag does not fit with makefile Version)
endif
endif

ifndef VERSION_PATCH
define VERSION_PATCH 
${RPM_PATCH}
endef
else
ifneq (${VERSION_PATCH}, ${RPM_PATCH})
$(error Patch / Release Version of Tag does not fit with makefile Version)
endif
endif
# apply extensions like 'beta' or 'unstable', if so defined
ifdef VERSION_INFO
VERSION_PATCH:=${VERSION_PATCH}_${VERSION_INFO}
endif

build: compareVersion
	@echo Build ${VERSION_MAJOR}.${VERSION_MINOR}.${VERSION_PATCH}

rpm: build
	@echo "starting rpm preparation"
	# --------------------------------------------------------------------------
	rm -rf ${RPM_TAR_SOURCE} 
	mkdir --parents ${RPM_TAR_SOURCE}
	rm -rf ${DIST_DIR}
	mkdir --parents ${DIST_DIR}
	# run the build and copy the build result to ${RPM_TAR_SOURCE}.
	# in this sample there is no build so we just copy the source files for distribution
	cp ${FOLDER_TO_DEPLOY}/* ${RPM_TAR_SOURCE} --recursive
	cp LICENSE ${RPM_TAR_SOURCE}
	cp changelog ${RPM_TAR_SOURCE}
	# any other file that needs to be packaged?
	# --------------------------------------------------------------------------
	
	# --------------------------------------------------------------------------
	# do not change this
	# --------------------------------------------------------------------------
	# remove all of the temporary stuff and files not to be published
	tar \
		-C ${BUILD_DIR} \
		-cf ${RPM_FULL_NAME}.tar ${RPM_FULL_NAME} \
		|| [[ \\$? -eq 1 ]]
	gzip ${RPM_FULL_NAME}.tar
	@mkdir -p ${RPM_BUILD_DIR}/{BUILD,RPMS,SOURCES,SPECS,SRPMS}
	@mv ${RPM_FULL_NAME}.tar.gz ${RPM_BUILD_DIR}/SOURCES
	@cp ${RPM_SPEC_FILE} ${RPM_BUILD_DIR}/SPECS
	rpmbuild \
		--define '_topdir %(pwd)/${RPM_BUILD_DIR}' \
		--define 'name ${RPM_PACKAGE_NAME}' \
		--define 'version ${RPM_TARGET_VERSION}' \
		--define 'source ${RPM_FULL_NAME}.tar.gz' \
		--define 'release ${VERSION_PATCH}' \
		--define 'summary ${RPM_PACKAGE_SUMMARY}' \
		--define 'url ${HELP_URL}' \
		-bb ${RPM_BUILD_DIR}/SPECS/${RPM_SPEC_FILE}
	# --------------------------------------------------------------------------
	@cp ${RPM_BUILD_DIR}/RPMS/**/${RPM_FULL_NAME}*.rpm ${DIST_DIR}/
	@echo "done. result:"
	@ls ${DIST_DIR}/*.rpm


deploy:
ifndef RPM_REPO
	$(error Relase Task requires a configured RPM Target Repository)
endif
	@echo "upload is an open task"

release:
	@echo "release is just about tagging the existing package"
