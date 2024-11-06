useradd -m -d /home/${INIT_USER} -s /bin/bash ${INIT_USER}

PASSWD=`dd if=/dev/random bs=32 count=1 | base64`
usermod -p ${PASSWD} ${INIT_USER}

mkdir -p /etc/sudoers.d
echo "${INIT_USER}  ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/${INIT_USER}

mkdir /home/${INIT_USER}/.ssh
echo "${INIT_PUBKEY}" > /home/${INIT_USER}/.ssh/authorized_keys
chown -R ${INIT_USER}:${INIT_USER} /home/${INIT_USER}/.ssh
chmod go-rwx /home/${INIT_USER}/.ssh/authorized_keys