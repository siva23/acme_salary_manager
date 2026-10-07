import { useEffect, useMemo, useState } from 'react'
import {
  Bar,
  BarChart,
  CartesianGrid,
  ResponsiveContainer,
  Tooltip,
  XAxis,
  YAxis,
} from 'recharts'
import { fetchSalaryReport } from '../api/reports'
import type { SalaryReport } from '../types/report'

type SalaryChartData = {
  name: string
  average_salary: number
  employee_count: number
  currency: string
}

type SalaryTooltipProps = {
  active?: boolean
  payload?: Array<{
    payload: SalaryChartData
  }>
}

function SalaryTooltip({ active, payload }: SalaryTooltipProps) {
  if (!active || !payload || payload.length === 0) {
    return null
  }

  const data = payload[0].payload

  return (
    <div className="chart-tooltip">
      <strong>{data.name}</strong>
      <span>Average salary: {data.average_salary.toLocaleString()}</span>
      <span>Employees: {data.employee_count}</span>
      <span>Currency: {data.currency}</span>
    </div>
  )
}

function DashboardPage() {
  const [reports, setReports] = useState<SalaryReport[]>([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)

  useEffect(() => {
    async function loadReport() {
      try {
        const response = await fetchSalaryReport()
        setReports(response.reports)
      } catch {
        setError('Unable to load dashboard data.')
      } finally {
        setLoading(false)
      }
    }

    loadReport()
  }, [])

  const countrySalaryData = useMemo<SalaryChartData[]>(() => {
		const grouped = new Map<string, SalaryChartData>()

		reports.forEach((report) => {
			const existing = grouped.get(report.country)
			const employeeCount = report.employee_count
			const averageSalary = Number(report.average_salary)

			if (!existing) {
				grouped.set(report.country, {
					name: `${report.country} (${report.currency})`,
					average_salary: averageSalary,
					employee_count: employeeCount,
					currency: report.currency,
				})
				return
			}

			const totalEmployees = existing.employee_count + employeeCount
			const weightedAverage =
				(existing.average_salary * existing.employee_count +
					averageSalary * employeeCount) /
				totalEmployees

			existing.average_salary = weightedAverage
			existing.employee_count = totalEmployees
		})

		return Array.from(grouped.values()).sort(
			(a, b) => b.average_salary - a.average_salary,
		)
	}, [reports])

  const departmentSalaryData = useMemo<SalaryChartData[]>(() => {
    return reports
      .map((report) => ({
        name: `${report.department} (${report.currency})`,
        average_salary: Number(report.average_salary),
        employee_count: report.employee_count,
        currency: report.currency,
      }))
      .sort((a, b) => b.average_salary - a.average_salary)
  }, [reports])

  if (loading) {
    return <p>Loading dashboard...</p>
  }

  if (error) {
    return <p>{error}</p>
  }

  return (
    <div>
      <div className="page-header">
        <div>
          <h1>Dashboard</h1>
          <p>Salary and workforce overview.</p>
        </div>
      </div>

      <div className="dashboard-grid">
        <section className="dashboard-card">
          <div className="dashboard-card-header">
            <h2>Average Salary by Country</h2>
            <span>Current compensation</span>
          </div>

          <div className="dashboard-chart">
            <ResponsiveContainer width="100%" height={360}>
              <BarChart data={countrySalaryData}>
                <CartesianGrid strokeDasharray="3 3" />
                <XAxis
                  dataKey="name"
                  angle={-35}
                  textAnchor="end"
                  height={80}
                  interval={0}
                />
                <YAxis />
                <Tooltip content={<SalaryTooltip />} />
                <Bar dataKey="average_salary" name="Average salary" />
              </BarChart>
            </ResponsiveContainer>
          </div>
        </section>

        <section className="dashboard-card">
          <div className="dashboard-card-header">
            <h2>Average Salary by Department</h2>
            <span>Current compensation</span>
          </div>

          <div className="dashboard-chart">
            <ResponsiveContainer width="100%" height={360}>
              <BarChart data={departmentSalaryData}>
                <CartesianGrid strokeDasharray="3 3" />
                <XAxis
                  dataKey="name"
                  angle={-35}
                  textAnchor="end"
                  height={80}
                  interval={0}
                />
                <YAxis />
                <Tooltip content={<SalaryTooltip />} />
                <Bar dataKey="average_salary" name="Average salary" />
              </BarChart>
            </ResponsiveContainer>
          </div>
        </section>
      </div>
    </div>
  )
}

export default DashboardPage
