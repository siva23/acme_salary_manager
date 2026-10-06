import {
  BrowserRouter,
  NavLink,
  Route,
  Routes,
} from 'react-router-dom'
import './App.css'
import EmployeesPage from './pages/EmployeesPage'
import EmployeeDetailsPage from './pages/EmployeeDetailsPage'

function App() {
  return (
    <BrowserRouter>
      <div className="app-shell">
        <header className="topbar">
          <div className="brand">ACME HR</div>

          <div className="user-menu">
            <span className="user-avatar">A</span>
            <span>Admin</span>
          </div>
        </header>

        <div className="app-body">
          <aside className="sidebar">
            <nav>
              <NavLink
                to="/"
                className={({ isActive }) =>
                  `nav-item${isActive ? ' active' : ''}`
                }
              >
                Dashboard
              </NavLink>

              <NavLink
                to="/employees"
                className={({ isActive }) =>
                  `nav-item${isActive ? ' active' : ''}`
                }
              >
                Employees
              </NavLink>

              <NavLink
                to="/reports"
                className={({ isActive }) =>
                  `nav-item${isActive ? ' active' : ''}`
                }
              >
                Reports
              </NavLink>
            </nav>
          </aside>

          <main className="main-content">
            <Routes>
              <Route
                path="/"
                element={
                  <>
                    <h1>Dashboard</h1>
                    <p>
                      Welcome to the ACME HR salary management system.
                    </p>
                  </>
                }
              />

              <Route path="/employees" element={<EmployeesPage />} />
              <Route path="/employees/:id" element={<EmployeeDetailsPage />} />
            </Routes>
          </main>
        </div>
      </div>
    </BrowserRouter>
  )
}

export default App