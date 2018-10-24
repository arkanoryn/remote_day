import client from './apollo-client';
import history from './history';
import middlewares from './middlewares';
import rootReducer from './rootReducer';
import routes from './routes';
import store from './store';
import { AuthenticatedLayout, UnauthenticatedLayout } from './Layouts';

export {
  client,
  history,
  middlewares,
  rootReducer,
  routes,
  store,
  AuthenticatedLayout,
  UnauthenticatedLayout,
};
