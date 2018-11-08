defmodule RemoteDay.HomeOfficeTests.EventsTest do
  @moduledoc """
  Module describing the tests of the Event from HomeOffice
  """
  use RemoteDay.DataCase

  import RemoteDay.Factory

  alias RemoteDay.HomeOffice
  alias RemoteDay.HomeOffice.Event
  alias Timex.Duration

  @past_date Timex.subtract(Timex.today(), Duration.from_days(Enum.random(1..42)))

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

  describe "create_event/1" do
    test "with valid attrs" do
      attrs = params_for(:event)

      assert {:ok, %Event{} = event} = HomeOffice.create_event(attrs)
      assert event.kind == attrs.kind
      assert event.date == attrs.date
      assert event.user_id == attrs.user_id
    end

    test "with only valid user_id and date - kind should be the default value" do
      attrs = %{date: Timex.today(), user_id: 12}

      assert {:ok, %Event{} = event} = HomeOffice.create_event(attrs)
      assert event.kind == "day"
      assert event.date == attrs.date
      assert event.user_id == attrs.user_id
    end

    test "with missing attrs" do
      assert {:error, changeset} = HomeOffice.create_event(%{})
      assert "can't be blank" in errors_on(changeset).user_id
      assert "can't be blank" in errors_on(changeset).date
    end

    test "date must be >= today" do
      attrs = %{params_for(:event) | date: @past_date}

      assert {:error, changeset} = HomeOffice.create_event(attrs)
      assert "can only be today or future date" in errors_on(changeset).date
    end

    @tag skip: "kind selector as not been determined yet"
    test "kind must be one of the predetermined value" do
      attrs = params_for(:event)

      assert {:ok, _} = HomeOffice.create_event(%{attrs | kind: "other"})
      assert {:error, _} = HomeOffice.create_event(%{attrs | kind: "invalid"})
    end
  end

  describe("update_event/1") do
    setup do
      %{event: insert(:event)}
    end

    test "with valid attrs", %{event: event} do
      future_event = build(:event) |> coming_date()

      assert {:ok, %Event{} = e} = HomeOffice.update_event(event, %{user_id: 12})
      assert e.user_id == 12 && e.id == event.id
      assert {:ok, %Event{} = _} = HomeOffice.update_event(event, %{date: future_event.date})
      assert {:ok, %Event{} = _} = HomeOffice.update_event(event, %{kind: "partial"})
    end

    test "date must be >= today", %{event: event} do
      attrs = %{params_for(:event) | date: @past_date}

      assert {:error, changeset} = HomeOffice.update_event(event, attrs)
      assert "can only be today or future date" in errors_on(changeset).date
    end

    test "with invalid attrs", %{event: event} do
      assert {:error, _} = HomeOffice.update_event(event, %{date: @past_date})
      assert {:error, _} = HomeOffice.update_event(event, %{date: nil})
      assert {:error, _} = HomeOffice.update_event(event, %{kind: nil})
      assert {:error, _} = HomeOffice.update_event(event, %{user_id: nil})
    end

    @tag skip: "kind selector as not been determined yet"
    test "kind must be one of the predetermined value", %{event: event} do
      assert {:ok, _} = HomeOffice.update_event(event, %{kind: "other"})
      assert {:error, _} = HomeOffice.update_event(event, %{kind: "invalid"})
    end
  end

  describe("delete_event/1") do
    setup do
      %{event: insert(:event)}
    end

    test "delete existing event by event", %{event: event} do
      assert {:ok, event} = HomeOffice.delete_event(event)
    end

    test "delete existing event by event id", %{event: event} do
      assert {:ok, event} = HomeOffice.delete_event(event.id)
    end
  end
end
