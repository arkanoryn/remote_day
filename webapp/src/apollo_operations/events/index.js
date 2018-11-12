import gql from 'graphql-tag';
import moment from 'moment';

const fetchEvents = gql`
  query allEvents($startingDate: String!, $limit: Int) {
    allEvents (startingDate: $startingDate, limit: $limit) {
      id
      date
      kind
      userId
    }
  }
`;

const createEvent = gql`
  mutation createEvent($date: String!, $userId: ID!, $kind: String!) {
    createEvent(date: $date, userId: $userId, kind: $kind) {
      id
      date
      kind
      userId
    }
  }
`;

const FETCH_EVENTS_DEFAULT_VARIABLES = { startingDate: moment().format('YYYY-MM-DD'), limit: 7 };

export {
  createEvent,
  fetchEvents,
  FETCH_EVENTS_DEFAULT_VARIABLES,
};
