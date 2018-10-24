import { applyMiddleware, compose, createStore } from 'redux';
import { connectRouter } from 'connected-react-router';
import middlewares from './middlewares';
import rootReducer from './rootReducer';
import history from './history';

// eslint-disable-next-line no-underscore-dangle
const composeEnhancer = window.__REDUX_DEVTOOLS_EXTENSION_COMPOSE__ || compose;

const store = createStore(
  connectRouter(history)(rootReducer),
  composeEnhancer(applyMiddleware(...middlewares)),
);

export default store;
