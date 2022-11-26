# Start from the code-server Debian base image
FROM codercom/code-server

# USER coder
USER root

# Apply VS Code settings
COPY deploy-container/settings.json .local/share/code-server/User/settings.json
COPY config.yaml /root/.config/code-server/config.yaml

# Use bash shell
ENV SHELL=/bin/bash

# Install unzip + rclone (support for remote filesystem)
RUN apt-get update && sudo apt-get install unzip -y
# RUN curl https://rclone.org/install.sh | sudo bash

# Copy rclone tasks to /tmp, to potentially be used
# COPY deploy-container/rclone-tasks.json /tmp/rclone-tasks.json

# Fix permissions for code-server
# RUN sudo chown -R coder:coder /home/coder/.local

# You can add custom software and dependencies for your environment below
# -----------

# Install a VS Code extension:
RUN code-server --install-extension esbenp.prettier-vscode
RUN code-server --install-extension ms-python.python

# Install apt packages:
RUN apt-get install -y python3 python3-venv python3-pip
RUN pip install --no-input justpy pandas

# Copy files: 
# COPY deploy-container/myTool /home/coder/myTool

# -----------

# Port
ENV PORT=8080
# ENV PORT=443
EXPOSE 8888 8000 9999 9000

# Use our custom entrypoint script first
COPY deploy-container/entrypoint.sh /usr/bin/deploy-container-entrypoint.sh
ENTRYPOINT ["/usr/bin/deploy-container-entrypoint.sh"]
