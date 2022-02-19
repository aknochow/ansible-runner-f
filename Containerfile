# Use Fedora for our base because it is pretty awesome... (and has python-ansible-runner built in).
FROM quay.io/fedora/fedora:35

# Packages
RUN dnf install -y --setopt=tsflags=nodocs jq nano openssl python-ansible-runner unzip wget

# Ansible runner
CMD ["ansible-runner", "run", "/runner"]
