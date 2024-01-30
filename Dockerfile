# Stage 1: Build the application
FROM node:14-alpine as build

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the application code to the working directory
COPY . .

# Build the application
RUN npm run build

# Stage 2: Create a smaller image for production
FROM nginx:alpine

# Copy the build files from Stage 1 to the NGINX public directory
COPY --from=build /app/build /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start NGINX when the container starts
CMD ["nginx", "-g", "daemon off;"]
