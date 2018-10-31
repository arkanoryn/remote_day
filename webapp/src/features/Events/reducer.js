const FETCH_EVENTS_FAILURE = 'FETCH_EVENTS_FAILURE';
const FETCH_EVENTS_REQUEST = 'FETCH_EVENTS_REQUEST';
const FETCH_EVENTS_SUCCESS = 'FETCH_EVENTS_SUCCESS';


const fetchEvents = () => { return { type: FETCH_EVENTS_REQUEST }; };
const fetchEventsSucceeded = (events) => { return { type: FETCH_EVENTS_SUCCESS, events }; };
const fetchEventsFailed = (errors) => { return { type: FETCH_EVENTS_FAILURE, errors }; };

const initialState = {
  isLoading: false,
  events:    [],
  errors:    [],
};

const eventsReducer = (state = initialState, action) => {
  switch (action.type) {
    case FETCH_EVENTS_REQUEST:
      return ({
        ...state,
        isLoading: true,
        errors:    [],
      });

    case FETCH_EVENTS_SUCCESS: {
      const { events } = action;

      return ({
        ...state,
        isLoading: false,
        events,
        errors:    [],
      });
    }

    case FETCH_EVENTS_FAILURE: {
      const { errors } = action;

      return ({
        ...state,
        isLoading: false,
        errors,
      });
    }

    default:
      return state;
  }
};

export default eventsReducer;
export {
  fetchEvents,
  fetchEventsFailed,
  fetchEventsSucceeded,
};
