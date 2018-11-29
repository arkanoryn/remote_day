defmodule RemoteDay.Emails.Receivers do
  @moduledoc """
  Defines receivers list
  """
  require Logger
  alias RemoteDay.Account

  def all do
    Logger.debug("fetch all emails")

    Account.list_users()
    |> Enum.map(& &1.email)
  end
end
