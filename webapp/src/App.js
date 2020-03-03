import React from 'react';
import { ApolloProvider } from 'react-apollo';
import { renderRoutes } from 'react-router-config';
import { Provider, connect } from 'react-redux';
import { ConnectedRouter } from 'connected-react-router';
import { CookiesProvider, withCookies } from 'react-cookie';

import {
  client, routes, store, history,
} from './root';
import './App.css';

const WrappedApp = ({ token }) => (
  <ApolloProvider client={client(token)}>
    <ConnectedRouter history={history}>
      {renderRoutes(routes)}
    </ConnectedRouter>
  </ApolloProvider>
);

const MapStateToProps = ({ authentication: { token } }) => ({ token });

const ConnectedApp = connect(MapStateToProps, null)(WrappedApp);

const App = ({ cookies }) => (
  <CookiesProvider>
    <Provider store={store(cookies)}>
      <ConnectedApp />
    </Provider>
  </CookiesProvider>
);createRootReducer(history),

export default withCookies(App);
