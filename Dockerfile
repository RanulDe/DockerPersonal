# Start with a base image that includes Java 22
FROM eclipse-temurin:22-jdk

# Install dependencies
RUN apt-get update && apt-get install -y \
    wget \
    gnupg \
    unzip \
    curl \
    libglib2.0-0 \
    libnss3 \
    libfontconfig1 \
    libdbus-1-3 \
    libxcomposite1 \
    libxcursor1 \
    libxi6 \
    libxtst6 \
    libxss1 \
    libxrandr2 \
    libasound2t64 \
    libpangocairo-1.0-0 \
    libatk1.0-0 \
    libatk-bridge2.0-0 \
    libgtk-3-0 \
    libdrm2 \
    libgbm1 \
    && rm -rf /var/lib/apt/lists/*

# Create the directory for Chrome
RUN mkdir -p /opt/google/chrome

# Install Chrome for Testing (latest stable version)
RUN wget -O /tmp/chrome-linux64.zip "https://edgedl.me.gvt1.com/edgedl/chrome/chrome-for-testing/130.0.6723.91/linux64/chrome-linux64.zip" && \
    unzip /tmp/chrome-linux64.zip -d /opt/google/chrome && \
    ln -s /opt/google/chrome/chrome-linux64/chrome /usr/local/bin/google-chrome && \
    rm /tmp/chrome-linux64.zip

# Install ChromeDriver for Testing (matching version)
RUN wget -O /tmp/chromedriver-linux64.zip "https://edgedl.me.gvt1.com/edgedl/chrome/chrome-for-testing/130.0.6723.91/linux64/chromedriver-linux64.zip" && \
    unzip /tmp/chromedriver-linux64.zip -d /usr/local/bin && \
    mv /usr/local/bin/chromedriver-linux64/chromedriver /usr/local/bin/chromedriver && \
    rm -rf /tmp/chromedriver-linux64.zip /usr/local/bin/chromedriver-linux64

# Set environment variables
ENV CHROME_BIN=/usr/local/bin/google-chrome \
    CHROME_DRIVER=/usr/local/bin/chromedriver

# Verify installations
RUN google-chrome --version && \
    google-chrome --headless --no-sandbox --disable-gpu --version && \
    chromedriver --version