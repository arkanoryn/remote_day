import React from 'react';
import { ApolloProvider } from 'react-apollo';
import { renderRoutes } from 'react-router-config';
import { Provider } from 'react-redux';
import { ConnectedRouter } from 'connected-react-router';
import { CookiesProvider, withCookies } from 'react-cookie';

import { client, routes, store, history } from './root';
import './App.css';

const App = ({ cookies }) => {
  return (
    <CookiesProvider>
      <Provider store={store(cookies)}>
        <ApolloProvider client={client}>
          <ConnectedRouter history={history}>
            {renderRoutes(routes)}
          </ConnectedRouter>
        </ApolloProvider>
      </Provider>
    </CookiesProvider>
  );
};

export default withCookies(App);
