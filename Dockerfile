FROM eclipse-temurin:21-jre

WORKDIR /app

COPY digibank-web/target/*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
