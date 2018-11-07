defmodule RemoteDay.HomeOfficeTests.EventTest do
  use RemoteDay.DataCase
  import RemoteDay.Factory
  alias RemoteDay.HomeOffice
  alias Timex.Duration

  describe "list_events/0" do
    test "returns all events" do
      event = insert(:event)
      events = HomeOffice.list_events()

      assert Enum.member?(events, event)
    end
  end

  describe "list_events/2" do
    setup do
      today_event = insert(:event)
      tomorrow_event = build(:event) |> coming_date() |> insert()
      yesterday_event = build(:event) |> previous_date() |> insert()

      %{
        today_event: today_event,
        tomorrow_event: tomorrow_event,
        yesterday_event: yesterday_event
      }
    end

    test "returns only events after today (today included)", %{
      today_event: today_event,
      tomorrow_event: tomorrow_event,
      yesterday_event: yesterday_event
    } do
      events = HomeOffice.list_events(:today)

      assert Enum.member?(events, today_event) && Enum.member?(events, tomorrow_event)
      refute Enum.member?(events, yesterday_event)
    end

    test "returns events after today (including today's event) up to 2 days (not included), and not after",
         %{
           today_event: today_event,
           yesterday_event: yesterday_event
         } do
      starting_date = Timex.today()
      in_limit_event = insert(:event, %{date: Timex.add(starting_date, Duration.from_days(1))})
      out_limit_event = insert(:event, %{date: Timex.add(starting_date, Duration.from_days(2))})
      next_week_event = insert(:event, %{date: Timex.add(starting_date, Duration.from_days(7))})

      events = HomeOffice.list_events(:today, 2)

      assert Enum.member?(events, today_event) && Enum.member?(events, in_limit_event)

      refute Enum.member?(events, yesterday_event) && Enum.member?(events, next_week_event) &&
               Enum.member?(events, out_limit_event)
    end

    test "returns events after starting_date (including starting_date's event) up to 2 days (not included), and not after",
         %{today_event: today_event} do
      starting_date = Timex.add(Timex.today(), Duration.from_days(7))
      first_event = insert(:event, %{date: starting_date})
      in_limit_event = insert(:event, %{date: Timex.add(starting_date, Duration.from_days(1))})
      out_limit_event = insert(:event, %{date: Timex.add(starting_date, Duration.from_days(2))})
      next_week_event = insert(:event, %{date: Timex.add(starting_date, Duration.from_days(7))})

      events = HomeOffice.list_events(starting_date, 2)

      assert Enum.member?(events, first_event) && Enum.member?(events, in_limit_event)

      refute Enum.member?(events, today_event) && Enum.member?(events, next_week_event) &&
               Enum.member?(events, out_limit_event)
    end

    test "returns events after starting_date (starting_date included)", %{
      today_event: today_event,
      yesterday_event: yesterday_event
    } do
      starting_date = Timex.add(Timex.today(), Duration.from_days(7))
      in_event = insert(:event, %{date: starting_date})
      next_week_event = insert(:event, %{date: Timex.add(starting_date, Duration.from_days(7))})

      events = HomeOffice.list_events(:today)

      assert Enum.member?(events, in_event) && Enum.member?(events, next_week_event)
      refute Enum.member?(events, today_event) && Enum.member?(events, yesterday_event)
    end
  end

  describe "create event" do
    test "with valid attrs" do
    end
  end
end
