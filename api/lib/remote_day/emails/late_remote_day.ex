defmodule RemoteDay.Emails.LateRemoteWorkers do
  @moduledoc """
  email to late announcement
  """

  import Bamboo.Email

  alias RemoteDay.{
    Account.User,
    Emails.Receivers
  }

  require Logger

  @from "remote@your_office.com"

  def announcement(%User{} = user) do
    date = Timex.format!(Timex.today(), "{0D}-{0M}-{YYYY}")

    new_email()
    |> to(Receivers.all())
    |> from(@from)
    |> subject("[#{date}] Remote workers - late announcement")
    |> text_body(generate_text_body(user))
    |> html_body(generate_html_body(user))
  end

  defp generate_text_body(user) do
    """
    Sorry, I am late :(

    <p>
      I will be working remotely today.
    <p>

    <br />
    --
    #{user.username || user.email}
    """
  end

  defp generate_html_body(user) do
    """
    <h1>Sorry, I am late :(</h1>

    I will be working remotely today.

    <br /><br />--<br />
    <i>
      #{user.username || user.email}
    </i>
    """
  end
end
