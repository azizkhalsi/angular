# Stage 1: Build the Angular app
FROM node:latest AS build

# Working directory: /app
WORKDIR /app

# Install dependencies
COPY package.json ./
RUN npm install

# Copy all project files and build the Angular app
COPY . .
RUN npm run build --prod  # This should generate static files in /app/dist/[project-name]

# Stage 2: Serve the app with NGINX
FROM nginx:latest

# Copy built Angular files to the NGINX html directory
# Make sure you copy from the RIGHT directory
COPY --from=build /app/dist/angular-project /usr/share/nginx/html  # Ensure 'angular-project' is correct

# Expose port 80
EXPOSE 80

# NGINX will run in the foreground
CMD ["nginx", "-g", "daemon off;"]
