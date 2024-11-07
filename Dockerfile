FROM nginx:alpine

# Copy custom entrypoint script
COPY entrypoint.sh /entrypoint.sh

# Make the script executable
RUN chmod +x /entrypoint.sh

# Set the custom entrypoint script
ENTRYPOINT ["/entrypoint.sh"]

# Expose port 80
EXPOSE 80
