# HookDebug

Webhook testing and API debugging tool.

## Stack
- Rails 8.1 with Action Cable for real-time updates
- PostgreSQL 17
- Tailwind CSS (via tailwindcss-rails)
- Ruby 4.0.1

## Architecture
- `WebController < ActionController::Base` — all web-facing controllers inherit from this
- `WebhooksController < ActionController::API` — fast webhook receiver, no middleware overhead
- Action Cable `EndpointChannel` for real-time request streaming
- No Turbo/UJS — plain HTML + vanilla JS + Action Cable

## Key Models
- `Endpoint` — has a unique token, configurable response, optional user
- `WebhookRequest` — captures method, headers, body, query params, IP
- `User` — has_secure_password, plan (free/pro)
- `TeamMember` — join table for sharing endpoints

## Routes
- `GET /` — landing page
- `POST /endpoints` — create new endpoint
- `GET /e/:token` — endpoint dashboard (real-time)
- `ALL /webhook/:token` — webhook receiver (any HTTP method)
- `POST /replay` — replay a captured request

## Development
```bash
bin/rails server
# or
bin/dev
```

## Deployment
Configured for Fly.io CDG region. Don't deploy yet.
