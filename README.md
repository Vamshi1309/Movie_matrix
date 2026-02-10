# 🎬 Movie Matrix – Backend

Backend service for **Movie Matrix**, built using **Spring Boot**, providing secure authentication, movie data APIs, and user management features.  
This service powers the **Flutter frontend** and focuses on **clean architecture, security, and scalability**.

---

## 🚀 Features

- 🔐 JWT-based authentication  
- 🔁 Forgot & reset password flow using OTP  
- 📧 Email delivery using **SendGrid**  
- 🎞️ APIs for fetching movies by **categories**  
- 🔍 Search suggestions for movie searches  
- 📄 Pagination for efficient data handling  
- 👤 User profile management  
- 🧱 Layered architecture (**Controller, Service, Repository, DTO, Entity**)  
- ⚠️ Global exception handling  
- 🔗 Secure request handling using **Spring Security filter chain**  
- 🌍 Deployed on **Render**

---

## 🧩 Architecture Overview

This project follows a **clean layered architecture**:

- **Controller** – Handles API requests and responses  
- **Service** – Contains business logic  
- **Repository** – Database interactions using JPA  
- **DTOs** – Request/response abstraction  
- **Entities** – Database models  
- **Global Exception Handler** – Centralized error handling  
- **Security Filter Chain** – JWT validation and request filtering  

---

## 🛠 Tech Stack

- **Spring Boot** – Application framework  
- **Spring Security** – Authentication & authorization  
- **JWT (JSON Web Tokens)** – Stateless authentication  
- **Spring Data JPA / Hibernate** – ORM & database access  
- **PostgreSQL** – Relational database  
- **SendGrid API** – Email service for OTP delivery  
- **Maven** – Dependency management  
- **Render** – Cloud deployment platform  

---

## 🔐 Authentication & Security

- JWT tokens used for secure API access  
- Custom **Spring Security filter chain** for request validation  
- Token validation on protected endpoints  
- Stateless authentication design  

---

## 📧 Email Integration

- Implemented OTP-based email flow for password reset  
- Uses **SendGrid API** (instead of SMTP) to avoid cloud SMTP restrictions  
- Production-safe and scalable email delivery  

---

## 📄 Pagination Support

- Pagination implemented at API level  
- Improves performance and scalability for large datasets  
- Used in movie listings and search results  

---

## 🗄 Database

- **PostgreSQL** used as the primary database  
- Environment-based configuration  
- JPA entities mapped cleanly to relational tables  

---

## 🌍 Deployment

- Deployed on **Render**  
- Environment variables used for:
  - Database credentials  
  - JWT secret  
  - SendGrid API key  
- No secrets are hardcoded in the codebase  

---

## ⚙️ Environment Variables

```env
DATABASE_URL=
SPRING_DATASOURCE_USERNAME=
SPRING_DATASOURCE_PASSWORD=
JWT_SECRET=
SENDGRID_API_KEY=
```

## ▶️ Run Locally

1. **Clone the repository**
```bash
git clone https://github.com/<your-username>/<your-backend-repo>.git
cd <your-backend-repo>
```
2. **Run the application**
```bash
./mvnw spring-boot:run
```
Make sure PostgreSQL is running and required environment variables are configured.

## 📌 Notes

This backend is designed to work with a Flutter frontend

Focused on learning real-world backend concepts like security, architecture, and deployment

Built as a foundation for future enhancements and scalability
