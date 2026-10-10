# Placeholder for Spring Boot module README

Which of those technologie belongs to default Spring Boot setup?

| Question          | Typical choice         | Application Deps | Infrastructure tooling | Default |
| ----------------- | ---------------------- | ---------------- | -------------------- | -------- |
| Language          | Java                   | Yes | No | Yes |
| Build             | Maven                  | Yes | No | Yes |
| Packaging         | Jar                    | Yes | No | Yes |
| Java              | 21 or 25               | Yes | No | Yes |
| Spring Boot       | current stable release | Yes | No | Yes |
| API               | Spring Web             | Yes | No | Yes |
| Validation        | Validation             | Yes | No | Yes |
| Persistence       | JPA                    | Yes | No | Yes* |
| Testing           | Spring Boot Test       | Yes | No | Yes |
| API documentation | Springdoc/OpenAPI      | Yes | No | ⏳ |
| Caching           | Spring Cache           | Yes | No | No |
| Messaging          | Spring Messaging       | Yes | No | No |
| Security           | Spring Security        | Yes | No | ⏳ |
| Database          | PostgreSQL             | No  | Yes | Yes* |
| DB migration      | Flyway                 | No  | Yes | Yes* |
| Runtime           | Docker                 | No  | Yes | ⏳ |

*Assuming that standard backend is Database-Backend REST API.

| Type           | What it is                      | Typical use                               |
| -------------- | ------------------------------- | ----------------------------------------- |
| `rest-api`     | HTTP REST API                   | Most traditional web/mobile backends      |
| `graphql-api`  | GraphQL API                     | Clients needing flexible queries          |
| `grpc-service` | gRPC service                    | Internal/service-to-service communication |
| `messaging`    | Message-driven application      | Kafka/RabbitMQ consumers/producers        |
| `batch`        | Batch processing application    | Imports, ETL, scheduled data processing   |
| `worker`       | Background worker               | Async jobs, queue processing              |
| `scheduler`    | Scheduled application           | Cron-like recurring jobs                  |
| `web-app`      | Server-rendered web application | MVC/Thymeleaf-style applications          |
| `cli`          | Command-line application        | Developer/admin tools                     |
| `library`      | Reusable Java library           | Shared Java components                    |

```
┌─────────────────────────┐  
│       order-service     │ 
│                         │ 
│ REST API                │ 
│ Kafka producer          │ 
│ Kafka consumer          │
│ Scheduled jobs          │
│ PostgreSQL              │
│ Flyway                  │
| gRPC client ----------------------------> user-service
└─────────────────────────┘

┌─────────────────────────┐
│     user-service        │
│                         │
│ REST API                │
│ Kafka producer          │
│ Kafka consumer          │
│ Scheduled jobs          │
│ PostgreSQL              │
│ Flyway                  │
│ gRPC server -----------------------------------> order-service
└─────────────────────────┘

┌─────────────────────────┐
│   inventory-service     │
│                         │
│ REST API                │
│ Kafka producer          │
│ Kafka consumer          │
│ Scheduled jobs          │
│ PostgreSQL              │
│ Flyway                  │
│ gRPC client ----------------------------> order-service
└─────────────────────────┘

```

```
spring-service-scaffold
│
├── base
│
├── rest
│
├── grpc-client
│
├── grpc-server
│
├── kafka-producer
│
├── kafka-consumer
│
├── scheduler
│
├── postgres
│
├── flyway
│
└── observability
```

```
$ ./main-spring-boot.sh

Service name: order-service

Select features:
  [x] REST API
  [x] Kafka producer
  [x] Kafka consumer
  [x] Scheduler
  [x] PostgreSQL
  [x] Flyway
  [x] Observability
  [ ] gRPC server
  [x] gRPC client

Generate order-service? [Y/n]
```

```
├── apps/
│   ├── frontend/
│   │   └── src/
│   │
│   └── backend/
|       ├── application/
|       |   ├── core/
|       |   |   └── .gitkeep
|       |   ├── integration/
|       |   |   └── .gitkeep
|       |   └── reporting/
|       |       └── .gitkeep
|       |
│       ├── services/
│       │   ├── order-service/
│       │   |   ├── .mvn/
│       │   |   ├── src/
│       │   |   ├── .gitattributes
│       │   |   ├── .gitignore
│       │   |   ├── HELP.md
│       │   |   ├── mvnw
│       │   |   ├── mvnw.cmd
│       │   |   └── pom.xml
│       │   ├── user-service/
│       │   └── inventory-service/
│       │
│       ├── contracts/
│       │   ├── grpc/
│       │   │   └── user.proto
│       │   ├── events/
│       │   │   └── UserCreated.avsc
│       │   └── openapi/
│       │       └── user-service.yml
│       │
│       └── libs/
│           ├── common/
│           |   └── .gitkeep
│           ├── security/
│           |   └── .gitkeep
│           ├── messaging/
│           │   └── .gitkeep
│           └── domain-types/
│               └── .gitkeep
```

```
service: order-service
    feature: rest
        --> dependencies: web
        --> source/configuration: REST-related setup

    feature: postgres
        → dependencies: postgresql, data-jpa
        → configuration: datasource

    feature: flyway
        → dependencies: flyway-core
        → configuration: migration scripts location

    feature: observability
        → dependencies: actuator
        → dependencies: micrometer/otel/etc.
        → source/configuration: observability setup
```

```
feature
├── dependencies
├── configuration
├── source files
└── resources
```

```
spring-boot/hybrid:
  user-service:
    postgres feature
    ├── dependencies (curl --data-urlencode "dependencies=web,actuator)
    │   ├── postgresql
    │   └── data-jpa
    │
    ├── configuration (application.properties)
    |   ├── spring.datasource.url=${DATABASE_URL}
    |   ├── spring.datasource.username=${DATABASE_USERNAME}
    |   ├── spring.datasource.password=${DATABASE_PASSWORD}
    |   └── spring.jpa.open-in-view=false
    |
    ├── source 
    |   └── TBD
    |
    ├── resource
    |   └── TBD
    |
    ├── environment (.env.example) 
    |   ├── DATABASE_URL=""
    |   ├── DATABASE_USERNAME=""
    |   └── DATABASE_PASSWORD=""
```