import './App.css'

function App() {
  return (
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
            <a href="/" className="nav-item active">
              Dashboard
            </a>

            <a href="/employees" className="nav-item">
              Employees
            </a>

            <a href="/reports" className="nav-item">
              Reports
            </a>
          </nav>
        </aside>

        <main className="main-content">
          <h1>Dashboard</h1>
          <p>Welcome to the ACME HR salary management system.</p>
        </main>
      </div>
    </div>
  )
}

export default App