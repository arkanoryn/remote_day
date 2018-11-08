defmodule RemoteDayWeb.Resolvers.HomeOffice.Events.CreateEventTest do
  @moduledoc """
  Module describing the tests concerning create_event from the HomeOffice Resolver.
  """

  use RemoteDayWeb.ConnCase

  import RemoteDay.Factory
  import RemoteDayWeb.GraphQLHelper

  alias Timex.Duration

  @date_format "{YYYY}-{0M}-{0D}"
  @default_event_kind "day"
  @operation_name "createEvent"
  @operation_type :mutation
  @required_event_args [
    {:date, "String!"},
    {:user_id, "ID!"}
  ]
  @optional_event_args [
    {:kind, "String"}
  ]
  @today Timex.today()
  @past_date Timex.subtract(@today, Duration.from_days(Enum.random(1..42)))

  describe "create_events/3" do
    test "create an event with all arguments", %{conn: conn} do
      attrs = params_for(:event, date: format_date(@today))
      args = @required_event_args ++ @optional_event_args

      create_event_query =
        build_query(@operation_type, @operation_name, args, ~w(id kind date user_id))

      response =
        conn
        |> graphql_query(query: create_event_query, variables: attrs)
        |> json_response(200)
        |> parse_response(@operation_name)

      assert response["id"]
      assert response["kind"] == attrs.kind
      assert response["date"] == attrs.date
      assert response["user_id"] == attrs.user_id
    end

    test "create an event with only required arguments", %{conn: conn} do
      attrs = params_for(:event, date: format_date(@today))
      args = @required_event_args

      create_event_query = build_query(@operation_type, @operation_name, args, ~w(id kind))

      response =
        conn
        |> graphql_query(query: create_event_query, variables: attrs)
        |> json_response(200)
        |> parse_response(@operation_name)

      assert response["id"]
      assert response["kind"] == @default_event_kind
    end

    test "create an event with past date", %{conn: conn} do
      attrs = params_for(:event, date: format_date(@past_date))
      args = @required_event_args

      create_event_query = build_query(@operation_type, @operation_name, args, ~w(id kind))

      response =
        conn
        |> graphql_query(query: create_event_query, variables: attrs)
        |> json_response(200)
        |> parse_errors()

      assert List.first(response)["message"] == "An error occured."
    end
  end

  defp format_date(date), do: Timex.format!(date, @date_format)
end
