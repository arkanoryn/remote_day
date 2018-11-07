defmodule RemoteDayWeb.Schema.EventTypes do
  use Absinthe.Schema.Notation

  alias RemoteDayWeb.Resolvers.HomeOffice

  object :event do
    field(:id, non_null(:id))
    field(:kind, :string)
    field(:date, non_null(:string), description: "date in UTC format: YYYY-MM-DD")
    field(:user_id, :integer)
  end

  object :events_queries do
    @desc "fetch all events"
    field(:all_events, list_of(:event)) do
      arg(
        :starting_date,
        non_null(:string),
        description: "Can be either 'today' or a date in UTC format"
      )

      resolve(&HomeOffice.all_events/3)
    end
  end
end
