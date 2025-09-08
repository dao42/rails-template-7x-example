# Neo Bookstore Setup Guide

## Overview
A Neo-Brutalism styled online bookstore built with Rails 7.2 and Stripe payments. No user authentication required - customers can purchase books directly with just their name and email.

## Features
- ✅ Neo-Brutalism design with bold colors and thick borders
- ✅ Book catalog with search and filtering
- ✅ Stripe payment integration
- ✅ No user registration required
- ✅ Admin panel integration
- ✅ Mobile responsive design
- ✅ Kaminari pagination with custom styling

## Quick Start

### 1. Stripe Configuration
1. Create a Stripe account at [stripe.com](https://stripe.com)
2. Get your API keys from [Dashboard > API keys](https://dashboard.stripe.com/apikeys)
3. Copy `config/application.yml.example` to `config/application.yml`
4. Add your Stripe credentials:

```yaml
STRIPE_PUBLISHABLE_KEY: 'pk_test_...'
STRIPE_SECRET_KEY: 'sk_test_...'
STRIPE_WEBHOOK_SECRET: 'whsec_...'  # Optional for webhooks
```

### 2. Database Setup
```bash
rails db:migrate
rails db:seed  # Creates 12 sample books
```

### 3. Start the Server
```bash
bin/dev  # Recommended - handles CSS/JS compilation
# OR
rails server
```

### 4. Access the Application
- **Bookstore**: http://localhost:3000
- **Admin Panel**: http://localhost:3000/admin

## Stripe Webhook Setup (Optional)
1. Install Stripe CLI: https://stripe.com/docs/stripe-cli
2. Forward events to your local server:
   ```bash
   stripe listen --forward-to localhost:3000/payments/webhook
   ```
3. Add the webhook secret to your `application.yml`

## Testing Payments
Use Stripe test cards:
- **Success**: 4242 4242 4242 4242
- **Decline**: 4000 0000 0000 0002
- Use any future expiry date and any CVC

## File Structure
```
app/
├── controllers/
│   ├── books_controller.rb      # Book listing and details
│   └── payments_controller.rb   # Stripe payment handling
├── models/
│   ├── book.rb                  # Book model with validation
│   └── order.rb                 # Order tracking
└── views/
    ├── books/                   # Book catalog views
    └── payments/                # Payment success/cancel pages
```

## Customization
- **Colors**: Modify CSS variables in `app/assets/stylesheets/application.css`
- **Books**: Add more books via `db/seeds.rb` or admin panel
- **Styling**: All Neo-Brutalism classes start with `neo-`

## Deployment Notes
- Set environment variables for Stripe keys
- Configure webhook endpoint: `yourapp.com/payments/webhook`
- Ensure HTTPS for production Stripe integration

## Support
- Check the admin panel for order management
- Logs are available in `log/development.log`
- Payment logs in Stripe Dashboard
