# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Cookpod.Repo.insert!(%Cookpod.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.


Cookpod.Repo.delete_all Cookpod.User

Cookpod.User.changeset(%Cookpod.User{}, %{email: "markus@gmail.com", password: "password"})
|> Cookpod.Repo.insert!

Cookpod.User.changeset(%Cookpod.User{}, %{email: "guest@example.org", password: "password"})
|> Cookpod.Repo.insert!
