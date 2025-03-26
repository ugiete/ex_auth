defmodule ExAuth.Repo do
  use Ecto.Repo,
    otp_app: :ex_auth,
    adapter: Ecto.Adapters.Postgres
end
