# Set up SSH directory and key
test -d /home/${REMOTE_USER}/.ssh || mkdir -p /home/${REMOTE_USER}/.ssh && chmod 700 /home/${REMOTE_USER}/.ssh && \
test -f ${PERSISTENT_DATA_DIR}/id_ecdsa || ssh-keygen -t ecdsa -b 521 -N '' -f ${PERSISTENT_DATA_DIR}/id_ecdsa && \
test -f /home/${REMOTE_USER}/.ssh/id_ecdsa || cp ${PERSISTENT_DATA_DIR}/id_ecdsa /home/${REMOTE_USER}/.ssh/id_ecdsa
chown -R ${REMOTE_USER}:${REMOTE_USER} /home/${REMOTE_USER}/.ssh && chmod 600 /home/${REMOTE_USER}/.ssh/id_ecdsa

# Other scripts
echo "alias ppk='cat ${PERSISTENT_DATA_DIR}/id_ecdsa.pub'" >> /home/${REMOTE_USER}/.bashrc