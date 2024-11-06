echo "${INIT_HOSTNAME}" > /etc/hostname

export DEBIAN_FRONTEND=noninteractive
apt-get -y update && apt-get -y upgrade

sed -i 's/PermitRootLogin .*/PermitRootLogin no/g' /etc/ssh/sshd_config
sed -i 's/PasswordAuthentication .*/PasswordAuthentication no/g' /etc/ssh/sshd_config