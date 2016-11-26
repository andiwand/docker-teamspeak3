#!/bin/bash

OLD_USER_ID=$(id -u teamspeak)
OLD_GROUP_ID=$(id -g teamspeak)

if [ "${USER_ID}" -ne "${OLD_USER_ID}" ]; then
    usermod -u ${USER_ID} teamspeak
    find / -user ${OLD_USER_ID} -exec chown -h ${USER_ID} {} \;
fi
if [ "${GROUP_ID}" -ne "${OLD_GROUP_ID}" ]; then
    groupmod -g ${GROUP_ID} teamspeak
    usermod -g ${GROUP_ID} teamspeak
    find / -group ${OLD_GROUP_ID} -exec chgrp -h ${GROUP_ID} {} \;
fi

sudo -H -u teamspeak "${TS3_HOME}/ts3server_minimal_runscript.sh" \
    logpath="${TS3_LOG}" \
    inifile="${TS3_CONFIG}/ts3server.ini" \
    licensepath="${TS3_CONFIG}/license.txt" \
    query_ip_whitelist="${TS3_CONFIG}/query_ip_whitelist.txt" \
    query_ip_backlist="${TS3_CONFIG}/query_ip_blacklist.txt"
