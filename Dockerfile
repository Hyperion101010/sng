# Use a minimal Python base image
FROM python:3.9-slim

# Maintainer info
MAINTAINER Abhishek Chigurupati "ac11950@nyu.edu"

# Set working directory
WORKDIR /app

# Copy MNIST example code into container
COPY mnist /app/mnist

# Install dependencies
RUN pip install --no-cache-dir torch torchvision matplotlib

# Set default command to run training with custom parameters
CMD ["python", "mnist/main.py", "--epochs", "3", "--log-interval", "50"]
