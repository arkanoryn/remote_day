defmodule RemoteDay.Jobs.RemoteWorkers do
  @moduledoc false
  alias RemoteDay.{
    Emails,
    Mailer
  }

  require Logger

  def send_daily_emails do
    Logger.info("action='send_email/job' status='in_progress'")

    :today
    |> Emails.TodayRemoteWorkers.list()
    |> Mailer.deliver_now()
  end
end
