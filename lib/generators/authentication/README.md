# Authentication Generator

这是一个 Rails generator，用于生成完整的用户认证系统。它基于现代 Rails 7+ 特性构建，提供了安全、灵活的认证解决方案。

## 特性

- ✅ 用户注册和登录
- ✅ 会话管理（支持多设备）
- ✅ 密码管理（修改密码）
- ✅ 邮箱验证（可选）
- ✅ 密码重置（可选）
- ✅ OAuth 集成（可选）
- ✅ 用户邀请系统
- ✅ 现代化 UI（DaisyUI + Tailwind CSS）
- ✅ 邮件模板
- ✅ 安全最佳实践

## 使用方法

### 基本用法

```bash
# 生成完整的认证系统
bin/rails generate authentication
```

### 注意事项

此 generator 会生成完整的认证系统，包括所有功能。如果你不需要某些功能（如 OAuth、邮箱验证等），可以在生成后手动删除相应的文件。

## 生成后的步骤

1. **运行数据库迁移**
   ```bash
   rails db:migrate
   ```

2. **添加必要的 Gem**
   确保 Gemfile 中包含：
   ```ruby
   gem 'bcrypt', '~> 3.1.7'
   # 如果使用 OAuth
   gem 'omniauth'
   gem 'omniauth-rails_csrf_protection'
   ```

3. **配置邮件设置**
   在 `config/environments/development.rb` 和 `config/environments/production.rb` 中配置邮件设置。

4. **配置 OAuth（如果需要）**
   编辑 `config/initializers/omniauth.rb` 文件，添加你的 OAuth 提供商配置。

5. **自定义样式**
   根据需要调整视图文件以匹配你的应用设计。

## 生成的文件结构

```
app/
├── controllers/
│   ├── application_controller.rb (插入认证方法)
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
└── routes.rb (修改)

db/migrate/
├── create_users.rb
└── create_sessions.rb
```

## 路由

生成器会自动添加以下路由：

```ruby
# 基本认证
get  "sign_in", to: "sessions#new"
post "sign_in", to: "sessions#create"
get  "sign_up", to: "registrations#new" 
post "sign_up", to: "registrations#create"
resources :sessions, only: [:index, :show, :destroy]
resource  :password, only: [:edit, :update]

# 身份管理
namespace :identity do
  resource :email, only: [:edit, :update]
  resource :email_verification, only: [:show, :create]
  resource :password_reset, only: [:new, :edit, :create, :update]
end

# OAuth
get  "/auth/failure", to: "sessions/omniauth#failure"
get  "/auth/:provider/callback", to: "sessions/omniauth#create"
post "/auth/:provider/callback", to: "sessions/omniauth#create"

# 邀请
resource :invitation, only: [:new, :create]
```

## 安全特性

- 使用 `has_secure_password` 进行密码哈希
- 会话令牌存储在 HttpOnly cookies 中
- 密码重置令牌有时间限制（20分钟）
- 邮箱验证令牌有时间限制（2天）
- 自动清理已更改密码用户的其他会话
- CSRF 保护
- 现代浏览器支持检查

## 自定义

### 修改密码最小长度

在生成的 `User` 模型中修改 `MIN_PASSWORD` 常量：

```ruby
class User < ApplicationRecord
  MIN_PASSWORD = 8 # 改为你需要的长度
  # ...
end
```

### 添加用户字段

你可以创建迁移来添加额外的用户字段：

```bash
rails generate migration AddFieldsToUsers name:string avatar:attachment
```

### 自定义视图

所有生成的视图都使用 DaisyUI 组件，你可以根据需要修改样式。

## 许可证

此 generator 遵循与 Rails 相同的 MIT 许可证。
