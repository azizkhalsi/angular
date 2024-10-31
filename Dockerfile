# Stage 1: Build the Angular app
FROM node:latest AS build

# Working directory: /app
WORKDIR /app

# Install dependencies
COPY package.json ./
RUN npm install

# Copy all project files and build the Angular app
COPY . .
RUN npm run build --prod  # Build Angular for production

# Stage 2: Serve the app with NGINX
FROM nginx:latest

# Copy built Angular files to the NGINX html directory
COPY --from=build /app/dist/angular-project /usr/share/nginx/html

# Copy custom Nginx configuration
COPY angular/nginx.conf /etc/nginx/conf.d/default.conf  # Ensure correct relative path

# Expose port 80
EXPOSE 80

# NGINX will run in the foreground
CMD ["nginx", "-g", "daemon off;"]
