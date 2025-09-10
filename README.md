# BoardgameListingWebApp

## Description

**Board Game Database Full-Stack Web Application.**
This web application displays lists of board games and their reviews. While anyone can view the board game lists and reviews, they are required to log in to add/ edit the board games and their reviews. The 'users' have the authority to add board games to the list and add reviews, and the 'managers' have the authority to edit/ delete the reviews on top of the authorities of users.  

## Technologies

- Java
- Spring Boot
- Amazon Web Services(AWS) EC2
- Thymeleaf
- Thymeleaf Fragments
- HTML5
- CSS
- JavaScript
- Spring MVC
- JDBC
- H2 Database Engine (In-memory)
- JUnit test framework
- Spring Security
- Twitter Bootstrap
- Maven

## Features

- Full-Stack Application
- UI components created with Thymeleaf and styled with Twitter Bootstrap
- Authentication and authorization using Spring Security
  - Authentication by allowing the users to authenticate with a username and password
  - Authorization by granting different permissions based on the roles (non-members, users, and managers)
- Different roles (non-members, users, and managers) with varying levels of permissions
  - Non-members only can see the boardgame lists and reviews
  - Users can add board games and write reviews
  - Managers can edit and delete the reviews
- Deployed the application on AWS EC2
- JUnit test framework for unit testing
- Spring MVC best practices to segregate views, controllers, and database packages
- JDBC for database connectivity and interaction
- CRUD (Create, Read, Update, Delete) operations for managing data in the database
- Schema.sql file to customize the schema and input initial data
- Thymeleaf Fragments to reduce redundancy of repeating HTML elements (head, footer, navigation)

## How to Run

1. Clone the repository
2. Open the project in your IDE of choice
3. Run the application
4. To use initial user data, use the following credentials.
  - username: bugs    |     password: bunny (user role)
  - username: daffy   |     password: duck  (manager role)
5. You can also sign-up as a new user and customize your role to play with the application! 😊


# 🧩 Boardgame CI/CD Pipeline

This repository contains a Jenkins pipeline that automates the build, test, security scan, and deployment of a Java-based board game application to Amazon EKS using Docker and AWS ECR.

## 🚀 Pipeline Overview

The Jenkins pipeline performs the following stages:

1. **Checkout**  
   Clones the source code from the `main` branch of GitHub.

2. **SonarQube Analysis**  
   Runs static code analysis using SonarQube.

3. **Quality Gate**  
   Waits for SonarQube's quality gate result and aborts if it fails.

4. **Compile & Test**  
   Compiles the code and runs unit tests using Maven.

5. **Package & Archive**  
   Packages the application into a `.jar` file and archives it as a build artifact.

6. **Docker Build**  
   Builds a Docker image tagged with the Jenkins build number.

7. **Trivy Security Scan**  
   Scans the Docker image for vulnerabilities with severity `HIGH` and `CRITICAL`.

8. **AWS Identity Verification**  
   Verifies AWS credentials using a proxy script.

9. **Login to AWS ECR**  
   Authenticates Docker to push images to AWS Elastic Container Registry.

10. **Push Docker Image**  
    Pushes the built image to the specified ECR repository.

11. **Deploy to EKS**  
    Updates the Kubernetes deployment YAML with the new image tag and applies it to the EKS cluster.

12. **Restart Deployment**  
    Restarts the Kubernetes deployment to apply the new image.

---

## 🛠️ Prerequisites

- Jenkins with:
  - Maven and JDK tools configured (`mvn-system-install`, `jdk-system-install`)
  - SonarQube plugin and server configured (`SonarQube-Jenkins`)
- AWS CLI installed and configured
- Docker installed
- Trivy installed for image scanning
- `aws-proxy.sh` script for secure AWS CLI execution
- Access to:
  - AWS ECR registry
  - EKS cluster

---

## 📦 Deployment Notes

- The Kubernetes deployment file `boardgame-deployment.yaml` must contain a placeholder `__IMAGE_TAG__` which gets replaced during deployment.
- Ensure the Jenkins EC2 instance has IAM permissions to interact with ECR and EKS.
- The pipeline uses `kubectl rollout restart` to trigger a fresh deployment after applying the new image.

---

## 🔐 Security

- Trivy enforces a fail-fast policy for critical vulnerabilities (`--exit-code 1`).
- AWS identity is verified before pushing to ECR or deploying to EKS.
- Docker login uses secure password injection via AWS CLI.

---

## 📁 Artifact Location

- Packaged `.jar` files are archived from `target/*.jar` and fingerprinted for traceability.

---

## 📌 Environment Variables

| Variable             | Description                                      |
|----------------------|--------------------------------------------------|
| `AWS_REGION`         | AWS region for ECR and EKS                       |
| `ECR_REGISTRY`       | AWS ECR registry URL                             |
| `ECR_REPO`           | ECR repository path                              |
| `REPO_NAME`          | Full image path for Docker and ECR              |
| `AWS_PROXY`          | Path to AWS CLI wrapper script                   |
| `EKS_CLUSTER_NAME`   | Name of the EKS cluster                          |
| `IMAGE_TAG`          | Docker image tag (set to Jenkins build number)  |
| `SONARQUBE`          | SonarQube server name in Jenkins                 |

---

## 🧠 Author

Maintained by [Ayantika Nandi](https://github.com/ayantikanandi)  
DevOps enthusiast focused on cloud-native automation, security, and cost-aware infrastructure.

---

<img width="1365" height="676" alt="image" src="https://github.com/user-attachments/assets/7aee064f-ff3d-4125-ab9d-876eee462fd2" />


