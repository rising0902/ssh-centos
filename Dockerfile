FROM centos:centos6
MAINTAINER t9knowledge <t9knowledge@knowledgedatabase.info>

# update yum cache.
RUN yum update -y

# Install yum packages.
RUN yum install -y openssh-server vim sudo

# Create user.
RUN useradd docker
RUN echo 'docker:docker' |chpasswd

# Set up SSH environment.
RUN ssh-keygen -q -N '' -t dsa -f /etc/ssh/ssh_host_dsa_key
RUN ssh-keygen -q -N '' -t rsa -f /etc/ssh/ssh_host_rsa_key

RUN mkdir -p /home/docker/.ssh; chown docker /home/docker/.ssh; chmod 700 /home/docker/.ssh
ADD  authorized_keys /home/docker/.ssh/authorized_keys
RUN chown docker:docker /home/docker/.ssh/authorized_keys
RUN chmod 600 /home/docker/.ssh/authorized_keys

# Set up sudoers.
RUN echo "docker   NOPASSWD:ALL=(ALL)       ALL" >> /etc/sudoers.d/docker

# Set up SSHD config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
RUN sed -ri 's/#UsePAM no/UsePAM no/g' /etc/ssh/sshd_config
RUN sed -ri 's/PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config
RUN sed -ri 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/g' /etc/ssh/sshd_config

#expose 22
EXPOSE 22

# start the sshd
CMD /usr/sbin/sshd -D
