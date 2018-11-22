import gql from 'graphql-tag';

const authenticate = gql`
  mutation authenticate($email: String!, $password: String!) {
    authenticate(email: $email, password: $password) {
      token
      user {
        username
        email
      }
    }
  }
`;

const tmp = '';

export {
  authenticate,
  tmp,
};
