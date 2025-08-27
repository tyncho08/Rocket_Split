#!/bin/bash

# ==============================================================================
# run-apps.sh - Rocket Split Applications Manager
# ==============================================================================
# This script:
# 1. Kills all processes on required ports
# 2. Builds both applications
# 3. Runs both applications
# 4. On Ctrl+C, automatically stops everything
# ==============================================================================

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Port definitions
PORTS=(4200 4201 5000 5001)
APP1_FRONTEND_PORT=4200
APP1_BACKEND_PORT=5000
APP2_FRONTEND_PORT=4201
APP2_BACKEND_PORT=5001

# Application directories
APP1_DIR="App1-RocketFind"
APP2_DIR="App2-RocketAdmin"

# PID storage
declare -a PIDS=()

print_header() {
    echo -e "${BLUE}"
    echo "=================================================================="
    echo "  🚀 ROCKET SPLIT APPLICATIONS MANAGER"
    echo "=================================================================="
    echo -e "${NC}"
}

print_section() {
    echo -e "${YELLOW}▶ $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

# ==============================================================================
# Cleanup Function - Executed on Ctrl+C
# ==============================================================================
cleanup_and_exit() {
    echo ""
    print_section "🛑 Stopping all applications..."
    
    # Kill all background processes we started
    for pid in "${PIDS[@]}"; do
        if ps -p $pid > /dev/null 2>&1; then
            echo "Killing process PID: $pid"
            kill $pid 2>/dev/null
        fi
    done
    
    # Force kill processes on our ports
    for port in "${PORTS[@]}"; do
        pids=$(lsof -ti:$port 2>/dev/null)
        if [ -n "$pids" ]; then
            echo "Killing processes on port $port: $pids"
            echo $pids | xargs kill -9 2>/dev/null || true
        fi
    done
    
    # Clean up any remaining processes
    pkill -f "ng serve" 2>/dev/null || true
    pkill -f "dotnet run" 2>/dev/null || true
    pkill -f "MortgagePlatform.API" 2>/dev/null || true
    
    # Clean up log and pid files
    rm -f *.pid *.log 2>/dev/null || true
    
    print_success "🎉 All applications have been stopped"
    exit 0
}

# ==============================================================================
# Port Cleanup
# ==============================================================================
kill_existing_processes() {
    print_section "🧹 Cleaning existing processes..."
    
    for port in "${PORTS[@]}"; do
        echo "Checking port $port..."
        pids=$(lsof -ti:$port 2>/dev/null)
        
        if [ -n "$pids" ]; then
            echo "  Killing processes: $pids"
            echo $pids | xargs kill -9 2>/dev/null || true
            sleep 1
        fi
    done
    
    # Extra cleanup
    pkill -f "ng serve" 2>/dev/null || true
    pkill -f "dotnet run" 2>/dev/null || true
    pkill -f "MortgagePlatform.API" 2>/dev/null || true
    
    sleep 2
    print_success "Ports cleaned"
}

# ==============================================================================
# Database Check
# ==============================================================================
check_database() {
    print_section "🗄️ Checking database connection..."
    
    if pg_isready -h localhost -p 5432 -U MartinGonella -d mortgage_platform >/dev/null 2>&1; then
        print_success "PostgreSQL database accessible"
        return 0
    else
        print_error "PostgreSQL database not accessible"
        print_info "Make sure PostgreSQL is running and 'mortgage_platform' database exists"
        return 1
    fi
}

# ==============================================================================
# Build Functions
# ==============================================================================
build_backends() {
    print_section "🔨 Building backends..."
    
    # Build App1 Backend
    echo "Building App1 (RocketFind) Backend..."
    cd "$APP1_DIR/backend/MortgagePlatform.API"
    if ! dotnet build > /dev/null 2>&1; then
        print_error "App1 backend build failed"
        cd ../../..
        return 1
    fi
    cd ../../..
    print_success "App1 backend built"
    
    # Build App2 Backend
    echo "Building App2 (RocketAdmin) Backend..."
    cd "$APP2_DIR/backend/MortgagePlatform.API"
    if ! dotnet build > /dev/null 2>&1; then
        print_error "App2 backend build failed"
        cd ../../..
        return 1
    fi
    cd ../../..
    print_success "App2 backend built"
    
    return 0
}

install_frontend_deps() {
    print_section "📦 Installing frontend dependencies..."
    
    # Clean and install App1 Frontend
    echo "Cleaning and installing App1 (RocketFind) Frontend dependencies..."
    cd "$APP1_DIR/frontend"
    rm -rf node_modules pnpm-lock.yaml .angular 2>/dev/null || true
    if ! pnpm install --no-frozen-lockfile > /dev/null 2>&1; then
        print_error "App1 frontend dependencies installation failed"
        cd ../..
        return 1
    fi
    cd ../..
    print_success "App1 frontend dependencies installed"
    
    # Clean and install App2 Frontend
    echo "Cleaning and installing App2 (RocketAdmin) Frontend dependencies..."
    cd "$APP2_DIR/frontend"
    rm -rf node_modules pnpm-lock.yaml .angular 2>/dev/null || true
    if ! pnpm install --no-frozen-lockfile > /dev/null 2>&1; then
        print_error "App2 frontend dependencies installation failed"
        cd ../..
        return 1
    fi
    cd ../..
    print_success "App2 frontend dependencies installed"
    
    return 0
}

# ==============================================================================
# Start Applications
# ==============================================================================
start_applications() {
    print_section "🚀 Starting applications..."
    
    # Start App1 Backend
    echo "Starting App1 Backend on port $APP1_BACKEND_PORT..."
    cd "$APP1_DIR/backend/MortgagePlatform.API"
    dotnet run &
    APP1_BACKEND_PID=$!
    PIDS+=($APP1_BACKEND_PID)
    cd ../../..
    print_success "App1 Backend started (PID: $APP1_BACKEND_PID)"
    
    # Start App2 Backend
    echo "Starting App2 Backend on port $APP2_BACKEND_PORT..."
    cd "$APP2_DIR/backend/MortgagePlatform.API"
    dotnet run &
    APP2_BACKEND_PID=$!
    PIDS+=($APP2_BACKEND_PID)
    cd ../../..
    print_success "App2 Backend started (PID: $APP2_BACKEND_PID)"
    
    # Wait for backends to start
    echo "⏳ Waiting for backends to start..."
    sleep 10
    
    # Start App1 Frontend
    echo "Starting App1 Frontend on port $APP1_FRONTEND_PORT..."
    cd "$APP1_DIR/frontend"
    nohup pnpm start > ../../app1-frontend.log 2>&1 &
    APP1_FRONTEND_PID=$!
    PIDS+=($APP1_FRONTEND_PID)
    cd ../..
    print_success "App1 Frontend started (PID: $APP1_FRONTEND_PID)"
    
    # Start App2 Frontend
    echo "Starting App2 Frontend on port $APP2_FRONTEND_PORT..."
    cd "$APP2_DIR/frontend"
    nohup pnpm start > ../../app2-frontend.log 2>&1 &
    APP2_FRONTEND_PID=$!
    PIDS+=($APP2_FRONTEND_PID)
    cd ../..
    print_success "App2 Frontend started (PID: $APP2_FRONTEND_PID)"
    
    # Wait for frontends to compile
    echo "⏳ Waiting for frontends to compile..."
    sleep 15
}

# ==============================================================================
# Show Status
# ==============================================================================
show_status() {
    print_section "📊 Applications status"
    
    echo ""
    echo "🏠 App1 - RocketFind (Consumer Application)"
    echo "   Frontend: http://localhost:$APP1_FRONTEND_PORT"
    echo "   Backend API: http://localhost:$APP1_BACKEND_PORT/api"
    echo "   Swagger: http://localhost:$APP1_BACKEND_PORT/swagger"
    
    echo ""
    echo "🏢 App2 - RocketAdmin (Administrative Application)"
    echo "   Frontend: http://localhost:$APP2_FRONTEND_PORT"
    echo "   Backend API: http://localhost:$APP2_BACKEND_PORT/api"
    echo "   Swagger: http://localhost:$APP2_BACKEND_PORT/swagger"
    
    echo ""
    echo "🗄️  Database"
    echo "   PostgreSQL: postgresql://MartinGonella@localhost:5432/mortgage_platform"
    
    echo ""
    echo "👥 Test accounts"
    echo "   Consumer: john.doe@email.com / user123"
    echo "   Admin: admin@mortgageplatform.com / admin123"
    
    echo ""
    print_success "🎉 Both applications are running!"
    print_info "Press Ctrl+C to stop all applications"
}

# ==============================================================================
# Main Execution
# ==============================================================================
main() {
    print_header
    
    # Set trap for cleanup on Ctrl+C
    trap cleanup_and_exit SIGINT SIGTERM
    
    # Step 1: Kill existing processes
    kill_existing_processes
    
    # Step 2: Check database
    if ! check_database; then
        print_error "Check database connection before continuing"
        exit 1
    fi
    
    # Step 3: Build backends
    if ! build_backends; then
        print_error "Backend build failed"
        exit 1
    fi
    
    # Step 4: Install frontend dependencies
    if ! install_frontend_deps; then
        print_error "Frontend dependencies installation failed"
        exit 1
    fi
    
    # Step 5: Start applications
    start_applications
    
    # Step 6: Show status
    show_status
    
    # Keep script running until Ctrl+C
    while true; do
        sleep 1
    done
}

# ==============================================================================
# Entry Point
# ==============================================================================

# Check required commands
for cmd in dotnet pnpm lsof pg_isready; do
    if ! command -v $cmd >/dev/null 2>&1; then
        print_error "Required command '$cmd' is not installed"
        exit 1
    fi
done

# Run main function
main "$@"