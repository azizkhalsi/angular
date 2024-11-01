# Use Node.js image as the base for the build-stage
FROM node:latest

# Create app directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package.json /app/
COPY package-lock.json /app/

# Install dependencies
RUN npm install

# Copy the rest of the application files to the container
COPY . /app/

# Expose port 4200 for Angular dev server
EXPOSE 4200

# Start the Angular app in development mode
CMD ["npm", "run", "start"]
