import type { Employee, EmployeeListResponse } from '../types/employee'

const API_BASE_URL = 'http://localhost:3000'

export async function fetchEmployees(
  page = 1,
  perPage = 25,
): Promise<EmployeeListResponse> {
  const response = await fetch(
    `${API_BASE_URL}/api/v1/employees?page=${page}&per_page=${perPage}`,
  )

  if (!response.ok) {
    throw new Error('Failed to fetch employees')
  }

  return response.json()
}

export async function fetchEmployee(id: number): Promise<Employee> {
  const response = await fetch(`${API_BASE_URL}/api/v1/employees/${id}`)

  if (!response.ok) {
    throw new Error('Failed to fetch employee')
  }

  return response.json()
}
