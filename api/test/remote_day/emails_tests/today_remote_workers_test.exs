defmodule RemoteDay.Tests.Emails.TodayRemoteWorkers do
  use RemoteDay.DataCase
  use Bamboo.Test

  import RemoteDay.Factory

  alias RemoteDay.Emails.TodayRemoteWorkers

  describe "list/1" do
    test "should contain new event username" do
      event = insert(:event)

      email = TodayRemoteWorkers.list()
      assert email.from == "remote@your_office.com"
      assert Enum.any?(email.to, &(&1 == event.user.email))
      assert email.html_body =~ "<h1>Today's remote workers</h1>"
      assert email.html_body =~ "<li>#{event.user.username}</li>"
      assert email.text_body =~ "Today's remote workers"
      assert email.text_body =~ event.user.username
    end
  end

  test "should return {:no_event}" do
    assert {:no_event} = TodayRemoteWorkers.list()
  end
end
