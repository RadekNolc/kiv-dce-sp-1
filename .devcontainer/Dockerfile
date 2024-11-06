FROM mcr.microsoft.com/vscode/devcontainers/base:ubuntu

ARG PERSISTENT_DATA_DIR=/var/devcontainer-data
ENV DEBIAN_FRONTEND noninteractive

RUN apt update -y && apt upgrade -y
RUN apt install -y software-properties-common unzip curl iputils-ping git

RUN add-apt-repository --yes --update ppa:ansible/ansible
RUN apt install -y ansible

RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
RUN echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
RUN apt update -y
RUN apt install -y terraform

RUN mkdir /tmp/init
COPY init.sh /tmp/init

ENV PERSISTENT_DATA_DIR ${PERSISTENT_DATA_DIR}
ENV SSH_OPTIONS "-o StrictHostKeyChecking=no"

RUN echo 'alias ssh="ssh $SSH_OPTIONS"' >> /root/.bashrc && \
    echo 'alias ssh="ssh $SSH_OPTIONS"' >> /home/${REMOTE_USER}/.bashrc

CMD ["sleep", "infinity"]