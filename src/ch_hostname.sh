#!/bin/bash

usage() {
        cat << EOF

--- ch_hostname ---
Change the hostname of the current machine
To change the operational hostname, you will need to reload the
interactive session (i.e. logout and login) or reboot the machine.

usage: ch_hostname NEW_HOSTNAME

EOF
}

if [[ $# -ne 1  ]]; then
    usage
        exit 1
fi

hostname "$1" || exit 20
echo "$1" > /etc/hostname || exit 21
sed -i "s/$HOSTNAME/$1/" /etc/hosts || exit 22

echo "Hostname successfully changed to $1."
echo -e "Logout and login or reboot the machine.\n"
