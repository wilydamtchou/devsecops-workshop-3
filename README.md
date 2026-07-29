# DigiBank - Workshop 3 README

## Overview

This project corresponds to **Workshop 3: Dynamic Security Analysis of DigiBank at Runtime** in the course *UCC152-2 Introduction to Security in DevOps*. It extends the work carried out in Workshop 2 by moving from static analysis (SAST) to runtime verification through a DAST-oriented approach focused on HTTP behavior, exposed endpoints, validation robustness, access control consistency, session-related behavior, and information disclosure in API responses.[1]

The objective of this workshop is not only to run the application and execute API calls, but to design a structured dynamic security testing campaign, identify weaknesses observable at runtime, remediate them in the source code and configuration, and then revalidate the fixes using repeatable test scenarios.[1]

## Workshop objectives

This implementation is aligned with the pedagogical objectives of Workshop 3:

- Explain the role of DAST in a DevSecOps approach and its complementarity with SAST.[1]
- Prepare a clean and reproducible execution environment for DigiBank.[1]
- Design and execute security-oriented API tests on the running application.[1]
- Observe HTTP status codes, response structures, validation behavior, and error handling.[1]
- Detect vulnerabilities visible at runtime, especially around validation, access control, information leakage, and inconsistent business behavior.[1]
- Correct the weaknesses revealed by dynamic analysis without breaking the business logic.[1]
- Re-run the same scenarios after remediation to demonstrate security improvement.[1]
- Produce technical deliverables showing the test campaign, observed issues, implemented corrections, and evidence of revalidation.[1]

## Scope of the implementation

The work implemented in this application focuses on vulnerabilities that can be observed externally while DigiBank is running. In practice, this includes REST endpoints, request parameters, controller responses, error messages, input validation, unauthorized access handling, and visible symptoms of weak session or exception management.[1]

The workshop does **not** primarily target exhaustive dependency analysis, deep container image hardening, or packaging security; those topics are positioned as subsequent stages in the broader DevSecOps progression.[1]

## Main security improvements expected in Workshop 3

According to the workshop guide, the runtime analysis and remediation phase should particularly address the following points:[1]

- Overly detailed error messages returned by the API.[1]
- Exposure of unnecessary technical information in HTTP responses.[1]
- Insufficient input validation visible from public endpoints.[1]
- Weak or bypassable access control on some routes.[1]
- Inconsistent or incomplete handling of business and session-related situations.[1]
- Abnormal behavior triggered by missing, invalid, falsified, or hostile parameters.[1]
- Mismatches between intended business logic and observed API behavior.[1]

In the implementation delivered for this workshop, the codebase is therefore expected to provide a more defensive runtime posture: generic and controlled error responses, stronger validation rules, reduced exposure of sensitive information, and more consistent business rule enforcement in service-layer operations.[1]

## Suggested project structure

The workshop document expects DigiBank to remain a multi-module Maven/Spring Boot project built around a parent project and functional modules such as `common-module`, `customer-module`, `account-module`, `transfer-module`, and `digibank-web`. A typical structure is shown below:[1]

```text
 digibank-parent/
 ├── common-module/
 ├── customer-module/
 ├── account-module/
 ├── transfer-module/
 ├── digibank-web/
 ├── postman/
 ├── zap/
 └── README.md
```

If the implementation includes additional folders for Postman collections, Newman reports, screenshots, or automation scripts, they should remain clearly organized so that the DAST campaign and its evidence are easy to understand and reproduce.[1]

## Technical stack

The workshop is designed around the following tools and technologies:[1]

- Java 17.[1]
- Maven 3.9.x or a compatible version.[1]
- Spring Boot.[1]
- PostgreSQL, optionally through Docker.[1]
- Docker and Docker Compose for reproducible execution.[1]
- IntelliJ IDEA or an equivalent IDE.[1]
- Swagger/OpenAPI for controlled endpoint exploration in development.[1]
- Postman for manual and semi-structured dynamic tests.[1]
- Newman for replaying Postman collections in a repeatable way.[1]
- OWASP ZAP for passive and active runtime observation.[1]
- Git and GitHub for traceability of fixes.[1]

## Prerequisites

Before starting the application, verify that the development environment provides the minimum tools expected in the workshop.[1]

```bash
java -version
mvn -version
git --version
docker --version
psql --version
```

The application should compile cleanly before any dynamic testing begins, because the workshop explicitly distinguishes real security findings from simple startup or configuration failures.[1]

## Build and run

From the root of the parent project, build the complete multi-module application with:

```bash
mvn clean install
```

This global build is part of the standard verification flow recommended in the workshop because it confirms that the version submitted to DAST still compiles correctly and is not already broken before runtime analysis starts.[1]

Then start the application using the appropriate Spring profile for the target environment. In the workshop, the development profile is used for local execution, with configuration centered on `application.yml`, `application-dev.yml`, and `application-test.yml`.[1]

A typical local launch can follow one of these patterns:

```bash
mvn spring-boot:run -pl digibank-web
```

or

```bash
java -jar digibank-web/target/digibank-web.jar
```

If the project uses Docker Compose for PostgreSQL or for the full runtime environment, start the supporting services first so that DigiBank boots in a stable and reproducible context, as required by the workshop methodology.[1]

## Configuration principles

Workshop 3 expects the application configuration to reduce unnecessary exposure while preserving a usable development environment. In particular, the workshop recommends:[1]

- Disabling detailed server error exposure in public responses, especially stack traces, binding errors, and overly precise messages.[1]
- Using environment-specific configuration files such as `application-dev.yml`, `application-test.yml`, and optionally `application-prod.yml`.[1]
- Keeping Swagger/OpenAPI enabled only where it is a deliberate development choice and disabling it in more restrictive profiles.[1]

A key alignment point with the TP is that security hardening must be visible both in configuration and in observable HTTP behavior.[1]

## API exploration

In the workshop sequence, Swagger/OpenAPI is used first as a comprehension and preparatory tool to map the exposed routes before launching broader DAST activities. When enabled in the development profile, the application may expose paths such as:[1]

- `/swagger-ui.html` or the configured Swagger UI path.[1]
- `/api-docs` or the configured OpenAPI path.[1]

These endpoints are useful during development, but one of the expected remediation points in Workshop 3 is to control or disable this exposure outside the intended environment.[1]

## Dynamic testing workflow

The README for this TP should clearly reflect the expected dynamic testing progression:[1]

1. Start DigiBank in a clean and stable environment.[1]
2. Verify that the main endpoints respond correctly.[1]
3. Explore the API surface using Swagger and/or Postman.[1]
4. Execute nominal and abnormal requests against customer, account, and transfer endpoints.[1]
5. Observe status codes, response bodies, error messages, and signs of excessive disclosure.[1]
6. Use OWASP ZAP to complement manual exploration with passive or active runtime observation.[1]
7. Link the observed weaknesses to concrete code areas such as DTOs, services, handlers, and configuration files.[1]
8. Implement remediations in the source code.[1]
9. Replay the scenarios with Postman, Newman, and optionally ZAP to confirm the improvement.[1]

## Example scenarios covered by the TP

The workshop explicitly encourages testing normal and abnormal cases on the main business endpoints. Typical scenarios include:[1]

### Customers

- Create a valid customer.[1]
- Submit an invalid email address.[1]
- Submit malformed phone numbers or national IDs.[1]
- Re-submit an already existing email to observe duplicate handling.[1]
- Request a non-existent customer identifier.[1]

### Accounts

- Create a valid account.[1]
- Attempt account creation with a negative initial balance.[1]
- Request a non-existent account.[1]

### Transfers

- Execute a nominal transfer.[1]
- Attempt a transfer to the same account.[1]
- Attempt a zero-amount transfer.[1]
- Attempt a transfer with insufficient balance.[1]

These scenarios are important because the workshop is centered on observing the security quality of the running system rather than only reading the code.[1]

## Remediation themes implemented

Based on the workshop guidance, the code written for this TP should reflect several categories of remediation.[1]

### 1. Stronger input validation

The workshop expects defensive validation on DTOs and normalization of sensitive fields where relevant, especially for customer data such as email, phone number, and national ID. The purpose is to ensure that malformed requests are consistently rejected at runtime with controlled messages.[1]

### 2. Reduced data exposure

The workshop explicitly highlights the removal of unnecessary sensitive fields from API responses, such as `nationalId`, in order to comply with data minimization principles.[1]

### 3. Safer error handling

One of the most visible DAST improvements is the replacement of overly explicit business and technical messages with stable, generic, and homogeneous API error responses handled through a centralized exception strategy.[1]

### 4. Stronger service-layer safeguards

The workshop also expects critical operations such as money transfer and account debit to be protected at the service layer, not only through DTO constraints, so that edge cases and indirect calls remain safely handled.[1]

### 5. Controlled Swagger exposure

Swagger should remain a conscious development aid, not an always-exposed surface. The TP therefore aligns with the workshop by enabling it only in appropriate profiles and disabling it elsewhere.[1]

## Suggested commands for reproducible tests

The workshop provides `curl` examples to demonstrate that security tests remain reproducible outside graphical tools. The following examples can be adapted to the final implementation:[1]

```bash
curl -i http://localhost:8080/api/customers/99999
```

```bash
curl -X POST http://localhost:8080/api/customers \
  -H "Content-Type: application/json" \
  -d '{
    "fullName": "Test User",
    "email": "bad-email",
    "phoneNumber": "abc123",
    "nationalId": "???"
  }'
```

```bash
curl -X POST http://localhost:8080/api/transfers \
  -H "Content-Type: application/json" \
  -d '{
    "sourceAccountId": 1,
    "destinationAccountId": 1,
    "amount": 0,
    "description": "invalid"
  }'
```

Expected results after remediation include coherent HTTP 400 or 404 responses, generic public error messages, and the absence of stack traces or raw internal details in the returned payloads.[1]

## Newman revalidation

A central requirement of Workshop 3 is to replay the Postman collection after remediation in order to prove the effectiveness of the fixes. A typical command is:[1]

```bash
newman run DigiBank-DAST.postman_collection.json -e DigiBank-Local.postman_environment.json
```

This step is important because it transforms manual testing into a repeatable revalidation campaign aligned with DevSecOps principles of traceability and progressive automation.[1]

## OWASP ZAP usage

The workshop also recommends using OWASP ZAP to enrich the dynamic analysis. At minimum, the DAST campaign should observe:[1]

- Automatically discovered routes.[1]
- The presence or absence of Swagger and API documentation depending on the active profile.[1]
- Passive alerts on HTTP headers and responses.[1]
- Messages that reveal too much information.[1]
- Parameters visible in runtime traffic.[1]

ZAP findings should always be correlated with actual code or configuration choices in the project, such as `springdoc` configuration, exception handling, DTO validation, or response design.[1]

## Evidence and deliverables

The workshop makes it clear that the final submission should not be reduced to a set of screenshots. For each dynamically observed weakness, the expected evidence should document:[1]

- The module or endpoint concerned.[1]
- The suspected source in the codebase.[1]
- The executed request.[1]
- The response obtained before correction.[1]
- The type of weakness observed.[1]
- The potential security impact.[1]
- The tool used for observation, such as Postman, curl, or ZAP.[1]
- The correction implemented.[1]
- The proof of successful revalidation after remediation.[1]

A complete TP-aligned repository may therefore include Postman collections, Newman outputs, ZAP captures, before/after response examples, and a short vulnerability tracking sheet for each issue treated during the workshop.[1]

## Final validation criteria

At the end of Workshop 3, the application is expected to satisfy four major conditions:[1]

- DigiBank still starts correctly and supports nominal business operations.[1]
- Previously observed risky behaviors are reduced or eliminated.[1]
- Dynamic testing tools no longer report the same visible weaknesses under the same conditions.[1]
- The evidence of correction is organized clearly enough to support demonstration, grading, and future security industrialization steps.[1]

## Git traceability

The workshop recommends creating a Git baseline before introducing the DAST environment and related artifacts. A typical sequence is:[1]

```bash
git status
git add .
git commit -m "Baseline before DAST environment setup"
```

This practice improves the traceability of security-related modifications and clearly separates the project state before and after Workshop 3 remediation activities.[1]

## Repository README usage

This README can be used as the main functional and security-oriented entry point of the DigiBank Workshop 3 repository. To stay fully aligned with the TP, it should accompany the actual source code, Postman collection, any Newman or ZAP evidence, and the corrected configuration and service code that demonstrate the transition from dynamic observation to remediation and revalidation.[1]
