# Stage 1: Node.js Scraper
FROM node:18-slim as scraper

# Install necessary dependencies for Puppeteer and Chromium
RUN apt-get update && apt-get install -y \
    chromium \
    fonts-liberation \
    libappindicator3-1 \
    libasound2 \
    libatk-bridge2.0-0 \
    libatk1.0-0 \
    libcups2 \
    libdbus-1-3 \
    libx11-xcb1 \
    libxcomposite1 \
    libxdamage1 \
    libxrandr2 \
    xdg-utils \
    && apt-get clean

WORKDIR /app

# Copy package.json and install the necessary npm dependencies (Puppeteer)
COPY package.json .
RUN npm install puppeteer

# Copy the scraping script
COPY scrape.js .

# Set environment variable for dynamic URL
ENV SCRAPE_URL=https://example.com

# Run the script to scrape data and create scraped_data.json
RUN node scrape.js


# Stage 2: Python Flask App
FROM python:3.10-slim

WORKDIR /app

# Copy scraped_data.json from the Node.js scraper stage
COPY --from=scraper /app/scraped_data.json .

# Copy Flask server code and requirements file
COPY server.py requirements.txt ./

# Install Flask via pip
RUN pip install -r requirements.txt

# Expose port 5000 for the Flask app to run
EXPOSE 5000

# Run the Flask server when the container starts
CMD ["python", "server.py"]
