import React, { Component } from 'react';
import { ApolloProvider } from "react-apollo";
import { renderRoutes } from 'react-router-config';
import { Provider } from 'react-redux';
import { ConnectedRouter } from 'connected-react-router';

import { client, routes, store, history } from './root';
import './App.css';


class App extends Component {
  render() {
    return (
      <Provider store={store}>
        <ApolloProvider client={client}>
          <ConnectedRouter history={history}>
            {renderRoutes(routes)}
          </ConnectedRouter>
        </ApolloProvider>
      </Provider>
    );
  }
}

export default App;
