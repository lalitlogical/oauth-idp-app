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

## 🔐 Regenerating Local HTTPS Certificates with mkcert

This project uses self-signed HTTPS certificates for local development domains like `accounts.lalit.local` and `client.lalit.local`. These certificates are generated using [`mkcert`](https://github.com/FiloSottile/mkcert) and stored in the `helm/tls-secret/certs/` directory, which is **excluded from version control**.

> ⚠️ These certs must be regenerated manually on each new machine and **should never be committed** to Git.

---

### 📦 Step 1: Install `mkcert`

#### macOS

```bash
brew install mkcert
mkcert -install
```
#### Ubuntu/Linux

```bash
sudo apt install libnss3-tools
brew install mkcert  # Or use prebuilt binaries from the mkcert GitHub releases
mkcert -install
```

### 🔧 Step 2: Generate Certificates for Required Domains

```bash
mkcert accounts.lalit.local client.lalit.local
```

This will generate:

- `accounts.lalit.local+1.pem`
- `accounts.lalit.local+1-key.pem`

Rename and move them to the `helm/tls-secret/certs/` folder:

```bash
mkdir -p helm/tls-secret/certs

mv accounts.lalit.local+1.pem helm/tls-secret/certs/lalit.local.crt
mv accounts.lalit.local+1-key.pem helm/tls-secret/certs/lalit.local.key
```

### 🛡 Step 3: Helm-Managed TLS Secret

This project uses a Helm chart (`tls-secret`) to automatically create the Kubernetes TLS secret named `lalit-local-tls`.

Once you’ve generated the certs using `mkcert` and placed them in `helm/tls-secret/certs/`, **no manual `kubectl create secret` command is required**.

The `Secret` is defined like this in the `tls-secret` chart:

```yaml
# helm/tls-secret/templates/secret.yaml
apiVersion: v1
kind: Secret
metadata:
  name: lalit-local-tls
type: kubernetes.io/tls
data:
  tls.crt: {{ .Files.Get "certs/lalit.local.crt" | b64enc }}
  tls.key: {{ .Files.Get "certs/lalit.local.key" | b64enc }}
```

### 🌍 Step 4: Update Local /etc/hosts File

Edit your `/etc/hosts` to map domains to `127.0.0.1`:

```lua
127.0.0.1 accounts.lalit.local
127.0.0.1 client.lalit.local
```

## 📄 License

MIT License — feel free to use and modify!

## 🪄 Contributing

Pull requests and feature suggestions welcome!
Just fork the repo and start innovating 🎉