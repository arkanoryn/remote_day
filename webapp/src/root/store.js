import { applyMiddleware, compose, createStore } from 'redux';

import { connectRouter } from 'connected-react-router';
import middlewares from './middlewares';
import rootReducer from './rootReducer';
import history from './history';

// eslint-disable-next-line no-underscore-dangle
const composeEnhancer = window.__REDUX_DEVTOOLS_EXTENSION_COMPOSE__ || compose;

const store = (cookies) => {
  const initialState = {
    authentication: {
      token: cookies.get('token') || null,
      user:  cookies.get('user') || {},
    },
  };

  return (createStore(
    connectRouter(history)(rootReducer),
    initialState,
    composeEnhancer(applyMiddleware(...middlewares)),
  ));
};

export default store;
