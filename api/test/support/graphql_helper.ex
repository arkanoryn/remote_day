defmodule RemoteDayWeb.GraphQLHelper do
  @moduledoc """
  This module defines the helpers to generate queries and mutation for Absinthe.
  """

  use Phoenix.ConnTest
  # We need to set the default endpoint for ConnTest
  @endpoint RemoteDayWeb.Endpoint

  @doc """
  run a GraphQL query
  it expect a conn and :query options.
  :variables is optional
  """
  def graphql_query(conn, path \\ "v1", options) do
    conn
    |> post(path, build_request(options[:query], options[:variables]))
  end

  @doc """
  build a query that can be used to be sent to the server
  * operation_type is either :query or :mutation
  * operation_name is the name of the operation and should match the resolver
    action
  * args is a list of tuples `{key, type}` describing the variables expected by
    the operation
  * keys is a list of keys we expect to receive as reply from the server
  """
  def build_query(operation_type, operation_name, args, keys) do
    """
    #{operation_type} #{operation_name}#{sanitize_types(args)} {
      #{operation_name}#{sanitize_args(args)} {
        #{Enum.join(keys, ",\n")}
      }
    }
    """
  end

  @doc """
  returns a map
  """
  def parse_response(response, operation_name) do
    response["data"][operation_name]
  end

  @doc """
  returns a list of errors
  """
  def parse_errors(response) do
    response["errors"]
  end

  defp sanitize_types(nil), do: ""

  defp sanitize_types(list) do
    types = list |> Enum.map(fn {key, type} -> "$#{key}: #{type}" end) |> Enum.join(", ")
    "(#{types})"
  end

  defp sanitize_args(nil), do: ""

  defp sanitize_args(list) when is_list(list) do
    args = list |> Enum.map(fn {key, _type} -> "#{key}: $#{key}" end) |> Enum.join(", ")
    "(#{args})"
  end

  defp build_request(query, variables) do
    %{
      "query" => query,
      "variables" => variables
    }
  end
end
