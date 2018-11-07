defmodule RemoteDay.Factory.HomeOffice.Event do
  @moduledoc """
  Event Factory
  """
  alias RemoteDay.HomeOffice.Event

  defmacro __using__(_opts) do
    quote do
      @previous_date Timex.subtract(Timex.today(), Timex.Duration.from_days(Enum.random(1..42)))
      @coming_date Timex.add(Timex.today(), Timex.Duration.from_days(Enum.random(1..42)))

      def event_factory do
        %Event{
          user_id: 42,
          date: Timex.today(),
          kind: "day"
        }
      end

      def previous_date(%Event{} = event) do
        %Event{event | date: @previous_date}
      end

      def coming_date(%Event{} = event) do
        %Event{event | date: @coming_date}
      end
    end
  end
end
