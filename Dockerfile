FROM ibuildthecloud/ubuntu-core-base:14.04
ADD http://stedolan.github.io/jq/download/linux64/jq /usr/bin/
RUN chmod +x /usr/bin/jq
RUN echo deb http://archive.ubuntu.com/ubuntu trusty-backports main universe | \
      sudo tee /etc/apt/sources.list.d/backports.list
RUN apt-get update && apt-get install -y \
    busybox \
    curl \
    dnsmasq \
    iptables \
    monit \
    socat \
    nodejs \
    psmisc \
    tcpdump \
    uuid-runtime \
    vim-tiny \
    haproxy -t trusty-backports && \
    rm -rf /var/lib/apt/lists
RUN ln -s /usr/bin/nodejs /usr/bin/node
ADD startup.sh /etc/init.d/agent-instance-startup
ADD https://github.com/rancherio/swarm/releases/download/v0.1.0-rancher/swarm /usr/bin/swarm
ADD https://github.com/sonchang/rancher-metadata/releases/download/test_0/rancher-metadata /usr/bin/rancher-metadata
EXPOSE 8083
RUN chmod +x /usr/bin/swarm
RUN chmod +x /usr/bin/rancher-metadata
CMD ["/etc/init.d/agent-instance-startup", "init"]
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y racoon
# Work around overlay bug
RUN touch /etc/monit/conf.d/.hold
