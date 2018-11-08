import gql from 'graphql-tag';

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


export { createEvent, fetchEvents };
