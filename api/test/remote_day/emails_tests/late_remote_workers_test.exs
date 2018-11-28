defmodule RemoteDay.Tests.Emails.LateRemoteWorkers do
  use RemoteDay.DataCase
  use Bamboo.Test

  import RemoteDay.Factory

  alias RemoteDay.Emails.LateRemoteWorkers

  describe "announcement/1" do
    test "should create an email with important information" do
      event = insert(:event)

      email = LateRemoteWorkers.announcement(event.user)
      assert email.from == "remote@your_office.com"
      assert Enum.any?(email.to, &(&1 == event.user.email))
      assert email.html_body =~ "<h1>Sorry, I am late :(</h1>"
      assert email.html_body =~ event.user.username
      assert email.text_body =~ "Sorry, I am late :("
      assert email.text_body =~ event.user.username
    end
  end
end
