import React from 'react';
import { ApolloProvider } from 'react-apollo';
import { renderRoutes } from 'react-router-config';
import { Provider } from 'react-redux';
import { ConnectedRouter } from 'connected-react-router';
import { CookiesProvider } from 'react-cookie';

import { client, routes, store, history } from './root';
import './App.css';

const App = () => {
  return (
    <CookiesProvider>
      <Provider store={store}>
        <ApolloProvider client={client}>
          <ConnectedRouter history={history}>
            {renderRoutes(routes)}
          </ConnectedRouter>
        </ApolloProvider>
      </Provider>
    </CookiesProvider>
  );
};

export default App;
