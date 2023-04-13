SUMMARY = "Network scripts for OpenRC from Alpine"
HOMEPAGE = "https://gitlab.alpinelinux.org/alpine/aports/-/tree/master/main/openrc"
# As per https://gitlab.alpinelinux.org/alpine/aports/-/issues/9074#note_53927
LICENSE = "BSD-2-Clause"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/BSD-2-Clause;md5=cb641bc04cda31daea161b1bc15da69f"
S = "${WORKDIR}"
SRC_URI = "\
    file://networking.initd \
    file://interfaces \
"

OPENRC_SERVICES = "networking"
OPENRC_AUTO_ENABLE = "enable"
inherit openrc


INHIBIT_DEFAULT_DEPS = "1"

do_configure[noexec] = "1"
do_compile[noexec] = "1"

do_install() {
    openrc_install_initd ${S}/networking.initd
    install -d ${D}${sysconfdir}/network
    install -m 0644 ${S}/interfaces ${D}${sysconfdir}/network/interfaces
    for x in pre-up up down post-down; do
        install -d ${D}${sysconfdir}/network/if-$x.d
    done
}

RPROVIDES:${PN} = "virtual/openrc-network-scripts"
