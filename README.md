# 🔐 OAuth IDP App

A Ruby on Rails OAuth 2.0 Identity Provider (IDP) implementation built with **Doorkeeper**, **Devise**, and **JWT**, featuring:

- ✅ Authorization Code + PKCE
- 🗝️ Client Credentials for machine‑to‑machine authentication
- 🛡️ JWT access tokens (HS256 or RS256)
- 💠 JWKS & OpenID Connect discovery (`/.well-known` endpoint)
- 🛠️ Admin UI for managing OAuth applications
- 🧪 Token validation endpoint for testing and debugging

---

## 🧭 Features

### 🔑 Authentication Flows
- **User login & consent** using Devise + Doorkeeper
- **Machine‑to‑Machine** tokens via client credentials

### 🧰 Token Handling
- JWT access tokens with easy switching between **HS256** and **RS256**
- JWKS endpoint (`/oauth/jwks`) exposes public keys
- OIDC discovery support at `/.well-known/openid-configuration`

### 🔧 Admin Interface
- Create/edit OAuth applications with:
  - Client ID / secret (auto‑generated or customizable)
  - Redirect URIs, scopes, confidentiality
- Copy or regenerate client secrets securely
- Admin dashboard built with Bootstrap 5

### 🧪 Developer Tools
- `/token/validate` endpoint to verify JWT tokens quickly
- Configurable skip-consent logic, token reuse, and scope management

---

## 🚀 Getting Started

### 1. Clone & Setup

```bash
git clone https://github.com/lalitlogical/oauth-idp-app.git
cd oauth-idp-app
bundle install
```

### 2. Generate Keys (for RS256)

```bash
mkdir -p config/keys
openssl genrsa -out config/keys/private.pem 2048
openssl rsa -in config/keys/private.pem -pubout -out config/keys/public.pem
```

> 🔒 Keep private.pem secure (e.g. .gitignore)

### 3. Set Environment Variables

```bash
export IDP_HOST="http://localhost:3000"
```

### 4. Setup Database & Migrate

```bash
rails db:create db:migrate
```

### 5. Start the App

```bash
rails server
```

## 🔍 Key Endpoints

| Method | Endpoint                                     | Description                              |
|--------|----------------------------------------------|------------------------------------------|
| GET    | `/oauth/authorize`                           | Start OAuth authorization flow           |
| POST   | `/oauth/token`                               | Exchange grant for JWT access token      |
| GET    | `/.well-known/openid-configuration`          | OpenID Connect discovery metadata        |
| GET    | `/oauth/jwks`                                | JWKS endpoint exposing public keys       |
| GET    | `/token/validate`                            | Debug and verify JWT access tokens       |
| GET    | `/admin/applications`                        | Admin UI for managing OAuth applications |
| POST   | `/admin/applications`                        | Create a new OAuth application           |
| PATCH  | `/admin/applications/:id`                    | Update an existing OAuth application     |
| DELETE | `/admin/applications/:id`                    | Delete an OAuth application              |

## ⚙️ Configuration

- `config/initializers/doorkeeper.rb`: core auth flow and token settings
- `config/initializers/configure_jwt_keys.rb`: loads and configures RSA keypair
- `/app/controllers/admin/applications_controller.rb`: admin-side app management

## 🛡️ Advanced Use

- Customize skip_authorization rules per client/scope
- Use .reuse_access_token to prevent duplicate token generation
- Integrate with M2M services via JWT validation & scopes

## 📄 License

MIT License — feel free to use and modify!

## 🪄 Contributing

Pull requests and feature suggestions welcome!
Just fork the repo and start innovating 🎉