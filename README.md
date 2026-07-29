Voici le README complet, structuré en **Workshop 3** et **Workshop 4**, avec les commandes, objectifs, checklists, vérifications et preuves attendues, et avec l’intégration de Trivy dans la logique CI/CD.[1][2]

## README final

```md
# DigiBank - Workshop 3 and Workshop 4 README

## Overview

This repository contains the DigiBank implementation aligned with **Workshop 3: Dynamic Security Analysis of DigiBank at Runtime** and **Workshop 4: Securing containers, dependencies, and deployment artifacts** from the course *UCC152-2 Introduction to Security in DevOps*.[file:1][file:6]

The project therefore documents and implements two complementary security stages: runtime security validation through DAST in Workshop 3, then container, dependency, and artifact hardening with pipeline automation in Workshop 4.[file:1][file:6]

## Project purpose

DigiBank is used as a realistic case study for a modern banking application with REST endpoints, a database, business services, containerized delivery, and CI/CD automation.[file:1][file:6] The goal is to secure the application from the source code level all the way to the packaged image and the delivery pipeline.[file:1][file:6]

Workshop 3 focuses on how the application behaves when it runs, while Workshop 4 focuses on what the application imports, packages, ships, and executes inside containers and build artifacts.[file:1][file:6]

## Repository structure

A recommended structure for this project is:[file:1][file:6]

```text
digibank-parent/
├── common-module/
├── customer-module/
├── account-module/
├── transfer-module/
├── digibank-web/
├── dast/
│   ├── postman/
│   ├── zap/
│   └── reports/
├── container-security/
│   ├── reports/
│   ├── notes/
│   └── scripts/
├── .github/
│   └── workflows/
├── Dockerfile
├── .dockerignore
├── docker-compose.yml
├── pom.xml
└── README.md
```

The repository may also contain exported reports, screenshots, notes, and scripts used during validation and remediation.[file:1][file:6]

# Workshop 3

## Objective

Workshop 3 extends the security work done previously by validating DigiBank at runtime with a DAST mindset.[file:1] The aim is to detect weaknesses visible through HTTP behavior, validate the application’s response quality, remediate the issues found, and then re-run the same scenarios to prove the corrections.[file:1]

## Workshop 3 scope

The Workshop 3 scope covers observable runtime weaknesses such as endpoint behavior, request validation, status codes, error handling, information leakage, and authorization or session-related issues visible from the outside.[file:1] It does not primarily focus on dependency analysis, Docker hardening, or pipeline security, which belong to Workshop 4.[file:1][file:6]

## Expected Workshop 3 outcomes

At the end of the DAST phase, the project should demonstrate:[file:1]

- Controlled HTTP responses and generic error messages.[file:1]
- Stronger validation at the API and service layers.[file:1]
- Reduced exposure of sensitive data in responses.[file:1]
- Reproducible testing through Postman, curl, Newman, and optionally OWASP ZAP.[file:1]
- Documented evidence of before/after correction behavior.[file:1]

## Workshop 3 checklist

- Start DigiBank in a stable environment.[file:1]
- Verify the main endpoints are accessible.[file:1]
- Explore the API using Swagger or Postman where enabled.[file:1]
- Run nominal and invalid scenarios on customers, accounts, and transfers.[file:1]
- Observe response codes, error messages, and data exposure.[file:1]
- Fix the weaknesses in DTOs, services, and exception handlers.[file:1]
- Replay the same tests to validate the fix.[file:1]

## Workshop 3 test scenarios

### Customers

Typical customer tests include creating a valid customer, trying an invalid email, sending malformed phone numbers or national IDs, checking duplicate email behavior, and querying a non-existent customer.[file:1]

### Accounts

Typical account tests include creating a valid account, attempting a negative balance, and querying a non-existent account.[file:1]

### Transfers

Typical transfer tests include a normal transfer, transfer to the same account, zero-amount transfer, and insufficient-balance transfer.[file:1]

## Workshop 3 commands

```bash
mvn clean install
mvn spring-boot:run -pl digibank-web
curl -i http://localhost:8080/api/customers/99999
newman run DigiBank-DAST.postman_collection.json -e DigiBank-Local.postman_environment.json
```

The workshop also encourages using OWASP ZAP to observe routes, headers, and response patterns directly from the running application.[file:1]

## Workshop 3 evidence

For each issue identified dynamically, keep evidence of:[file:1]

- The endpoint tested.[file:1]
- The request executed.[file:1]
- The observed response before correction.[file:1]
- The vulnerability type.[file:1]
- The impact on the application or data exposure.[file:1]
- The fix implemented.[file:1]
- The revalidation result after correction.[file:1]

## Workshop 3 remediation themes

The main remediation themes expected in Workshop 3 are:[file:1]

- Stronger input validation.[file:1]
- Reduced data exposure in response DTOs.[file:1]
- Safer centralized error handling.[file:1]
- Stronger service-layer safeguards for business rules.[file:1]
- Controlled Swagger exposure by profile.[file:1]

# Workshop 4

## Objective

Workshop 4 extends the security work by analyzing DigiBank as a complete software artifact: code, dependencies, container images, build files, secrets handling, and CI/CD controls.[file:6] The goal is to reduce attack surface, detect vulnerable dependencies, harden the container, and automate the checks in the pipeline.[file:6]

## Workshop 4 scope

The Workshop 4 scope includes Maven dependencies, transitive dependencies, pom.xml configuration, Dockerfile, docker-compose.yml, .dockerignore, runtime environment variables, secrets handling, image metadata, and GitHub Actions workflows related to dependency and container security.[file:6] It does not primarily repeat the runtime endpoint analysis covered in Workshop 3.[file:6]

## Expected Workshop 4 outcomes

At the end of the container and dependency security phase, the project should demonstrate:[file:6]

- Controlled and versioned dependency management.[file:6]
- A usable Dockerfile with clear build/runtime separation.[file:6]
- A reduced and better protected container image.[file:6]
- Externalized secrets and safer environment-variable usage.[file:6]
- Dependency and container checks automated in GitHub Actions.[file:6]
- Traceable evidence through reports and image metadata.[file:6]

## Workshop 4 checklist

- Reopen the existing DigiBank project cleanly in IntelliJ IDEA.[file:6]
- Run a full Maven build from the parent project.[file:6]
- Inspect the dependency graph with Maven.[file:6]
- Run OWASP Dependency-Check.[file:6]
- Build and inspect the Docker image.[file:6]
- Review the Docker history and image metadata.[file:6]
- Verify `.dockerignore` limits the build context.[file:6]
- Verify secrets are not hard-coded in versioned files or image layers.[file:6]
- Prepare and run the GitHub Actions workflow.[file:6]
- Add Trivy image scanning in the pipeline.[file:1][file:6]

## Recommended technical stack

The workshop uses the following tools and technologies:[file:6]

- Java JDK 17.[file:6]
- Maven 3.9.x.[file:6]
- Spring Boot.[file:6]
- Docker and Docker Compose.[file:6]
- OWASP Dependency-Check.[file:6]
- Trivy.[file:6]
- Git and GitHub.[file:6]
- GitHub Actions.[file:6]

## Configuration principles

The Spring configuration should remain environment-driven and avoid hard-coded secrets.[file:6] The `application.yml`, `application-dev.yml`, and `application-test.yml` files should use variables for datasource settings and keep security-sensitive defaults under control.[file:6]

Swagger/OpenAPI should remain disabled by default outside the development profile, and error exposure should stay minimal in shared artifacts.[file:6]

## Maven and dependency control

The parent `pom.xml` is the main entry point for dependency analysis and version centralization.[file:6] It should contain consistent version properties for the build and security plugins, plus the OWASP Dependency-Check plugin configured to fail the build when needed.[file:6]

Useful commands include:[file:6]

```bash
mvn clean
mvn compile
mvn test
mvn clean verify
mvn dependency:tree
mvn org.owasp:dependency-check-maven:check
mvn org.owasp:dependency-check-maven:purge
```

## Dockerfile and image hardening

The Dockerfile should use a multi-stage build so that Maven is only present in the build stage and the final runtime image contains only the necessary Java runtime and packaged application.[file:6] This reduces the attack surface and makes the artifact easier to inspect and maintain.[file:6]

The final image should also be evaluated for:[file:6]

- Base image choice.[file:6]
- Layer count and image size.[file:6]
- Port exposure.[file:6]
- Runtime user privileges.[file:6]
- Unnecessary components in the final image.[file:6]

## `.dockerignore`

A proper `.dockerignore` file should exclude build outputs, IDE files, local secrets, logs, temporary notes, DAST folders, and reports that do not belong in the container build context.[file:6] This reduces accidental file leakage into Docker layers and keeps the build context clean.[file:6]

## Docker Compose

A working `docker-compose.yml` should start DigiBank and PostgreSQL in a reproducible environment with environment variables rather than hard-coded credentials.[file:6] This helps keep the setup close to a real deployment while still remaining suitable for local analysis and automation.[file:6]

## Trivy integration

Trivy is added to analyze the final Docker image for vulnerabilities in system packages, embedded libraries, secrets, and misconfigurations.[file:1][file:6] In the final pipeline, Trivy complements Dependency-Check by covering the image layer rather than only Maven dependencies.[file:1][file:6]

## Workshop 4 commands

```bash
mvn clean install
mvn dependency:tree
mvn org.owasp:dependency-check-maven:check
docker build -t digibank:local .
docker image inspect digibank:local
docker history digibank:local
docker compose up --build
```

## Workshop 4 evidence

For each finding or remediation, keep evidence of:[file:6]

- The component or artifact analyzed.[file:6]
- The file or image involved.[file:6]
- The weakness detected.[file:6]
- The tool used to detect it.[file:6]
- The risk level and impact.[file:6]
- The remediation applied.[file:6]
- The verification command or rerun result.[file:6]

## Workshop 4 remediation themes

The main remediation themes expected in Workshop 4 are:[file:6]

- Minimize the container image.[file:6]
- Use a non-root runtime user.[file:6]
- Remove secrets from versioned files and image layers.[file:6]
- Update or replace vulnerable dependencies.[file:6]
- Limit Swagger exposure to development only.[file:6]
- Integrate automated dependency and image checks into the CI/CD pipeline.[file:6]

# CI/CD pipeline

## Pipeline overview

The GitHub Actions workflow is designed as a complete DevSecOps pipeline combining build, tests, static analysis, dependency scanning, Docker image creation, Trivy scanning, runtime deployment, Newman, and OWASP ZAP checks.[file:1][file:6] The pipeline also archives reports and metadata as artifacts for traceability.[file:1][file:6]

## Main pipeline stages

- Build and unit tests.[file:1]
- Cucumber tests.[file:1]
- JaCoCo coverage.[file:1]
- Secret scanning with Gitleaks.[file:1]
- OWASP Dependency-Check.[file:1][file:6]
- SpotBugs, PMD, Checkstyle, and PIT.[file:1]
- SonarQube quality gate.[file:1]
- Docker image build.[file:1][file:6]
- Trivy image scan.[file:1][file:6]
- Runtime deployment with PostgreSQL.[file:1]
- Newman API verification.[file:1]
- OWASP ZAP scanning.[file:1]
- Final artifact publication.[file:1]

## Pipeline secrets

Secrets such as `NVD_API_KEY`, SonarQube credentials, and any registry or deployment credentials must remain outside the repository and be injected at runtime through GitHub Secrets or equivalent mechanisms.[file:1][file:6]

## Final validation criteria

The project can be considered complete when all of the following are true:[file:1][file:6]

- The application still builds and runs normally.[file:1][file:6]
- DAST weaknesses are remediated and revalidated.[file:1]
- Dependency and container findings are reduced or justified.[file:6]
- The Docker image is cleaner and more controlled.[file:6]
- The pipeline reruns the main security checks automatically.[file:1][file:6]
- Artifacts and reports are preserved for traceability.[file:1][file:6]

## Revalidation commands

```bash
mvn clean
mvn test
mvn clean verify
mvn dependency:tree
mvn org.owasp:dependency-check-maven:check -DnvdApiKey=YOUR_NVD_API_KEY
docker build -t digibank:final .
trivy image --severity HIGH,CRITICAL digibank:final
```

## Repository usage

This README is intended as the main technical and pedagogical entry point for the DigiBank project. It summarizes the security work completed in Workshop 3 and Workshop 4, and it documents the source code, runtime validation, container hardening, dependency management, and CI/CD security automation required for the course.[file:1][file:6]
```