import React from 'react';
import { ApolloProvider } from 'react-apollo';
import { renderRoutes } from 'react-router-config';
import { Provider, connect } from 'react-redux';
import { ConnectedRouter } from 'connected-react-router';
import { CookiesProvider, withCookies } from 'react-cookie';

import { client, routes, store, history } from './root';
import './App.css';

const WrappedApp = ({ token }) => {
  return (
    <ApolloProvider client={client(token)}>
      <ConnectedRouter history={history}>
        {renderRoutes(routes)}
      </ConnectedRouter>
    </ApolloProvider>
  );
};

const MapStateToProps = ({ authentication: { token } }) => {
  return { token };
};

const ConnectedApp = connect(MapStateToProps, null)(WrappedApp);

const App = ({ cookies }) => {
  return (
    <CookiesProvider>
      <Provider store={store(cookies)}>
        <ConnectedApp />
      </Provider>
    </CookiesProvider>
  );
};

export default withCookies(App);
