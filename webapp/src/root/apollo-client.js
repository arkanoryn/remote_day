import ApolloClient from 'apollo-boost';

const client = (cookies) => {
  const token = cookies.get('token');

  return new ApolloClient({
    uri:     'http://localhost:4000/v1',
    headers: { authorization: token ? `Bearer ${token}` : '' },
  });
};
export default client;
