### BUILD STAGE ###
FROM eclipse-temurin:11-jdk-jammy AS build

WORKDIR /app
COPY . .

# Build your app
RUN ./mvnw -DskipTests clean package

### RUNTIME STAGE ###
FROM eclipse-temurin:11-jre-jammy

# Create secure user
RUN groupadd --system javauser && \
    useradd --system --shell /usr/sbin/nologin --gid javauser javauser

WORKDIR /app
COPY --from=build /app/target/*.jar app.jar

USER javauser
EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]