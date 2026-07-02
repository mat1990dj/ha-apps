FROM python:3.11-slim

# Install system dependencies
RUN apt-get update && apt-get install -y jq git && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Clone Logan's repository directly
RUN git clone https://github.com/attractify-logan/pecron-monitor.git .

# Install python requirements
RUN pip install --no-cache-dir -r requirements.txt

# Copy our runner script into the image
COPY run.sh /app/run.sh
RUN chmod a+x /app/run.sh

CMD [ "/app/run.sh" ]