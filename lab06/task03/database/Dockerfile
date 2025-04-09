FROM mysql:8.0

# Set environment variables for MySQL
ENV MYSQL_ROOT_PASSWORD=rootpassword
# I am aware that this is not a good practice to hardcode passwords in Dockerfile
# It's just a quick app project to test connections
# and functionality, not a production app
ENV MYSQL_DATABASE=appdb
ENV MYSQL_USER=appuser
ENV MYSQL_PASSWORD=yourpassword
# as above, not a good practice to hardcode passwords in Dockerfile
# it's for learning purposes only :D
# if you read this and it's the reason I didn't land the job
# I can change, I swear I'll do better :3

COPY init.sql /docker-entrypoint-initdb.d/

# Expose MySQL default port
EXPOSE 3306
