# RocketFind - Property Search & Mortgage Tools

Consumer application for property search, mortgage calculations, and loan applications.

## Architecture

- **Backend**: .NET Core 3.1 API (Port 5000)
- **Frontend**: Angular 19.2 (Port 4200) 
- **Database**: PostgreSQL (Shared with RocketAdmin)

## Features

### Consumer Features
- Property search and filtering
- Property details and favorites
- Mortgage calculators (payment, refinance, rent vs buy, extra payments)
- Market trends and price history charts
- Property comparison tools
- Personal loan applications
- User dashboard
- Mortgage pre-approval

## Quick Start

```bash
# Start the application
./start.sh

# Stop the application
./stop.sh
```

## Manual Start

```bash
# Backend
cd backend/MortgagePlatform.API
dotnet run

# Frontend (in another terminal)
cd frontend
pnpm install
pnpm start
```

## Access URLs

- Frontend: http://localhost:4200
- API: http://localhost:5000/api
- Swagger: http://localhost:5000/swagger

## Test Accounts

- Regular User: john.doe@email.com / user123

## Database

Shares the same PostgreSQL database (`mortgage_platform`) with RocketAdmin.
Connection: `Host=localhost;Database=mortgage_platform;Username=MartinGonella;Password=`

## API Endpoints

- **Auth**: `/api/auth` - Authentication
- **Properties**: `/api/properties` - Property search and favorites  
- **Mortgage**: `/api/mortgage` - Calculations and pre-approval
- **Loans**: `/api/loans` - Personal loan applications (create, view own)