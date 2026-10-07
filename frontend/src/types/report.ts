export type HeadcountReport = {
  country: string
  department: string
  employee_count: number
}

export type SalaryReport = {
  country: string
  department: string
  currency: string
  employee_count: number
  average_salary: string
  minimum_salary: string
  maximum_salary: string
}

export type HeadcountReportResponse = {
  reports: HeadcountReport[]
}

export type SalaryReportResponse = {
  reports: SalaryReport[]
}
