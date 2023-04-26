FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += " \
    file://busybox-acpid.confd \
    file://busybox-acpid.initd \
    file://busybox-cron.confd \
    file://busybox-cron.initd \
    file://busybox-klogd.confd \
    file://busybox-klogd.initd \
    file://busybox-httpd.confd \
    file://busybox-httpd.initd \
    file://busybox-inetd.confd \
    file://busybox-inetd.initd \
    file://busybox-mdev.confd \
    file://busybox-mdev.initd \
    file://busybox-ntpd.confd \
    file://busybox-ntpd.initd \
    file://busybox-syslogd.confd \
    file://busybox-syslogd.initd \
    file://busybox-udhcpd.confd \
    file://busybox-udhcpd.initd \
"
SRC_URI:remove = "${@oe.utils.conditional('VIRTUAL-RUNTIME_initscripts', 'openrc', 'rcS.default', '', d)}"
RDEPENDS:${PN}:remove = "${@oe.utils.conditional('VIRTUAL-RUNTIME_initscripts', 'openrc', 'busybox-inittab', '', d)}"
FILES:${PN}:remove = "${@oe.utils.conditional('VIRTUAL-RUNTIME_initscripts', 'openrc', d.expand('${sysconfdir}/init.d/busybox-cron ${sysconfdir}/init.d/mdev'), '', d)}"
FILES:${PN}-syslog:remove = "${@oe.utils.conditional('VIRTUAL-RUNTIME_initscripts', 'openrc', d.expand('${sysconfdir}/init.d/syslog'), '', d)}"

inherit openrc

OPENRC_PACKAGES = "busybox busybox-httpd busybox-mdev busybox-syslog busybox-udhcpd"
OPENRC_SERVICES = "busybox-acpid busybox-cron busybox-inetd busybox-klogd busybox-ntpd"
OPENRC_SERVICES:${PN}-syslog = "busybox-syslogd"

do_install:append() {
    if ! ${@bb.utils.contains('DISTRO_FEATURES', 'openrc', 'true', 'false', d)}; then
        return
    fi

    local svc
    if [ "${VIRTUAL-RUNTIME_initscripts}" = openrc ]; then
        for svc in busybox-cron mdev syslog; do
            rm -f "${D}${sysconfdir}/init.d/${svc}"
        done
    fi

    for svc in acpid cron klogd httpd inetd mdev ntpd syslogd udhcpd; do
        openrc_install_initd ${WORKDIR}/busybox-${svc}.initd
        openrc_install_confd ${WORKDIR}/busybox-${svc}.confd
    done
}
