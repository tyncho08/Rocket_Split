# LendPro Platform - Split Application Demo

This repository demonstrates a comprehensive **application split strategy** for the LendPro Mortgage Platform, dividing a monolithic application into two independent, specialized applications for AI merge demonstration purposes.

## 📋 Overview

The original LendPro Mortgage Platform has been strategically split into:

- **App1-RocketFind**: Consumer-facing mortgage and property search application
- **App2-RocketAdmin**: Administrative loan management and user oversight system

Both applications share the same database and authentication system while maintaining completely independent codebases and deployment configurations.

## 🏗️ Architecture

### Shared Infrastructure
- **Database**: PostgreSQL (`mortgage_platform`)
- **Authentication**: JWT-based with shared user store
- **Tech Stack**: .NET Core 3.1 + Angular 19.2
- **Styling**: Identical visual design and user experience

### Application Ports
- **App1 Frontend**: http://localhost:4200
- **App1 Backend**: http://localhost:5000
- **App2 Frontend**: http://localhost:4201  
- **App2 Backend**: http://localhost:5001

## 🚀 Quick Start

### Prerequisites
- Node.js 18+ and pnpm
- .NET Core 3.1 SDK
- PostgreSQL 13+

### Running Both Applications
```bash
# Make executable and run
chmod +x run-apps.sh
./run-apps.sh
```

This script will:
1. Install all dependencies for both applications
2. Build frontend and backend projects
3. Start all services in parallel
4. Clean up processes on Ctrl+C

### Individual Application Setup

#### App1-RocketFind (Consumer)
```bash
# Frontend
cd App1-RocketFind/frontend
pnpm install && pnpm start

# Backend  
cd App1-RocketFind/backend/MortgagePlatform.API
dotnet restore && dotnet run --urls="http://localhost:5000"
```

#### App2-RocketAdmin (Admin)
```bash
# Frontend
cd App2-RocketAdmin/frontend
pnpm install && pnpm start

# Backend
cd App2-RocketAdmin/backend/MortgagePlatform.API  
dotnet restore && dotnet run --urls="http://localhost:5001"
```

## 🎯 App1-RocketFind (Consumer Application)

### Purpose
Consumer-facing application for home buyers and mortgage seekers.

### Key Features
- **Property Search**: Advanced filtering, favorites, detailed listings
- **Mortgage Tools**: Payment calculator, refinance calculator, rent vs buy analysis
- **Market Analysis**: Price trends, neighborhood insights, historical data
- **User Dashboard**: Personal loan applications, document uploads, progress tracking
- **Loan Application**: Complete mortgage application workflow

### User Access
- **Regular Users**: `john.doe@email.com` / `user123`
- **Open Features**: Property search, mortgage calculators, market trends
- **Protected Features**: Dashboard, loan applications, property comparison (require login)

### Navigation
- Home Search
- Mortgage Tools  
- Dashboard (authenticated)
- Login/Logout

## 🛠️ App2-RocketAdmin (Administrative Application)

### Purpose
Administrative interface for loan officers and system administrators.

### Key Features
- **Loan Management**: Review applications, approve/reject loans, status updates
- **User Management**: View user accounts, manage permissions, account oversight
- **Document Review**: Process uploaded documents, verification workflows
- **System Administration**: Platform oversight and configuration

### User Access
- **Admin Users**: `admin@mortgageplatform.com` / `admin123`
- **All Features Require**: Administrator role and authentication

### Navigation
- Admin Dashboard
- Loan Management
- User Management
- Login/Logout

## 🔧 Technical Implementation

### Split Strategy: User Type & Business Domain
The application was divided based on:
1. **User personas** (consumers vs administrators)
2. **Business domains** (customer-facing vs internal operations)
3. **Security boundaries** (public vs restricted access)

### Backend Split
#### App1 API Endpoints
- `GET/POST /api/properties` - Property listings and search
- `POST /api/loans` - Create loan applications  
- `GET /api/loans/my` - User's loan applications
- `POST /api/mortgage/calculate` - Mortgage calculations

#### App2 API Endpoints  
- `GET /api/loans` - All loan applications (admin only)
- `PUT /api/loans/{id}/status` - Update loan status (admin only)
- `GET /api/users` - User management (admin only)
- Admin-specific controllers with `[Authorize(Roles = "Admin")]`

### Frontend Split
#### App1 Modules
- `home-search/` - Property search and listings
- `mortgage-tools/` - Calculators and analysis tools
- `dashboard/` - User personal dashboard
- `loan-application/` - Application forms
- `market-trends/` - Market analysis
- `comparison/` - Property comparison

#### App2 Modules
- `admin/` - Administrative dashboard
- `loan-management/` - Loan review and approval
- `user-management/` - User account oversight
- Shared `auth/` and `shared/` components

### Database Schema
Both applications use the same PostgreSQL database with tables:
- `Users` - Shared user accounts with role-based access
- `Properties` - Property listings (App1 focused)
- `LoanApplications` - Mortgage applications (both apps)
- `Documents` - File uploads and verification
- `FavoriteProperties` - User-specific favorites (App1)

## 🔐 Authentication & Security

### Shared JWT Authentication
- Single user store with role-based authorization
- Tokens valid across both applications  
- Role enforcement at API and route level

### Security Model
- **App1**: Open property search, authenticated personal features
- **App2**: Full admin authentication required for all features
- Cross-origin resource sharing (CORS) configured per application

### Route Protection
- **App1**: AuthGuard for dashboard, loan applications, comparisons
- **App2**: AdminGuard for all administrative routes

## 🎨 Design Consistency

Both applications maintain **identical visual design**:
- Same CSS variables and color schemes
- Identical header, navigation, and footer layouts
- Consistent component styling and interactions
- Unified user experience across platforms

## 📊 Monitoring & Development

### Development Tools
- **Swagger UI**: API documentation at `/swagger` endpoints
- **Hot Reload**: Angular dev servers with live updates
- **Database Access**: DBeaver connection to PostgreSQL
- **Logging**: Console logging for debugging

### Testing Accounts
```
Regular User:
- Email: john.doe@email.com
- Password: user123

Administrator:  
- Email: admin@mortgageplatform.com
- Password: admin123
```

## 🚢 Deployment Considerations

### Independent Deployment
Each application can be:
- Built and deployed independently
- Scaled separately based on usage patterns
- Updated without affecting the other application
- Monitored with separate metrics and logging

### Shared Dependencies
- Database migrations coordinated between applications
- Authentication service changes affect both systems
- Shared model changes require synchronized updates

## 🔄 AI Merge Demonstration

This split architecture enables demonstration of:
- **Independent Development**: Teams working on separate applications
- **Merge Conflicts**: Overlapping changes in shared components
- **Integration Challenges**: Coordinating database and API changes
- **Deployment Strategies**: Rolling updates and feature toggles

The separation provides a realistic scenario for testing AI-powered code merging tools and strategies.

## 📝 Development Notes

### Common Tasks
1. **Adding Features**: Implement in appropriate application based on user type
2. **Database Changes**: Update both applications' models synchronously  
3. **Authentication Updates**: Test across both login systems
4. **UI Changes**: Maintain design consistency between applications

### File Structure
```
├── App1-RocketFind/           # Consumer application
│   ├── frontend/              # Angular 19.2 consumer UI
│   ├── backend/               # .NET Core API (consumer endpoints)
│   └── database/              # Shared database scripts
├── App2-RocketAdmin/          # Admin application  
│   ├── frontend/              # Angular 19.2 admin UI
│   ├── backend/               # .NET Core API (admin endpoints)
│   └── database/              # Shared database scripts
├── run-apps.sh               # Unified startup script
└── README.md                 # This documentation
```

## 🤝 Contributing

When contributing to either application:
1. Maintain the separation of concerns between consumer and admin features
2. Update both applications for shared model or authentication changes
3. Test cross-application functionality with shared database
4. Preserve identical visual design across both applications
5. Update documentation for new features or changes

---

**Created for AI merge demonstration purposes** - This split architecture showcases real-world application separation strategies while maintaining shared infrastructure and consistent user experience.