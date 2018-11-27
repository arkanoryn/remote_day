defmodule RemoteDay.Jobs.RemoteWorkers do
  @moduledoc false

  def send_daily_emails do
    RemoteDay.Emails.RemoteWorkers.list_remote_workers_email(:today)
    |> RemoteDay.Mailer.deliver_now()
  end
end
