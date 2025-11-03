defmodule Eams.Repo do
  use Ecto.Repo,
    otp_app: :eams,
    adapter: Ecto.Adapters.Postgres
end
