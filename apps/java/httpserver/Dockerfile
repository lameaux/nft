FROM gradle:jdk23 AS builder

WORKDIR /

COPY .. .
RUN gradle build --no-daemon


FROM eclipse-temurin:21-alpine

WORKDIR /

COPY --from=builder /app/build/libs/app.jar .

CMD ["java", "-jar", "app.jar"]
