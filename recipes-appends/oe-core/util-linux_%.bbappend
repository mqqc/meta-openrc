# not sure what use this ever had, but it is definitely not used in OpenRC.
FILES:${PN}-mount:remove = "${@oe.utils.conditional('VIRTUAL-RUNTIME_initscripts', 'openrc', d.expand('${sysconfdir}/default/mountall'), '', d)}"

do_install:append() {
    if ${@oe.utils.conditional('VIRTUAL-RUNTIME_initscripts', 'openrc', 'true', 'false', d)}; then
        rm -f ${D}${sysconfdir}/default/mountall
        rmdir -p ${D}${sysconfdir}/default 2>/dev/null || true
    fi
}
