# required variables but set by makefile or as env
# you can set them here as well, just remove the "_"
# %_define _topdir  /tmp/rpm
# %_define _tmppath  %{_topdir}/tmp
# %_define name      blndev-poc
%define debug_package %{nil}

# -----------------------------------------------------------------------------
# apply your changes here
# -----------------------------------------------------------------------------

%define summary   Proof of Concept to build an RPM
%define license   MIT
%define group     Applications/System
%define url       https://github.com/blndev/poc-rpm-build
%define vendor    github - blndev
%define packager  blndev

# installation target directory
%define _prefix   /opt/blndev

# list all of your required dependencies
Requires:  bash
Requires:  grep


# -----------------------------------------------------------------------------
# don't change this section
# -----------------------------------------------------------------------------

%define source    %{name}-%{version}.tar.gz
%define buildroot %{_topdir}/BUILDROOT

Name:      %{name}
Summary:   %{summary}
Version:   %{version}
Release:   %{release}
License:   %{license}
Group:     %{group}
Source0:   %{source}
BuildArch: noarch
URL:       %{url}
Buildroot: %{buildroot}

# -----------------------------------------------------------------------------
# don't change this section
# -----------------------------------------------------------------------------
%description
%{summary}
For detailed explanation, see %{url}

%prep
# add -q to setup to have no verbose output
%setup -n %{name}-%{version}
%build

%install
install -d %{buildroot}%{_prefix}/%{name}
echo "directories created"
cp %{_topdir}/BUILD/%{name}-%{version}/* %{buildroot}%{_prefix}/%{name}/ --recursive -v
#tar cf - ./%{name}/* | (cd %{buildroot}%{_prefix}/%{name}; tar xfp -)

%post
echo "--------------------------------------------------------"
echo "   %{name} installed in  %{_prefix}"
echo "--------------------------------------------------------"

%postun
# your uninstall routine
rm -rf %{_prefix}/%{name}
rmdir %{_prefix} --ignore-fail-on-non-empty

%clean
rm -rf %{buildroot}

%files
# the files to be installed, we choose everything which was packaged by makefile
%defattr(-,root,root)
%{_prefix}/%{name}/*
