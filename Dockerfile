# Stage 1: Build the Angular App
FROM node:latest AS build

# Set working directory
WORKDIR /app

# Install dependencies
COPY package.json ./
RUN npm install

# Copy project files and build the Angular app
COPY . .
RUN npm run build --prod  # Generate production build

# Stage 2: Serve the Angular App with http-server
FROM node:alpine  # Using a lightweight Node.js image

# Install http-server for serving static files
RUN npm install -g http-server

# Copy the build output to the new container
COPY --from=build /app/dist/angular-project /usr/share/app

# Expose port 80 to the outside world
EXPOSE 80

# Command to run http-server and serve static files
CMD ["http-server", "/usr/share/app", "-p", "80"]
