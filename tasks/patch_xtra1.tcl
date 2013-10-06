#!/usr/bin/tclsh
#
# ps3mfw -- PS3 MFW creator
#
# Copyright (C) RedDot-3ND7355 (Edmayc7)
#
# This software is distributed under the terms of the GNU General Public
# License ("GPL") version 3, as published by the Free Software Foundation.
#

# Priority: 116
# Description: PATCH: Allow Install PKG (Part 1, 4.xx)

# Option --allow-install-pkg: Patch to allow installation of packages (part 1, 4.xx)

# Type --allow-install-pkg: boolean

namespace eval ::patch_xtra1 {

    array set ::patch_xtra1::options {
            --allow-install-pkg true
    }

    proc main {} {
		set self [file join dev_flash vsh module explore_category_game.sprx]			
        ::modify_devflash_file $self ::patch_xtra1::patch_self
	}

		proc patch_self { self } {
        if {!$::patch_xtra1::options(--allow-install-pkg)} {
            log "WARNING: Feature not enabled!" 1
        } else {
            ::modify_self_file $self ::patch_xtra1::patch_elf
        }
    }

    proc patch_elf { elf } {
		if {$::patch_xtra1::options(--allow-install-pkg) } {
		    log "Patching [file tail $elf] to allow install pkg"
			log "Special feature added by RedDot-3ND7355"
			
			set search  "\xF8\x21\xFE\xD1\x7C\x08\x02\xA6\xFB\x81\x01\x10\x3B\x81\x00\x70"
			set replace "\x38\x60\x00\x01\x4E\x80\x00\x20\xFB\x81\x01\x10\x3B\x81\x00\x70"
			set offset 0
			
			# PATCH THE ELF BINARY
			catch_die {::patch_elf $elf $search $offset $replace} "Unable to patch self [file tail $elf]"          
		}
	}
}
