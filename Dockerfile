FROM osbs-test/multiarch-base:1.0.multiarch.base
LABEL maintainer="Red Hat, Inc."

RUN INSTALL_PKGS="\
rsyslog \
rsyslog-gnutls \
rsyslog-gssapi \
rsyslog-mysql \
rsyslog-pgsql \
rsyslog-relp \
" && yum -y install $INSTALL_PKGS && rpm -V --nosize --nofiledigest --nomtime --nomode $INSTALL_PKGS && yum clean all
# not including rsyslog-mmjsonparse, it is in rhel-alt. unless really needed

LABEL com.redhat.component="rsyslog-container"
LABEL name="rhel7/rsyslog"
LABEL version="7.6"

LABEL License="GPLv3"

LABEL install="docker run --rm --privileged -v /:/host \
-e HOST=/host -e IMAGE=IMAGE -e NAME=NAME \
IMAGE /bin/install.sh"

LABEL uninstall="docker run --rm --privileged -v /:/host \
-e HOST=/host -e IMAGE=IMAGE -e NAME=NAME \
IMAGE /bin/uninstall.sh"

LABEL run="docker run -d --privileged --name NAME \
--net=host --pid=host \
-v /etc/pki/rsyslog:/etc/pki/rsyslog \
-v /etc/rsyslog.conf:/etc/rsyslog.conf \
-v /etc/sysconfig/rsyslog:/etc/sysconfig/rsyslog \
-v /etc/rsyslog.d:/etc/rsyslog.d \
-v /var/log:/var/log \
-v /var/lib/rsyslog:/var/lib/rsyslog \
-v /run:/run \
-v /etc/machine-id:/etc/machine-id \
-v /etc/localtime:/etc/localtime \
-e IMAGE=IMAGE -e NAME=NAME \
--restart=always IMAGE /bin/rsyslog.sh"

#labels for container catalog
LABEL summary="A containerized version of the rsyslog utility for Red Hat Enterprise Linux 7.  The rsyslog container runs on a Red Hat Enterprise Linux 7 Atomic host to collect logs from various services.  The rsyslog container leverages the atomic command for installation, activation and management."
LABEL description="Rsyslogd is a system utility providing support for message logging. Support of both internet and unix domain sockets enables this utility to support both local and remote logging."
LABEL io.k8s.display-name="Rsyslog"
LABEL io.openshift.expose-services=""

ADD install.sh /bin/install.sh
ADD rsyslog.sh /bin/rsyslog.sh
ADD uninstall.sh /bin/uninstall.sh

CMD [ "/bin/rsyslog.sh" ]
