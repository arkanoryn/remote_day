import gql from 'graphql-tag';
import moment from 'moment';

const fetchEvents = gql`
  query allEvents($startingDate: String!, $limit: Int) {
    allEvents (startingDate: $startingDate, limit: $limit) {
      id
      date
      kind
      user {
        email
        username
      }
    }
  }
`;

const createEvent = gql`
  mutation createEvent($date: String!, $kind: String!) {
    createEvent(date: $date, kind: $kind) {
      date
    }
  }
`;

const FETCH_EVENTS_DEFAULT_VARIABLES = { startingDate: moment().format('YYYY-MM-DD'), limit: 7 };

export {
  createEvent,
  fetchEvents,
  FETCH_EVENTS_DEFAULT_VARIABLES,
};
