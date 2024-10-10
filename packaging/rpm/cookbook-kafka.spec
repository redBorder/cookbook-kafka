Name: cookbook-kafka
Version: %{__version}
Release: %{__release}%{?dist}
BuildArch: noarch
Summary: Apache kafka cookbook to install and configure it in redborder environments

License: AGPL 3.0
URL: https://github.com/redBorder/cookbook-kafka
Source0: %{name}-%{version}.tar.gz

%description
%{summary}

%prep
%setup -qn %{name}-%{version}

%build

%install
mkdir -p %{buildroot}/var/chef/cookbooks/kafka
cp -f -r  resources/* %{buildroot}/var/chef/cookbooks/kafka/
chmod -R 0755 %{buildroot}/var/chef/cookbooks/kafka
install -D -m 0644 README.md %{buildroot}/var/chef/cookbooks/kafka/README.md

%pre
if [ -d /var/chef/cookbooks/kafka ]; then
    rm -rf /var/chef/cookbooks/kafka
fi

%post
case "$1" in
  1)
    # This is an initial install.
    :
  ;;
  2)
    # This is an upgrade.
    su - -s /bin/bash -c 'source /etc/profile && rvm gemset use default && env knife cookbook upload kafka'
  ;;
esac

%postun
# Deletes directory when uninstall the package
if [ "$1" = 0 ] && [ -d /var/chef/cookbooks/kafka ]; then
  rm -rf /var/chef/cookbooks/kafka
fi

%files
%defattr(0755,root,root)
/var/chef/cookbooks/kafka
%defattr(0644,root,root)
/var/chef/cookbooks/kafka/README.md

%doc

%changelog
* Thu Oct 10 2024 Miguel Negrón <manegron@redborder.com>
- Add pre and postun

* Fri Dec 01 2023 Miguel Negrón <manegron@redborder.com>
- add sync ip support

* Fri Jan 07 2022 David Vanhoucke <dvanhoucke@redborder.com>
- change register to consul

* Tue Oct 18 2016 Alberto Rodríguez <arodriguez@redborder.com>
- first spec version
