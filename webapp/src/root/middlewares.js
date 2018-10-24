import logger from 'redux-logger';
import thunkMiddleware from 'redux-thunk';
import { routerMiddleware } from 'connected-react-router';
import { history } from '.';

const middlewares = [
  thunkMiddleware,
  logger,
  routerMiddleware(history),
];

export default middlewares;
