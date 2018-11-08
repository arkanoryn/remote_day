defmodule RemoteDay.Factory.HomeOffice.Event do
  @moduledoc """
  Event Factory
  """
  alias RemoteDay.HomeOffice.Event
  alias Timex.Duration

  defmacro __using__(_opts) do
    quote do
      def event_factory do
        %Event{
          user_id: 42,
          date: Timex.today(),
          kind: "day"
        }
      end

      def previous_date(%Event{} = event) do
        %Event{event | date: past_date()}
      end

      def coming_date(%Event{} = event) do
        %Event{event | date: future_date()}
      end

      def past_date(list) when is_list(list),
        do: Enum.map(list, fn e -> %Event{e | date: past_date()} end)

      def future_date(list) when is_list(list),
        do: Enum.map(list, fn e -> %Event{e | date: future_date()} end)

      defp past_date,
        do: Timex.subtract(Timex.today(), Duration.from_days(Enum.random(1..42)))

      defp future_date, do: Timex.add(Timex.today(), Duration.from_days(Enum.random(1..42)))
    end
  end
end
