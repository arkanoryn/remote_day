defmodule RemoteDay.Tests.Jobs.RemoteWorkers do
  use RemoteDay.DataCase
  use Bamboo.Test

  import RemoteDay.Factory

  alias RemoteDay.Jobs.RemoteWorkers

  describe "send_daily_emails/0" do
    test "should send email" do
      insert(:event)

      assert_delivered_email(RemoteWorkers.send_daily_emails())
    end
  end
end
