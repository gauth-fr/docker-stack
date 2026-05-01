# Multiple Environment Files Feature

## Overview

The `stack` script automatically loads multiple `.env*` files from each stack directory, allowing you to organize environment variables by purpose (e.g., `.env.local`, `.env.prod`, `.env.secrets`).

## Loading Order

Files are loaded in this order (later files override earlier ones):

1. `.env` (symlink to parent) - Base configuration
2. `.env*` files in alphabetical order - Specific overrides

Example: `.env` → `.env.local` → `.env.prod` → `.env.secrets`

## Directory Structure

```
myapp/
├── .env -> ../.env          # Base (loaded first)
├── .env.local               # Development overrides
├── .env.prod                # Production settings
├── .env.secrets             # Sensitive data (gitignored)
└── docker-compose.yaml
```

## Common Use Cases

### Secrets Management
```bash
# .env - Public config (committed)
DATABASE_HOST=db.example.com
DATABASE_PORT=5432

# .env.secrets - Sensitive (gitignored)
DATABASE_PASSWORD=secret123
API_KEY=xyz789
```

### Environment-Specific Config
```bash
# .env - Base
DEBUG=false
LOG_LEVEL=info

# .env.local - Development
DEBUG=true
LOG_LEVEL=debug
```

## Best Practices

**Naming Convention:**
- `.env` - Base configuration
- `.env.local` - Local development
- `.env.prod` - Production
- `.env.secrets` - Sensitive credentials

**Git Management:**
```gitignore
.env.secrets
.env.local
.env.*.local
```
