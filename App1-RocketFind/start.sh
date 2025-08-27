#!/bin/bash

# RocketFind - Start Script
echo "Starting RocketFind (Consumer Application)..."

# Function to start backend
start_backend() {
    echo "Starting RocketFind API (Port 5000)..."
    cd backend/MortgagePlatform.API
    dotnet run &
    BACKEND_PID=$!
    echo $BACKEND_PID > ../../backend.pid
    cd ../..
}

# Function to start frontend
start_frontend() {
    echo "Starting RocketFind Frontend (Port 4200)..."
    cd frontend
    pnpm install
    pnpm start &
    FRONTEND_PID=$!
    echo $FRONTEND_PID > ../frontend.pid
    cd ..
}

# Check if database is running
if ! pg_isready -h localhost -p 5432 -U MartinGonella -d mortgage_platform 2>/dev/null; then
    echo "Warning: PostgreSQL database may not be running."
    echo "Please ensure the database is started and accessible."
fi

# Start services
start_backend
start_frontend

echo "RocketFind services starting..."
echo "API will be available at: http://localhost:5000/swagger"
echo "Frontend will be available at: http://localhost:4200"
echo "Database: postgresql://localhost:5432/mortgage_platform"

echo "To stop services, run: ./stop.sh"

# Keep script running
wait