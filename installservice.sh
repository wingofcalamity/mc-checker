#!/bin/bash
set -e

sudo install -m 0644 checker.service /etc/systemd/system/checker.service
sudo systemctl daemon-reload
sudo systemctl enable --now checker.service