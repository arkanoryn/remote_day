defmodule RemoteDay.Jobs.RemoteWorkers do
  @moduledoc false

  alias RemoteDay.{
    Emails,
    Mailer
  }

  def send_daily_emails do
    :today
    |> Emails.RemoteWorkers.list_remote_workers_email()
    |> Mailer.deliver_now()
  end
end
