# Use an official Python runtime as a parent image
FROM python:3.11-slim

# Set the working directory in the container
WORKDIR /app

# Install system dependencies required for a virtual display and VNC
# and the dependencies needed for Playwright
RUN apt-get update && apt-get install -y \
    xvfb \
    x11vnc \
    websockify \
    wget \
    libglib2.0-0 \
    libnss3 \
    libnspr4 \
    libatk1.0-0 \
    libatk-bridge2.0-0 \
    libcups2 \
    libatspi2.0-0 \
    libgbm1 \
    libxkbcommon0 \
    libpango-1.0-0 \
    libcairo2 \
    libasound2 \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies with Poetry
# Copy poetry lock files and install dependencies directly using pip
COPY pyproject.toml poetry.lock ./
RUN pip install poetry && \
    poetry export -f requirements.txt --output requirements.txt --without-hashes && \
    pip install --no-cache-dir -r requirements.txt

# Install Playwright
RUN pip install playwright && \
    playwright install

# Download and set up noVNC
RUN wget https://github.com/novnc/noVNC/archive/refs/tags/v1.3.0.tar.gz && \
    tar -xvzf v1.3.0.tar.gz && \
    mv noVNC-1.3.0 /noVNC && \
    ln -s /noVNC/vnc_lite.html /noVNC/index.html

# Copy the custom vnc_auto.html if any changes
COPY vnc_auto.html /noVNC/vnc_auto.html

# Copy the entire application source
COPY . /app

# Set environment variables
ENV DISPLAY=:99
ENV VNC_SERVER=localhost:5900
ENV PYTHONPATH=/app

# Expose the necessary ports
EXPOSE 3030 6080

# Command to start services
# Command to start services
CMD ["sh", "-c", "Xvfb :99 -screen 0 1024x768x16 & x11vnc -display :99 -forever -nopw -shared & websockify --web /noVNC 6080 localhost:5900 & uvicorn src.oai_agent.oai_agent:app --host 0.0.0.0 --port 3030 --reload"]

