import { useEffect, useState } from 'react'
import { fetchEmployees } from '../api/employees'
import type { Employee } from '../types/employee'
import { Link } from 'react-router-dom'

function EmployeesPage() {
  const [employees, setEmployees] = useState<Employee[]>([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)

  useEffect(() => {
    async function loadEmployees() {
      try {
        const response = await fetchEmployees()
        setEmployees(response.employees)
      } catch {
        setError('Unable to load employees.')
      } finally {
        setLoading(false)
      }
    }

    loadEmployees()
  }, [])

  return (
    <div>
      <div className="page-header">
        <div>
          <h1>Employees</h1>
          <p>View employee information and compensation history.</p>
        </div>
      </div>

      {loading && <p>Loading employees...</p>}

      {error && <p>{error}</p>}

      {!loading && !error && (
        <div className="employee-table-wrapper">
          <table className="employee-table">
            <thead>
              <tr>
                <th>Employee</th>
                <th>Job Title</th>
                <th>Department</th>
                <th>Country</th>
                <th>Status</th>
              </tr>
            </thead>

            <tbody>
              {employees.map((employee) => (
                <tr key={employee.id}>
                  <td>
                    <Link to={`/employees/${employee.id}`}>
                      <strong>
                        {employee.first_name} {employee.last_name}
                      </strong>
                    </Link>
                    <span>{employee.employee_number}</span>
                  </td>
                  <td>{employee.job_title}</td>
                  <td>{employee.department.name}</td>
                  <td>{employee.country.name}</td>
                  <td>{employee.employment_status}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}
    </div>
  )
}

export default EmployeesPage
