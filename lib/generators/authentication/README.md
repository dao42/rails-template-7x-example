# Authentication Generator

This is a Rails generator that creates a complete user authentication system. Built on modern Rails 7+ features, it provides a secure and flexible authentication solution.

## Features

- ✅ User registration and login
- ✅ Session management (multi-device support)
- ✅ Password management (change password)
- ✅ Email verification (optional)
- ✅ Password reset (optional)
- ✅ OAuth integration (optional)
- ✅ User invitation system
- ✅ Modern UI (DaisyUI + Tailwind CSS)
- ✅ Email templates
- ✅ Security best practices

## Usage

### Basic Usage

```bash
# Generate complete authentication system
bin/rails generate authentication
```

### Notes

This generator creates a complete authentication system with all features. If you don't need certain features (like OAuth, email verification, etc.), you can manually remove the corresponding files after generation.

## Post-Generation Steps

1. **Run database migrations**
   ```bash
   rails db:migrate
   ```

2. **Add required gems**
   Ensure your Gemfile includes:
   ```ruby
   gem 'bcrypt', '~> 3.1.7'
   # If using OAuth
   gem 'omniauth'
   gem 'omniauth-rails_csrf_protection'
   ```

3. **Configure mail settings**
   Configure mail settings in `config/environments/development.rb` and `config/environments/production.rb`.

4. **Configure OAuth (if needed)**
   Edit `config/initializers/omniauth.rb` file and add your OAuth provider configurations.

5. **Customize styles**
   Adjust view files as needed to match your application design.

## Generated File Structure

```
app/
├── controllers/
│   ├── application_controller.rb (authentication methods inserted)
│   ├── sessions_controller.rb
│   ├── registrations_controller.rb
│   ├── passwords_controller.rb
│   ├── invitations_controller.rb
│   ├── identity/
│   │   ├── emails_controller.rb
│   │   ├── email_verifications_controller.rb
│   │   └── password_resets_controller.rb
│   └── sessions/
│       └── omniauth_controller.rb
├── models/
│   ├── user.rb
│   ├── session.rb
│   └── current.rb
├── views/
│   ├── sessions/
│   ├── registrations/
│   ├── passwords/
│   ├── invitations/
│   ├── identity/
│   └── user_mailer/
└── mailers/
    └── user_mailer.rb

config/
├── initializers/
│   └── omniauth.rb
└── routes.rb (modified)

db/migrate/
├── create_users.rb
└── create_sessions.rb
```

## Routes

The generator automatically adds the following routes:

```ruby
# Basic authentication
get  "sign_in", to: "sessions#new"
post "sign_in", to: "sessions#create"
get  "sign_up", to: "registrations#new" 
post "sign_up", to: "registrations#create"
resource :session, only: [:new, :show] do
  get :devices, on: :member
  delete :destroy_one, on: :member
end
resource  :password, only: [:edit, :update]

# Identity management
namespace :identity do
  resource :email, only: [:edit, :update]
  resource :email_verification, only: [:show, :create]
  resource :password_reset, only: [:new, :edit, :create, :update]
end

# OAuth
get  "/auth/failure", to: "sessions/omniauth#failure"
get  "/auth/:provider/callback", to: "sessions/omniauth#create"
post "/auth/:provider/callback", to: "sessions/omniauth#create"

# Invitations
resource :invitation, only: [:new, :create]
```

## Security Features

- Uses `has_secure_password` for password hashing
- Session tokens stored in HttpOnly cookies
- Password reset tokens have time limits (20 minutes)
- Email verification tokens have time limits (2 days)
- Automatically clears other sessions when user changes password
- CSRF protection
- Modern browser support checking

## Customization

### Modify minimum password length

Modify the `MIN_PASSWORD` constant in the generated `User` model:

```ruby
class User < ApplicationRecord
  MIN_PASSWORD = 8 # Change to your desired length
  # ...
end
```

### Add user fields

You can create migrations to add additional user fields:

```bash
rails generate migration AddFieldsToUsers name:string avatar:attachment
```

### Customize views

All generated views use DaisyUI components, and you can modify the styles as needed.

## License

This generator follows the same MIT license as Rails.
