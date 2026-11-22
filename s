#!/bin/bash
# Authorizes the pbx-ops GitHub Actions key for root and makes SSH key-only.
# Contains only a PUBLIC key; safe to be public.
set -e
KEY='ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMk9PHMZlhUkjEL9CqP0d+Dgq8s4oBsJ+dvsSrohckVl pbx-ops-github'
install -d -m 700 /root/.ssh
touch /root/.ssh/authorized_keys && chmod 600 /root/.ssh/authorized_keys
grep -qF "$KEY" /root/.ssh/authorized_keys || echo "$KEY" >> /root/.ssh/authorized_keys
printf 'PasswordAuthentication no\nKbdInteractiveAuthentication no\nPermitRootLogin prohibit-password\n' > /etc/ssh/sshd_config.d/10-keyonly.conf
sshd -t
systemctl reload ssh
echo "KEY-SETUP-OK"
