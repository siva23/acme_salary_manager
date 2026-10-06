import { useEffect, useState } from 'react'
import { useParams } from 'react-router-dom'
import { fetchEmployee } from '../api/employees'
import type { Employee } from '../types/employee'

function EmployeeDetailsPage() {
  const { id } = useParams<{ id: string }>()
  const [employee, setEmployee] = useState<Employee | null>(null)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)

  useEffect(() => {
    async function loadEmployee() {
      if (!id) {
        setError('Employee ID is missing.')
        setLoading(false)
        return
      }

      try {
        const response = await fetchEmployee(Number(id))
        setEmployee(response)
      } catch {
        setError('Unable to load employee.')
      } finally {
        setLoading(false)
      }
    }

    loadEmployee()
  }, [id])

  if (loading) {
    return <p>Loading employee...</p>
  }

  if (error) {
    return <p>{error}</p>
  }

  if (!employee) {
    return <p>Employee not found.</p>
  }

  return (
    <div>
      <div className="page-header">
        <div>
          <h1>
            {employee.first_name} {employee.last_name}
          </h1>
          <p>{employee.employee_number}</p>
        </div>
      </div>

      <div className="employee-details">
        <section className="details-card">
          <h2>Personal Information</h2>

          <div className="details-grid">
            <div>
              <span className="detail-label">First Name</span>
              <span>{employee.first_name}</span>
            </div>

            <div>
              <span className="detail-label">Last Name</span>
              <span>{employee.last_name}</span>
            </div>

            <div>
              <span className="detail-label">Email</span>
              <span>{employee.email}</span>
            </div>
          </div>
        </section>

        <section className="details-card">
          <h2>Employment Information</h2>

          <div className="details-grid">
            <div>
              <span className="detail-label">Job Title</span>
              <span>{employee.job_title}</span>
            </div>

            <div>
              <span className="detail-label">Job Level</span>
              <span>{employee.job_level.name}</span>
            </div>

            <div>
              <span className="detail-label">Department</span>
              <span>{employee.department.name}</span>
            </div>

            <div>
              <span className="detail-label">Country</span>
              <span>{employee.country.name}</span>
            </div>

            <div>
              <span className="detail-label">Status</span>
              <span>{employee.employment_status}</span>
            </div>

            <div>
              <span className="detail-label">Joining Date</span>
              <span>{employee.joining_date}</span>
            </div>
          </div>
        </section>
      </div>
    </div>
  )
}

export default EmployeeDetailsPage
