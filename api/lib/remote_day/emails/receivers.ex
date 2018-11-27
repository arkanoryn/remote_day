defmodule RemoteDay.Emails.Receivers do
  @moduledoc """
  Defines receivers list
  """

  alias RemoteDay.Account

  def all do
    Account.list_users()
    |> Enum.map(& &1.email)
  end
end
