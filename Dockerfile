# Use Fedora for our base because it is awesome... (and has python-ansible-runner baked in).
FROM quay.io/fedora/fedora:37

# Packages
RUN dnf install -y --setopt=tsflags=nodocs dumb-init rsync jq ansible-core

# Ansible runner
#
# In OpenShift, container will run as a random uid number and gid 0. Make sure things
# are writeable by the root group.
RUN dnf install -y --setopt=tsflags=nodocs python-ansible-runner 
RUN for dir in \
      /home/runner \
      /home/runner/.ansible \
      /home/runner/.ansible/tmp \
      /runner \
      /home/runner \
      /runner/env \
      /runner/inventory \
      /runner/project \
      /runner/artifacts ; \
    do mkdir -m 0775 -p $dir ; chmod -R g+rwx $dir ; chgrp -R root $dir ; done && \
    for file in \
      /home/runner/.ansible/galaxy_token \
      /etc/passwd \
      /etc/group ; \
    do touch $file ; chmod g+rw $file ; chgrp root $file ; done

WORKDIR /runner
ENV HOME=/home/runner

ADD entrypoint.sh /bin/entrypoint
RUN chmod +x /bin/entrypoint
ENTRYPOINT ["entrypoint"]

CMD ["ansible-runner", "run", "/runner"]
