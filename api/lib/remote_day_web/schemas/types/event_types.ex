defmodule RemoteDayWeb.Schema.Types.Events do
  @moduledoc """
  objects, queries and mutations related to the Events
  """
  use Absinthe.Schema.Notation

  alias RemoteDayWeb.Schema.Middleware
  alias RemoteDayWeb.Resolvers.HomeOffice

  object :event do
    field(:id, non_null(:id))
    field(:kind, :string)
    field(:date, non_null(:string), description: "string representing the date (YYYY-MM-DD)")
    field(:user_id, :integer)
  end

  object :events_queries do
    @desc "Fetch all events from `startingDate` up to a limit (if defined)"
    field(:all_events, list_of(:event)) do
      arg(
        :starting_date,
        non_null(:string),
        description: "Can be either 'today' or a date in format YYYY-MM-DD"
      )

      arg(
        :limit,
        :integer,
        description: """
        limit of days that we wish to fetch. The limit will not be part of the
        result.

        For example if starting_date = "today" & limit = 2, then
        the events fetched will be from today & tomorrow, not the day after.
        """
      )

      resolve(&HomeOffice.all_events/3)
    end
  end

  object :events_mutations do
    @desc "Create an event"
    field(:create_event, :event) do
      arg(:kind, :string)
      arg(:date, non_null(:string))

      middleware(Middleware.Authorize)
      resolve(&HomeOffice.create_event/3)
    end
  end
end
