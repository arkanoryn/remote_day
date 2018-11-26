defmodule RemoteDay.Emails.RemoteWorkers do
  @moduledoc """
  Modules defining the email sent daily to inform about remote workers of the day
  """
  import Bamboo.Email
  alias RemoteDay.{Account, HomeOffice}
  require Logger

  @from "remote@your_office.com"

  def list_remote_workers_email(date \\ :today)
  def list_remote_workers_email(:today), do: list_remote_workers_email(Timex.today())

  def list_remote_workers_email(date) do
    case HomeOffice.list_events(date, 1) do
      [] ->
        Logger.info("No events today. No email will be sent.")

      events ->
        date = Timex.format!(date, "{0D}-{0M}-{YYYY}")

        new_email()
        |> to(receivers())
        |> from(@from)
        |> subject("[#{date}] Remote workers")
        |> text_body(generate_text_body(events))
        |> html_body(generate_html_body(events))
    end
  end

  defp receivers do
    Account.list_users()
    |> Enum.map(& &1.email)
  end

  defp generate_text_body(events) do
    formatted_events =
      events
      |> Enum.map(&"* #{&1.user.username}")
      |> Enum.join("\n")

    """
    Today's remote workers

    #{formatted_events}
    """
  end

  defp generate_html_body(events) do
    formatted_events =
      events
      |> Enum.map(&"<li>#{&1.user.username}</li>")
      |> Enum.join("\n")

    """
    <h1>Today's remote workers</h1>

    <p>
      <ul>#{formatted_events}</ul>
    </p>
    """
  end
end
