import ApolloClient from 'apollo-boost';

const token = localStorage.getItem('token');
console.log('....................... apollo-client#token:', token);

const client = new ApolloClient({
  uri:     'http://localhost:4000/v1',
  headers: { authorization: token ? `Bearer ${token}` : '' },
});

export default client;
