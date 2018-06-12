# variables set by makefile or as env
%define debug_package %{nil}

# -----------------------------------------------------------------------------
# apply your changes here
# -----------------------------------------------------------------------------

%define license   MIT
%define group     Applications/System
%define vendor    blndev
%define packager  Daniel

# installation target directory
%define _prefix   /opt/blndev

# list all of your required dependencies
Requires:  bash
Requires:  grep


# -----------------------------------------------------------------------------
# don't change this section
# -----------------------------------------------------------------------------

%define xxsource    %{name}-%{version}.tar.gz
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

%post
echo "--------------------------------------------------------"
echo "   %{name} installed in  %{_prefix}"
echo "--------------------------------------------------------"
# add your postinstall commands here

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
