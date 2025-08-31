# Use official JDK runtime as base
FROM openjdk:21-jdk-slim

EXPOSE 8000

# Set working directory
WORKDIR /app

# Copy jar file into container
COPY target/*.jar app.jar

# Run the jar
ENTRYPOINT ["java", "-jar", "app.jar"]

