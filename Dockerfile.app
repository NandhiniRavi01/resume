# Dockerfile for app.py (Backend 1)

FROM python:3.9-slim

# Set the working directory
WORKDIR /app

# Copy the backend code for app.py
COPY . .

# Install dependencies
RUN pip install --no-cache-dir -r requirments.txt

# Expose port for app.py
EXPOSE 5000

# Run app.py
CMD ["python", "app.py"]

