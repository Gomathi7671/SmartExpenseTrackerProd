#
# Build stage
#
FROM maven:3.8.3-openjdk-17 AS build

# Set working directory inside the image
WORKDIR /app

# Copy pom.xml first to enable dependency caching
COPY pom.xml .

# Download dependencies (optional but speeds up builds)
RUN mvn -q -DskipTests dependency:go-offline

# Copy the rest of the project
COPY . .

# Build the jar
RUN mvn clean package -DskipTests


#
# Package stage
#
FROM eclipse-temurin:17-jdk

WORKDIR /app

# Copy the built jar from the build container
COPY --from=build /app/target/SmartSpendexpensetracker-0.0.1-SNAPSHOT.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
