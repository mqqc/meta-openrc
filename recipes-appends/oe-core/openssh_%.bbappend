FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://sshd.initd file://sshd.confd"

inherit openrc

OPENRC_PACKAGES = "openssh-sshd"
OPENRC_SERVICES:openssh-sshd = "sshd"

FILES:${PN}-sshd:remove = "${@oe.utils.conditional('VIRTUAL-RUNTIME_initscripts', 'openrc', d.expand('${sysconfdir}/init.d/sshd'), '', d)}"

do_install:append() {
    if [ "${VIRTUAL-RUNTIME_initscripts}" = openrc ]; then
        rm -f "${D}${sysconfdir}/init.d/sshd"
    fi

    openrc_install_initd ${WORKDIR}/sshd.initd
    openrc_install_confd ${WORKDIR}/sshd.confd
}
