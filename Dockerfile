# Use Node.js LTS image
FROM node:18

# Set working directory
WORKDIR /usr/src/app

# Copy app files
COPY app/ ./

# Expose port
EXPOSE 3000

# Run app
CMD ["node", "app.js"]

