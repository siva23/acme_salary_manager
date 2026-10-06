# ACME HR Salary Management System

A salary management system for ACME HR to manage employee information, compensation history, and HR reporting.

The application is built as a separate React frontend backed by a Rails API and PostgreSQL database.

## Tech Stack

### Backend
- Ruby 4.0.5
- Rails 8.1.4
- PostgreSQL 18
- REST API
- Minitest

### Frontend
- React
- TypeScript
- Vite
- React Router
- Native Fetch API
- CSS

## Architecture

The application follows a modular monolith architecture:

```text
React + TypeScript SPA
        |
        | REST API
        v
Rails API
        |
        v
PostgreSQL

The frontend and backend are maintained in the same repository but remain independently structured.

acme_salary_manager/
├── app/
│   ├── controllers/
│   ├── models/
│   └── services/
├── config/
├── db/
├── test/
└── frontend/
    ├── src/
    ├── public/
    └── package.json


## Core Features
- Employee listing
- Employee details
- Pagination
- Employee status
- Department, country, and job-level information

## Compensation Management
- Annual base salary
- Currency
- Effective dates
- Compensation history
- Prevention of overlapping compensation periods

## Reporting
- Salary statistics
- Headcount reports
- Country-wise and department-wise reporting
- Salary statistics grouped by currency to avoid invalid cross-currency comparisons
- Dashboard


## Getting Started
# Prerequisites

## Make sure the following are installed:

Ruby 4.0.5
Rails 8.1.4
PostgreSQL 18
Node.js
npm

## Backend Setup

From the project root:
bundle install
bin/rails db:create
bin/rails db:migrate
bin/rails db:seed
The default seed creates 100 employees.

##To generate a larger dataset:
EMPLOYEE_COUNT=10000 bin/rails db:seed

## Start the Rails API
bin/rails server

# The API will be available at:
http://localhost:3000

## Frontend Setup

Open another terminal:

cd frontend
npm install
npm run dev

# The frontend will be available at:

http://localhost:5173