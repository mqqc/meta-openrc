Introduction
------------

This layer adds support for OpenRC to OpenEmbedded similarly to how rc.d
scripts and systemd are supported.  OpenRC can be selected by adding this
layer and adding `openrc` to `DISTRO_FEATURES`.

Both the standard rc.d scripts and those from OpenRC expect to live in
`/etc/init.d`.  When `openrc` is added to `DISTRO_FEATURES`, the former will be
removed from that directory entirely and only OpenRC capable scripts will be
installed [1].  If `openrc` is not added to `DISTRO_FEATURES` this layer will
not have any effect aside from providing the openrc recipe.


1.  This assumes that this layer has an append for the recipe in question.

Dependencies
------------

The meta-openrc layer depends on:

	URI: https://git.openembedded.org/openembedded-core
	layers: meta
	branch: kirkstone

Contributing
------------

Feel free to to use the github pull request UI or to directly send emails to
the maintainer(s) using something like:

`git send-email -M -1 --to=jsbronder@cold-front.org --subject-prefix=meta-openrc][kirkstone][PATCH`

Usage
-----

1. Add the layer to your build

    `bitbake-layers add-layer /path/to/meta-openrc`

2. Add `openrc` to `DISTRO_FEATURES` in your distro or local config:

    `DISTRO_FEATURES += "openrc"

3. Update your image to `inherit openrc-image` and set the following as
   necessary (see [openrc-image.bb](recipes-test/openrc-image/openrc-image.bb)
   for an example):

    1. `OPENRC_SERVICES`: Define additional services to add to the paired
       runlevel using a whitespace delimited list of
       `[runlevel]:[service-name]`.

    2. `OPENRC_STACKED_RUNLEVELS`: define runlevels to be stacked on top of
       other runlevels using a whitespace delimited list of `[base
       runlevel]:[stacked runlevel]`


Note on pre-kirkstone releases
-------------------------------
Prior to kirkstone, this layer used the quick-and-easy approach of relocating
openrc scripts to `/etc/openrc.d` and supplying a single omnibus recipe for
additional initd scripts.  Images were expected to define their own
`ROOTFS_POSTPROCESS_COMMAND` within which they'd update inittab and add
services to runlevels as necessary.  With kirkstone, that approach was replaced
with a more conventional one following the pattern set by the `update-rc.d` and
`systemd` bbclasses in openembedded-core.

Maintenance
-----------
Maintainer: Justin Bronder <jsbronder@cold-front.org>

