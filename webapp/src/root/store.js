import { applyMiddleware, compose, createStore } from 'redux';
import { getStateFromCookies } from 'redux-cookies-middleware';

import { connectRouter } from 'connected-react-router';
import { initialState as cookiesInitialState, cookiesPaths } from './cookies';
import middlewares from './middlewares';
import rootReducer from './rootReducer';
import history from './history';

// eslint-disable-next-line no-underscore-dangle
const composeEnhancer = window.__REDUX_DEVTOOLS_EXTENSION_COMPOSE__ || compose;

const initialState = getStateFromCookies(cookiesInitialState, cookiesPaths);

const store = createStore(
  connectRouter(history)(rootReducer),
  initialState,
  composeEnhancer(applyMiddleware(...middlewares)),
);

export default store;
