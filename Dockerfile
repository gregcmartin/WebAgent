FROM ubuntu:latest

# Install necessary libraries for GUI, noVNC, and Python
RUN apt-get update && \
    apt-get install -y xvfb x11vnc lxde websockify wget python3 python3-pip python3-venv nodejs npm && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set up a Python virtual environment and install Playwright
RUN python3 -m venv /opt/venv
# Activate virtual environment and install packages
ENV PATH="/opt/venv/bin:$PATH"
RUN pip install --upgrade pip
RUN pip install playwright
RUN playwright install

# Download and extract noVNC
RUN wget https://github.com/novnc/noVNC/archive/refs/tags/v1.3.0.tar.gz && \
    tar -xvzf v1.3.0.tar.gz && \
    mv noVNC-1.3.0 /noVNC

# Copy custom vnc_auto.html
COPY vnc_auto.html /noVNC/vnc_auto.html

# Set environment variables
ENV DISPLAY=:99

# Start Xvfb, x11vnc, websockify, and keep the container running
CMD Xvfb :99 -screen 0 1024x768x16 & \
    x11vnc -display :99 -forever -nopw -shared & \
    websockify --web /noVNC 6080 localhost:5900 & \
    bash -c "while true; do sleep 1000; done"
