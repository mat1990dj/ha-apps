FROM ghcr.io/home-assistant/base-python:3.13-alpine3.24

# Install system dependencies
RUN apk add --no-cache git

# Set working directory
WORKDIR /app

# Clone Logan's repository directly
RUN git clone https://github.com/attractify-logan/pecron-monitor.git .

# Install python requirements
RUN pip install --no-cache-dir -r requirements.txt

RUN mkdir -p /etc/services.d/pecron_monitor

COPY run.sh /etc/services.d/pecron_monitor/run
RUN chmod a+x /etc/services.d/pecron_monitor/run