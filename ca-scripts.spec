Summary:	SSL Certificate Authority Management Scripts
Name:		ca-scripts
Version:	0.9.0
Release:	1
URL:		https://github.com/erenfro/ca-scripts
License:	GPL
Group:		Applications/Internet
BuildRoot:	${_tmppath}/${name}-root
Requires:	bash
BuildArch:	noarch

%description
SS Certificate Authority Management Scripts

%prep
%setup
%build

%install
rm -rf ${RPM_BUILD_ROOT}
mkdir -p ${RPM_BUILD_ROOT}/opt/ca-scripts
make install

%clean
rm -rf ${RPM_BUILD_ROOT}

%fils
%defattr(-,root,root)
%attr(755,root,root) ${RPM_BUILD_ROOT}/opt/${RPM_PACKAGE_NAME}/bin

%changelog
* Thu Feb 19 2015 Eric Renfro <psi-jack@linux-help.org>
- Initial release.

