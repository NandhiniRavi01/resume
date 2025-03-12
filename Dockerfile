# Dockerfile for React frontend

# Use official Node.js image
FROM node:16

# Set the working directory
WORKDIR /app

# Copy the package.json and install dependencies
COPY frontend/package.json frontend/package-lock.json ./
RUN npm install

# Copy the rest of the frontend code
COPY frontend/ ./

# Build the React app
RUN npm run build

# Install a simple HTTP server to serve the static files
RUN npm install -g serve

# Expose the React app port
EXPOSE 3000

# Run the React app
CMD ["serve", "-s", "build", "-l", "3000"]

