defmodule RemoteDay.Emails.TodayRemoteWorkers do
  @moduledoc """
  Modules defining the email sent daily to inform about remote workers of the day
  """
  import Bamboo.Email

  alias RemoteDay.{
    Emails.Receivers,
    HomeOffice
  }

  require Logger

  @from "remote@your_office.com"

  def list(date \\ :today)
  def list(:today), do: list(Timex.today())

  def list(date) do
    case HomeOffice.list_events(date, 1) do
      [] ->
        Logger.info("No events today. No email will be sent.")
        {:no_event}

      events ->
        date = Timex.format!(date, "{0D}-{0M}-{YYYY}")

        new_email()
        |> to(Receivers.all())
        |> from(@from)
        |> subject("[#{date}] Remote workers")
        |> text_body(generate_text_body(events))
        |> html_body(generate_html_body(events))
    end
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
