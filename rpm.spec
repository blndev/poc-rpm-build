# No debuginfo:
%define debug_package %{nil}
#%%define _topdir           /tmp/rpm
#%%define _tmppath          %{_topdir}/tmp
%define name      blndev-poc
%define summary   Proof of Concept to build an RPM
%define license   MIT
%define group     Applications/System
%define source    %{name}-%{version}.tar.gz
%define url       https://github.com/blndev/poc-rpm-build
%define vendor    github - blndev
%define packager  blndev
%define buildroot %{_tmppath}/rpm-build-blndev-poc
%define projectroot ./rpm-projectroot
%define _prefix   /opt

Name:      %{name}
Summary:   %{summary}
Version:   %{version}
Release:   %{release}
License:   %{license}
Group:     %{group}
Source0:   %{source}
BuildArch: noarch
Requires:  bash
Requires:  grep
URL:       %{url}
Buildroot: %{buildroot}

%description
Collection Sample Scripts.
For further explanation, see %{url}
%prep
%setup -q -n blndev-poc-%{version}
%build
%install
install -d %{buildroot}%{_prefix}/blndev
tar cf - ./%{name}/* | (cd %{buildroot}%{_prefix}/blndev-poc; tar xfp -)
%post
echo "--------------------------------------------------------"
echo "   %{name} installed in  %{_prefix}"
echo "--------------------------------------------------------"
%postun
rm -rf %{_prefix}/blndev/%{name}
%clean
rm -rf %{buildroot}
%files
%defattr(-,root,root)
%{_prefix}/blndev/%{name}/*

