import { routerMiddleware } from 'connected-react-router';
import logger from 'redux-logger';
import reduxCookiesMiddleware from 'redux-cookies-middleware';
import thunkMiddleware from 'redux-thunk';
import { cookiesPaths } from './cookies';
import history from './history';

const middlewares = [
  thunkMiddleware,
  logger,
  routerMiddleware(history),
  reduxCookiesMiddleware(cookiesPaths),
];

export default middlewares;
