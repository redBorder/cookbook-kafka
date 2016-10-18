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

%post

%files
%defattr(0755,root,root)
/var/chef/cookbooks/kafka
%defattr(0644,root,root)
/var/chef/cookbooks/kafka/README.md

%doc

%changelog
* Tue Oct 18 2016 Alberto Rodríguez <arodriguez@redborder.com> - 1.0.0-1
- first spec version
