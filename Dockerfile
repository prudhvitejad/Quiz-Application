# Use a base image with Node.js pre-installed
FROM node:latest

# Set the working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json files
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application files
COPY . .

# Set environment variable to disable FIPS mode
ENV NODE_OPTIONS="--openssl-legacy-provider"

# Build the project (if needed)
RUN npm run build

# Expose any necessary ports
EXPOSE 3000

# Command to run the application
CMD ["npm", "start"]
