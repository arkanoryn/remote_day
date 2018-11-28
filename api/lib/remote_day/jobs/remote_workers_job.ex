defmodule RemoteDay.Jobs.RemoteWorkers do
  @moduledoc false

  alias RemoteDay.{
    Emails,
    Mailer
  }

  def send_daily_emails do
    :today
    |> Emails.TodayRemoteWorkers.list()
    |> Mailer.deliver_now()
  end
end
