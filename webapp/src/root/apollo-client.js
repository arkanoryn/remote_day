import ApolloClient from 'apollo-boost';

const client = new ApolloClient({ uri: 'localhost:3000/graphql' });

export default client;
