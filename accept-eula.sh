#!/usr/bin/expect
# SPDX-FileCopyrightText: 2021, Carles Fernandez-Prades <carles.fernandez@cttc.es>
# SPDX-License-Identifier: MIT
set timeout -1

# installer is the first argv element; other argv elements are passed-through
set installer [lindex $argv 0]
set argc [llength $argv]
# assume the install directory is the last argument if present
if {$argc >= 2} {
    set install_dir [lindex $argv [expr {$argc - 1}]]
} else {
    set install_dir ""
}

# forward all provided args to the installer (handles flags like --dir <path>)
spawn $installer {*}$argv
set timeout 2
expect {
    "ERROR: Invalid options:" {
        # try legacy short option if installer rejected the arguments
        if {$install_dir != ""} {
            spawn $installer -d $install_dir
        }
    }
    timeout { }
}

set timeout 600
expect "Press Enter to display the license agreements"
send "\r"
set timeout 2

expect {
    "* >*" {send "y\r"}
    timeout { send "q"; sleep 1; exp_continue}
}
expect {
    "* >*" {send "y\r"}
    timeout { send "q"; sleep 1; exp_continue}
}
expect {
    "* >*" {send "y\r"}
    timeout { send "q"; sleep 1; exp_continue}
}

# set timeout -1

# expect "INFO: Checking PetaLinux installer integrity..."
# expect "INFO: Installing PetaLinux..."
#interact
