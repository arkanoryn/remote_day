defmodule RemoteDayWeb.Resolvers.HomeOffice.Events.ListEventsTest do
  @moduledoc """
  Module describing the tests concerning list_events from the HomeOffice Resolver.
  """

  use RemoteDayWeb.ConnCase

  import RemoteDay.Factory
  import RemoteDayWeb.GraphQLHelper

  alias Timex.Duration

  @operation_name "allEvents"

  setup do
    today = insert_list(5, :event)
    past = 3 |> build_list(:event) |> past_date() |> save_list()
    future = 4 |> build_list(:event) |> future_date() |> save_list()

    [today: today, past: past, future: future]
  end

  describe "all_events/3" do
    test "returns todays and futures events when startingDate is 'today'", context do
      %{conn: conn, today: today, past: past, future: future} = context
      valid_events = Enum.map(today ++ future, &%{"id" => "#{&1.id}"})
      past_events = Enum.map(past, &%{"id" => "#{&1.id}"})

      args = [{:startingDate, "String!"}]
      events_query = build_query(:query, @operation_name, args, ~w(id))

      response =
        conn
        |> graphql_query(query: events_query, variables: %{startingDate: "today"})
        |> json_response(200)
        |> parse_response(@operation_name)

      assert response -- valid_events == []
      assert response -- past_events == response
    end

    test "returns events starting from startingDate when startingDate is today's date", context do
      %{conn: conn, today: today, past: past, future: future} = context
      valid_events = Enum.map(today ++ future, &%{"id" => "#{&1.id}"})
      past_events = Enum.map(past, &%{"id" => "#{&1.id}"})
      args = [{:startingDate, "String!"}]
      events_query = build_query(:query, @operation_name, args, ~w(id))

      response =
        conn
        |> graphql_query(
          query: events_query,
          variables: %{startingDate: Timex.format!(Timex.today(), "{YYYY}-{0M}-{0D}")}
        )
        |> json_response(200)
        |> parse_response(@operation_name)

      assert response -- valid_events == []
      assert response -- past_events == response
    end

    test "returns events starting from startingDate when startingDate is another date than today",
         context do
      %{conn: conn, today: today, past: past, future: future} = context
      date = Timex.add(Timex.today(), Duration.from_days(3))

      valid_events =
        (today ++ past ++ future)
        |> Enum.filter(&(Timex.diff(&1.date, date, :days) >= 0))
        |> Enum.map(&%{"id" => "#{&1.id}", "date" => "#{&1.date}"})

      args = [{:startingDate, "String!"}]
      events_query = build_query(:query, @operation_name, args, ~w(id date))

      response =
        conn
        |> graphql_query(
          query: events_query,
          variables: %{startingDate: Timex.format!(date, "{YYYY}-{0M}-{0D}")}
        )
        |> json_response(200)
        |> parse_response(@operation_name)

      assert response -- valid_events == []
    end

    test "returns events starting from startingDate today and up to limit (2 days)",
         context do
      %{conn: conn, today: today, past: past, future: future} = context
      starting_date = Timex.today()
      limit = 2
      date = Timex.add(starting_date, Duration.from_days(limit))

      valid_events =
        (today ++ past ++ future)
        |> Enum.filter(
          &(Timex.diff(&1.date, starting_date, :days) >= 0 && Timex.diff(&1.date, date, :days) < 0)
        )
        |> Enum.map(&%{"id" => "#{&1.id}", "date" => "#{&1.date}"})

      args = [{:startingDate, "String!"}, {:limit, "Int"}]
      events_query = build_query(:query, @operation_name, args, ~w(id date))

      response =
        conn
        |> graphql_query(
          query: events_query,
          variables: %{startingDate: "today", limit: limit}
        )
        |> json_response(200)
        |> parse_response(@operation_name)

      assert response -- valid_events == []
    end

    test "returns events starting from startingDate different than today and up to limit (2 days)",
         context do
      %{conn: conn, today: today, past: past, future: future} = context
      starting_date = Timex.add(Timex.today(), Duration.from_days(5))
      limit = 2
      date = Timex.add(starting_date, Duration.from_days(limit))

      valid_events =
        (today ++ past ++ future)
        |> Enum.filter(
          &(Timex.diff(&1.date, starting_date, :days) >= 0 && Timex.diff(&1.date, date, :days) < 0)
        )
        |> Enum.map(&%{"id" => "#{&1.id}", "date" => "#{&1.date}"})

      args = [{:startingDate, "String!"}, {:limit, "Int"}]
      events_query = build_query(:query, @operation_name, args, ~w(id date))

      response =
        conn
        |> graphql_query(
          query: events_query,
          variables: %{
            startingDate: Timex.format!(starting_date, "{YYYY}-{0M}-{D}"),
            limit: limit
          }
        )
        |> json_response(200)
        |> parse_response(@operation_name)

      assert response -- valid_events == []
    end
  end
end
