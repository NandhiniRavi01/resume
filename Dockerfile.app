# Use Python official image
FROM python:3.9-slim

# Set working directory
WORKDIR /app

# Copy the requirements file and install dependencies
COPY requirments.txt .
RUN pip install -r requirments.txt

# Copy the application code
COPY . .

# Expose the port that the backend will run on
EXPOSE 5000

# Command to run the backend app with gunicorn to keep it running
CMD ["gunicorn", "-b", "0.0.0.0:5000", "app:app"]
