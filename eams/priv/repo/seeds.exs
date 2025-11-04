# priv/repo/seeds.exs
alias Eams.{Repo, Accounts, Orgs}
alias Eams.Accounts.User
alias Eams.Orgs.{Organization, Department, Team}

# Clear existing data (development only!)
Repo.delete_all(User)
Repo.delete_all(Team)
Repo.delete_all(Department)
Repo.delete_all(Organization)

# Create Super Supervisor
{:ok, super_supervisor} =
  Accounts.create_user(%{
    email: "admin@eams.com",
    password: "Admin@123456",
    password_confirmation: "Admin@123456",
    full_name: "System Administrator",
    role: "super_supervisor",
    must_change_password: false
  })

IO.puts("✓ Created Super Supervisor: #{super_supervisor.email}")

# Create Organization
{:ok, org} =
  Orgs.create_organization(
    %{
      name: "Tech Solutions Inc",
      code: "TSI",
      description: "Leading technology solutions provider",
      email: "info@techsolutions.com",
      phone: "+1234567890"
    },
    super_supervisor
  )

IO.puts("✓ Created Organization: #{org.name}")

# Create Departments
{:ok, it_dept} =
  Orgs.create_department(
    %{
      name: "IT Department",
      code: "IT",
      description: "Information Technology",
      organization_id: org.id
    },
    super_supervisor
  )

{:ok, hr_dept} =
  Orgs.create_department(
    %{
      name: "HR Department",
      code: "HR",
      description: "Human Resources",
      organization_id: org.id
    },
    super_supervisor
  )

IO.puts("✓ Created Departments: IT, HR")

# Create Teams
{:ok, frontend_team} =
  Orgs.create_team(
    %{
      name: "Frontend Development Team",
      code: "FE",
      description: "React and UI/UX specialists",
      specialization: "Frontend Development",
      max_attachees: 5,
      department_id: it_dept.id
    },
    super_supervisor
  )

{:ok, backend_team} =
  Orgs.create_team(
    %{
      name: "Backend Development Team",
      code: "BE",
      description: "API and database specialists",
      specialization: "Backend Development",
      max_attachees: 5,
      department_id: it_dept.id
    },
    super_supervisor
  )

IO.puts("✓ Created Teams: Frontend, Backend")

# Create Supervisors
{:ok, fe_supervisor, fe_temp_pass} =
  Accounts.create_user_with_temp_password(
    %{
      email: "fe.supervisor@eams.com",
      full_name: "John Smith",
      role: "supervisor",
      team_id: frontend_team.id
    },
    super_supervisor
  )

{:ok, be_supervisor, be_temp_pass} =
  Accounts.create_user_with_temp_password(
    %{
      email: "be.supervisor@eams.com",
      full_name: "Jane Doe",
      role: "supervisor",
      team_id: backend_team.id
    },
    super_supervisor
  )

IO.puts("✓ Created Supervisors:")
IO.puts("  - #{fe_supervisor.email} (Password: #{fe_temp_pass})")
IO.puts("  - #{be_supervisor.email} (Password: #{be_temp_pass})")

# Assign supervisors to teams
Orgs.assign_supervisor_to_team(frontend_team, fe_supervisor.id)
Orgs.assign_supervisor_to_team(backend_team, be_supervisor.id)

# Create Attachees
{:ok, attachee1, at1_pass} =
  Accounts.create_user_with_temp_password(
    %{
      email: "alice@university.edu",
      full_name: "Alice Johnson",
      role: "attachee",
      team_id: frontend_team.id,
      start_date: ~D[2024-12-01],
      end_date: ~D[2025-03-31],
      skills: ["React", "JavaScript", "CSS", "HTML"]
    },
    fe_supervisor
  )

{:ok, attachee2, at2_pass} =
  Accounts.create_user_with_temp_password(
    %{
      email: "bob@university.edu",
      full_name: "Bob Williams",
      role: "attachee",
      team_id: backend_team.id,
      start_date: ~D[2024-12-01],
      end_date: ~D[2025-03-31],
      skills: ["Elixir", "Phoenix", "PostgreSQL", "REST APIs"]
    },
    be_supervisor
  )

IO.puts("✓ Created Attachees:")
IO.puts("  - #{attachee1.email} (Password: #{at1_pass})")
IO.puts("  - #{attachee2.email} (Password: #{at2_pass})")

IO.puts("\n" <> String.duplicate("=", 60))
IO.puts("Seed data created successfully!")
IO.puts(String.duplicate("=", 60))
IO.puts("\nLogin Credentials:")
IO.puts("\nSuper Supervisor:")
IO.puts("  Email: admin@eams.com")
IO.puts("  Password: Admin@123456")
IO.puts("\nFrontend Supervisor:")
IO.puts("  Email: fe.supervisor@eams.com")
IO.puts("  Password: #{fe_temp_pass}")
IO.puts("\nBackend Supervisor:")
IO.puts("  Email: be.supervisor@eams.com")
IO.puts("  Password: #{be_temp_pass}")
IO.puts(String.duplicate("=", 60))
