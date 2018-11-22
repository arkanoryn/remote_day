# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     RemoteDay.Repo.insert!(%RemoteDay.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias RemoteDay.Repo
alias RemoteDay.{Account, HomeOffice}

HomeOffice.create_event(%{date: Timex.today(), user_id: 12})

Account.create_user(%{
  email: "test@user.com",
  password: "password",
  password_confirmation: "password",
  username: "Alpha Tester"
})
