import ApolloClient from 'apollo-boost';

const client = new ApolloClient({ uri: 'http://localhost:4000/v1' });

export default client;
