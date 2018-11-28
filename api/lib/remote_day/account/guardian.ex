defmodule RemoteDay.Account.Guardian do
  @moduledoc """
  Module to handle Guardian
  """
  use Guardian, otp_app: :remote_day

  alias RemoteDay.Account
  alias RemoteDay.Account.User

  @spec subject_for_token(%{id: integer}, any) :: {:ok, User.t()}
  def subject_for_token(%{id: id}, _claims) do
    sub = to_string(id)
    {:ok, sub}
  end

  @spec subject_for_token(any, any) :: {:error, :reason_for_error}
  def subject_for_token(_, _) do
    {:error, :not_found}
  end

  @spec resource_from_claims(map()) :: {:ok, User.t()} | {:error, :not_found}
  def resource_from_claims(%{"sub" => id}) do
    case Account.get_user!(id) do
      nil -> {:error, :not_found}
      resource -> {:ok, resource}
    end
  end

  @spec resource_from_claims(any) :: {:error, :not_found}
  def resource_from_claims(_claims) do
    {:error, :not_found}
  end
end
