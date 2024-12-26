# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Mp.Repo.insert!(%Mp.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

Mp.Accounts.register_user(%{
  email: "tyler@tylerayoung.com",
  password: "testing!1234",
  password_confirmation: "testing!1234"
})
