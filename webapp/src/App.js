import React, { Component } from 'react';
import { renderRoutes } from 'react-router-config';
import { Provider } from 'react-redux';
import { ConnectedRouter } from 'connected-react-router';

import { routes, store, history } from './root';
import './App.css';


class App extends Component {
  render() {
    return (
      <Provider store={store}>
        <ConnectedRouter history={history}>
          {renderRoutes(routes)}
        </ConnectedRouter>
      </Provider>
    );
  }
}

export default App;
