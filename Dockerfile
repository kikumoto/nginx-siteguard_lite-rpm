FROM centos:7
ENV HOME /
MAINTAINER Takahiro KIKUMOTO
RUN yum update  -y
RUN yum install -y epel-release \
    && yum install -y autoconf automake libtool wget \
                      git make vim less \
                      gcc gcc-c++ pkgconfig pcre-devel tcl-devel expat-devel openssl-devel zlib-devel \
                      perl-devel perl-ExtUtils-Embed GeoIP-devel libxslt-devel gd-devel \
                      rpm-build redhat-rpm-config rpmdevtools \
                      rake bison \
                      apr-devel apr-util-devel \
    && yum clean all \
    && rpmdev-setuptree \
    && echo '%dist   .el7' >> /.rpmmacros

ARG nginx_src_rpm
ARG siteguard_url
ARG siteguard_ver
RUN cd / \
    && wget -q http://nginx.org/packages/mainline/centos/7/SRPMS/${nginx_src_rpm} && rpm -ivh ${nginx_src_rpm} \
    && cd /rpmbuild/SOURCES \
    && wget -q ${siteguard_url}

COPY nginx.spec.patch.tmpl /tmp
RUN cd /tmp \
    && cat nginx.spec.patch.tmpl | sed -e "s/@@SITEGUARD_VER@@/"${siteguard_ver}"/g" > nginx.spec.patch \
    && cd /rpmbuild/SPECS \
    && patch -u < /tmp/nginx.spec.patch \
    && rpmbuild -ba nginx.spec
RUN tar -czf /tmp/nginx.tar.gz -C /rpmbuild RPMS SRPMS

CMD ["/bin/true"]
