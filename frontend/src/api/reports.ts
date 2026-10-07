import type {
  HeadcountReportResponse,
  SalaryReportResponse,
} from '../types/report'

const API_BASE_URL = 'http://localhost:3000'

export async function fetchHeadcountReport(): Promise<HeadcountReportResponse> {
  const response = await fetch(`${API_BASE_URL}/api/v1/reports/headcount`)

  if (!response.ok) {
    throw new Error('Failed to fetch headcount report')
  }

  return response.json()
}

export async function fetchSalaryReport(): Promise<SalaryReportResponse> {
  const response = await fetch(`${API_BASE_URL}/api/v1/reports/salary`)

  if (!response.ok) {
    throw new Error('Failed to fetch salary report')
  }

  return response.json()
}
