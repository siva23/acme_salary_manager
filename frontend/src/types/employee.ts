export type Employee = {
  id: number
  employee_number: string
  first_name: string
  last_name: string
  email: string
  job_title: string
  employment_status: 'active' | 'inactive' | 'terminated'
  joining_date: string
  country: {
    id: number
    name: string
    iso_code: string
  }
  department: {
    id: number
    name: string
  }
  job_level: {
    id: number
    name: string
  }
}

export type EmployeeListResponse = {
  employees: Employee[]
  pagination: {
    page: number
    per_page: number
    total: number
    total_pages: number
  }
}
