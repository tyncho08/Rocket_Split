# RocketAdmin - Loan Management System

Administrative application for loan processing, user management, and business analytics.

## Architecture

- **Backend**: .NET Core 3.1 API (Port 5001)
- **Frontend**: Angular 19.2 (Port 4201)
- **Database**: PostgreSQL (Shared with RocketFind)

## Features

### Administrative Features
- Admin dashboard with metrics
- Loan application management and approval
- Individual loan review and processing
- User management and role assignments
- Business analytics and reporting
- Loan status updates

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

- Frontend: http://localhost:4201
- API: http://localhost:5001/api
- Swagger: http://localhost:5001/swagger

## Test Accounts

- Admin User: admin@mortgageplatform.com / admin123

## Database

Shares the same PostgreSQL database (`mortgage_platform`) with RocketFind.
Connection: `Host=localhost;Database=mortgage_platform;Username=MartinGonella;Password=`

## API Endpoints

- **Auth**: `/api/auth` - Admin authentication
- **Admin**: `/api/admin` - Dashboard metrics, user management
- **Loans**: `/api/loans` - All loan applications management (admin only)