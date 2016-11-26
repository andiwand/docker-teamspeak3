FROM ubuntu:16.04

ARG TS3_VERSION="3.0.13.6"
ARG TS3_URL="http://dl.4players.de/ts/releases/${TS3_VERSION}/teamspeak3-server_linux_amd64-${TS3_VERSION}.tar.bz2"
ARG TS3_SHA_256="19ccd8db5427758d972a864b70d4a1263ebb9628fcc42c3de75ba87de105d179"
ARG TS3_FOLDER="teamspeak3-server_linux_amd64"

ARG TS3_HOME="/usr/local/teamspeak3"
ARG TS3_CONFIG="/etc/teamspeak3"
ARG TS3_DATA="/var/lib/teamspeak3"
ARG TS3_LOG="/var/log/teamspeak3"

ENV TS3_HOME="${TS3_HOME}" \
    TS3_DATA="${TS3_CONFIG}" \
    TS3_DATA="${TS3_DATA}" \
    TS3_LOG="${TS3_LOG}" \
    USER_ID="9003" \
    GROUP_ID="9003"

COPY "entrypoint.sh" "/usr/local/share/docker-teamspeak3/entrypoint.sh"

RUN apt-get update -y \
    && apt-get install -y wget bzip2 sudo \
    && wget -O "/tmp/teamspeak3.tar.bz2" "${TS3_URL}" \
    && echo "${TS3_SHA_256} /tmp/teamspeak3.tar.bz2" | sha256sum -c \
    && tar -xvf "/tmp/teamspeak3.tar.bz2" -C "/tmp" --no-same-owner \
    && mv "/tmp/${TS3_FOLDER}" "${TS3_HOME}" \
    && mkdir -p "${TS3_CONFIG}" "${TS3_DATA}" "${TS3_LOG}" \
    && groupadd -r -g ${GROUP_ID} teamspeak \
    && useradd -r -u ${USER_ID} -g teamspeak -d "${TS3_HOME}" -s "/bin/false" teamspeak \
    && chown teamspeak:teamspeak -R "${TS3_HOME}" "${TS3_CONFIG}" "${TS3_DATA}" "${TS3_LOG}" \
    && ln -s "${TS3_DATA}/ts3server.sqlitedb" "${TS3_HOME}/ts3server.sqlitedb" \
    && apt-get remove -y wget bzip2 \
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf "/var/lib/apt/lists/*" \
    && rm -rf "/tmp/*"

VOLUME [ "${TS3_CONFIG}", "${TS3_DATA}" ]

EXPOSE 9987/udp 10011 30033

WORKDIR "${TS3_HOME}"

ENTRYPOINT "/usr/local/share/docker-teamspeak3/entrypoint.sh"
