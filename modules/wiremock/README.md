# WireMock Module

## ToC
1. [Introduction](#1-introduction)
2. [Scope](#2-scope)
3. [Repo Map](#3-repo-map)
4. [Pre-requisites](#4-pre-requisites)
5. [Getting Started](#5-getting-started)
6. [Next Steps](#6-next-steps)

---

## 1. Introduction
This module provides a WireMock server setup for mocking APIs in your project. WireMock is a flexible library for stubbing and mocking web services, allowing you to simulate API responses for testing and development purposes.

---

## 2. Scope
This module is intended for use in development and testing environments. It allows you to create mock API endpoints, simulate various response scenarios, and test your application's behavior without relying on real backend services.

**Limitations:**
- Autocompletion (CTRL+Space) works only if `apps/wiremock` folder is in the root of the base project repo.
- This module is not intended for production use.

---

## 3. Repo Map

```plaintext
.
├── docker-compose.yml   # Server configuration file
├── __extensions         # custom extensions for WireMock
├── __files              # external files used by WireMock responses (JSON, XML, binaries, etc.)
├── mappings             # http request and response mappings
├── README.md            # How to use WireMock module
├── schema               # JSON schema files for request and response validation (autocompletion)
└── .vscode              # Link schema to vscode settings
```

---

## 4. Pre-requisites

1. [Repo bootstrap](../../README.md) done.
2. [Repo scaffold](../../instructions/scaffold/project-scaffold-guide.md) done.
3. Docker installed and running on your machine.
   ```bash
   # validate docker installation
   docker --version
   ```
4. Docker Compose installed and running on your machine.
   ```bash
   # validate docker compose installation
   docker compose version
   ```
5. Docker login done to your docker hub account (optional - if account exists).
   ```bash
   # validate docker login
   docker login
   ```


---

## 5. Getting Started

### 5.1 Create directory
Go to root of base project repo.
```
mkdir -p apps/wiremock
```
Navigate to the `apps/wiremock` directory.  
```bash
cd apps/wiremock
``` 

---

### 5.2 Scaffold the project structure
Script and template will create wiremock folder structure including files/code and configuration.

Use script - `bin/scaffold/scaffold_project.sh`
Use template - `modules/wiremock/templates/wiremock-scaffold-template.txt`

Run the following command to scaffold the project structure:
```bash
cd project-playbook

bash bin/scaffold/scaffold_project.sh --template "$HOME/<full-path-to-project-playbook-folder>/project-playbook/modules/wiremock/templates/wiremock-scaffold-template.txt" --path "$HOME/<full-path-to-project-folder>/apps/wiremock" --dry-run
```
If you are happy with the output of the `dry-run`, run the command again without the `--dry-run` option to scaffold the project structure.

---

### 5.3 Commit and push the changes to the repository.
```
git add .
git commit -m "chore: Scaffold wiremock project structure"
git push -u origin main
```

---

### 5.4 Docker compose configuration (Optinal)

Default `docker-compose.yml` is perfectly fine for most of the use cases. You can use it as is. 
Feel free to modify in `apps/wiremock/docker-compose.yml` file as per your needs.

```yml
services:
  wiremock:
    image: wiremock/wiremock:3.13.1    # Use version as per your needs. Check for latest version at https://hub.docker.com/r/wiremock/wiremock/tags

    container_name: wiremock

    ports: 
      - "8085:8080"   # <>host-port>:<container-port>   # e.g. 8085:8080

    volumes:
      # <host-path>:<container-path>   # e.g. ./mappings:/home/wiremock/mappings
      - ./mappings:/home/wiremock/mappings
      - ./__files:/home/wiremock/__files
      - ./__extensions:/home/wiremock/__extensions

    command:
      - "--verbose"  # means print detailed logs to console
```

---

### 5.5 Start & Stop WireMock server

Go to `apps/wiremock` directory and run the following command to start the WireMock server:
```bash
cd apps/wiremock
docker compose up -d   # to start the WireMock server in detached mode
```

```bash
docker compose down   # to stop the WireMock server
```

---

## 6. Next Steps

Currently you have WireMock module in your base project. You can now start creating your mock API endpoints and test them with your frontend application.

If you need in your base project other modules like `Spring Boot`, `Wiremock`, etc. go to `./modules/<name-of-module>` folder and follow the instructions in the `README.md` file to add them to your project.

Example modules:
- [Spring Boot](../../modules/spring-boot/README.md)
- [Wiremock](../../modules/wiremock/README.md)
- [Angular](../../modules/angular/README.md)

For `HOW TO` guides of `Wiremock` module, go to `<project-name>/apps/wiremock/README.md` file.

---


### How to use WireMock

#### 1. Start WireMock server
To start the WireMock server, run the following command in the `apps/wiremock` directory:
```bash
cd apps/wiremock
docker compose up -d
```
Hint Docker command:
- docker compose down - Stop and remove containers
- docker compose ps - List containers
- docker compose logs -f - Follow log output
- docker compose restart - Restart containers

##### 2. Wiremock mappings changes

Restart the WireMock server using `docker compose restart` after making changes to mappings, files, or extensions.

#### 3. Test the WireMock server

```http
http://localhost:<host-port>/api/health or
http://localhost:<host-port>/__admin
```