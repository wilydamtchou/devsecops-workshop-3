# DigiBank – Modular Monolith Banking Application

**Cloud Computing Professional License – University of the Mountains**  
**Workshop 2 – Static Security Analysis (SAST)**  
**By Engineer Willy Damtchou – July 2026**

---

## 🏦 1. Introduction

DigiBank is a modular monolith banking application built with Spring Boot and Maven. It serves as the practical foundation for the DevSecOps learning path of the UCC152-2 course. Workshop 2 focuses on static security analysis (SAST), applying the Shift Left principle to detect vulnerabilities early in the development lifecycle.

> “Workshop 2 is the first step explicitly dedicated to the security analysis of the DigiBank application.”

---

## 🧱 2. Architecture Overview

### 2.1 Modular Monolith Structure

The project is organized into five Maven modules:

```text
digibank-parent/
├── common-module
├── customer-module
├── account-module
├── transfer-module
└── digibank-web
```

### common-module
Cross-cutting concerns: exceptions, API responses, shared utilities.

### customer-module
Customer creation, validation, retrieval.

### account-module
Account creation, balance management, debit/credit operations.

### transfer-module
Financial transfers between accounts.

### digibank-web
Spring Boot entry point, REST controllers, configuration, Swagger/OpenAPI.

---

## ⚙️ 3. Technical Stack

| Layer | Technology |
|-------|------------|
| Language | Java 17 |
| Framework | Spring Boot 3.x |
| Build | Maven 3.9.x |
| Database | PostgreSQL |
| Testing | JUnit 5, Mockito |
| Mutation Testing | PITest |
| Static Analysis | SonarQube |
| Dependency Security | OWASP Dependency-Check |
| CI/CD | GitHub Actions |
| Documentation | Springdoc OpenAPI |

> “The tools selected for the workshop cover development, static analysis, dependency checking, test quality, and pipeline automation.”

---

## 🔐 4. DevSecOps & SAST Workflow

Workshop 2 applies the Shift Left principle: detect vulnerabilities as early as possible.

### Tools used

#### ✔ SonarQube
Detects vulnerabilities, code smells, hotspots, coverage.

#### ✔ OWASP Dependency-Check
Detects CVEs in dependencies.

#### ✔ PITest
Evaluates robustness of tests via mutation testing.

---

## 🛠️ 5. Workshop 2 – Step-by-Step Workflow

### Step 1 — Prepare the Environment

Install:
- Java 17
- Maven 3.9
- IntelliJ IDEA
- Docker Desktop
- PostgreSQL
- Git & GitHub

Verify:

```bash
java -version
mvn -version
git --version
docker --version
```

---

### Step 2 — Open & Build DigiBank

```bash
mvn clean install
```

Reload Maven modules in IntelliJ.

---

### Step 3 — Configure SAST Tools in the Parent POM

Add:
- SonarQube plugin
- OWASP Dependency-Check plugin
- PITest plugin
- Surefire plugin
- Centralized version management

> “It makes sense to add the versions of the control tools from Workshop 2 to the parent POM.”

---

### Step 4 — Run Static Analysis

#### SonarQube

Start SonarQube:

```bash
docker run -d --name sonarqube -p 9000:9000 sonarqube:lts-community
```

Run scan:

```bash
mvn clean verify sonar:sonar -Dsonar.login=YOUR_TOKEN
```

#### OWASP Dependency-Check

```bash
mvn org.owasp:dependency-check-maven:check -DnvdApiKey=YOUR_KEY
```

Report:

```text
target/dependency-check-report.html
```

#### PITest Mutation Testing

```bash
mvn org.pitest:pitest-maven:mutationCoverage
```

Report:

```text
target/pit-reports/
```

---

### Step 5 — Analyze Vulnerabilities

Categories:
- Insufficient input validation
- Overly revealing error messages
- Sensitive data exposure
- Weak business rules
- Secrets in configuration
- Outdated dependencies
- Fragile exception handling

> “The goal is not to passively launch a scan… but to understand the meaning of alerts.”

---

### Step 6 — Remediate Vulnerabilities

Examples:
- ✔ Remove secrets from configuration, database passwords must not appear in `application-dev.yml`.
- ✔ Strengthen DTO validation, add `@Pattern`, `@NotBlank`, `@Email`, etc.
- ✔ Improve error handling, use standardized API error envelopes.
- ✔ Harden business logic, validate transfer rules inside services.
- ✔ Update vulnerable dependencies, based on Dependency-Check report.
- ✔ Improve mutation coverage, add tests for edge cases.

---

### Step 7 — Final Validation

Run full pipeline:

```bash
mvn clean
mvn test
mvn clean verify
mvn dependency:tree
mvn org.owasp:dependency-check-maven:check
mvn org.pitest:pitest-maven:mutationCoverage
mvn clean verify sonar:sonar -Dsonar.login=YOUR_TOKEN
```

---

## 🚀 6. GitHub Actions CI/CD

Pipeline includes:
- Build
- Tests
- Dependency-Check
- PITest
- Artifact upload

> “This pipeline checks out the code, installs Java 17, rebuilds DigiBank, runs tests, scans dependencies, and produces PITest reports.”

---

## 🚀 11. CI/CD Pipeline – Full Documentation (SAST, SCA, QA, Docker, Security)

The DigiBank project includes a complete DevSecOps CI/CD pipeline implemented with GitHub Actions. This pipeline enforces security, quality, and reliability at every stage of development, following the Shift Left principle.

The pipeline is composed of three major jobs:
- SAST Pipeline (Build + Tests + Static Analysis + Security Scanning)
- Docker Build (Containerization only if SAST passes)
- Trivy Scan (Container vulnerability scanning)

Below is the full documentation of each step, its purpose, and its role in the DevSecOps workflow.

---

### 🔍 11.1 SAST Pipeline (Build + Tests + Static Analysis)

- **Step 1 — Checkout Source Code**  
  Retrieves the latest version of the repository.
- **Step 2 — Setup Java 17**  
  Installs Java 17 and configures Maven caching.
- **Step 3 — Maven Validate**  
  Validates the POM, plugins, and dependency graph.
- **Step 4 — Compile**  
  Ensures the code compiles successfully.
- **Step 5 — Unit Tests**  
  Runs JUnit tests and generates Surefire reports.
- **Step 6 — BDD Tests**  
  Runs Cucumber scenarios validating business behavior.
- **Step 7 — JaCoCo Coverage**  
  Generates `jacoco.xml` for SonarQube coverage analysis.
- **Step 8 — Secret Scanning (Gitleaks)**  
  Detects hardcoded secrets such as API keys and passwords.
- **Step 9 — Cache OWASP Dependency-Check**  
  Caches CVE database for faster SCA scans.
- **Step 10 — OWASP Dependency-Check**  
  Detects vulnerable dependencies (CVE-based).
- **Step 11 — SpotBugs**  
  Detects potential bugs (NPE, leaks, concurrency issues).
- **Step 12 — PMD**  
  Detects dead code, complexity, and bad practices.
- **Step 13 — Checkstyle**  
  Enforces coding standards and formatting rules.
- **Step 14 — PITest**  
  Evaluates the strength of unit tests via mutation testing.
- **Step 15 — Cache SonarQube**  
  Improves performance by caching scanner components.
- **Step 16 — SonarQube SAST + Quality Gate**  
  Aggregates all reports and enforces security thresholds.
- **Step 17 — Upload SAST Reports**  
  Publishes all reports as GitHub artifacts.

---

### 🐳 11.2 Docker Build Job

Runs only if SAST succeeds.

- **Step 18 — Build Docker Image**  
  Builds the DigiBank application container.

---

### 🛡️ 11.3 Trivy Container Security Scan

Runs only if Docker build succeeds.

- **Step 19 — Trivy Scan**  
  Scans the container for OS and library vulnerabilities.
- **Step 20 — Upload Trivy Report**  
  Publishes the container vulnerability report.

---

## 📦 7. Running DigiBank Locally

### Start PostgreSQL
Create DB `digibankdb`.

### Set environment variables

```bash
SPRING_DATASOURCE_URL=jdbc:postgresql://localhost:5432/digibankdb
SPRING_DATASOURCE_USERNAME=digibank
SPRING_DATASOURCE_PASSWORD=digibank123
```

### Run application

```bash
mvn spring-boot:run -pl digibank-web
```

---

## 🧪 8. API Documentation

Swagger/OpenAPI:
- `/swagger-ui.html`
- `/api-docs`

---

## 🎯 9. Learning Objectives Achieved

Students can:
- Explain SAST & Shift Left
- Identify static vulnerabilities
- Use SonarQube, Dependency-Check, PITest
- Remediate code & configuration weaknesses
- Deliver a hardened version of DigiBank
- Prepare for DAST in Workshop 3

---

## 🏁 10. Conclusion

DigiBank is now:
- Functionally stable
- Architecturally clean
- Instrumented for SAST
- Hardened against common vulnerabilities
- Ready for DAST
- Prepared for containerization & delivery pipelines

---

Willy, your README is now complete, enterprise-grade, and workshop-ready.
