import React from 'react';
import { renderRoutes } from 'react-router-config';
import { LoginPage, RemoteEventsPage } from '../pages';

const Root = ({ route }) => {
  return (
    <React.Fragment>
      {renderRoutes(route.routes)}
    </React.Fragment>
  );
};

const Home = () => {
  return (
    <div>
      <h2>Home</h2>

      you might want to visit `/remote`
    </div>
  );
};

const HOME_PATH = '/';
const LOGIN_PATH = '/login';
const REMOTE_EVENTS_PATH = '/remote';

const routes = [
  {
    component: Root,
    routes:    [
      {
        path:      HOME_PATH,
        exact:     true,
        component: Home,
      },
      {
        path:      LOGIN_PATH,
        exact:     true,
        component: LoginPage,
      },
      {
        path:      REMOTE_EVENTS_PATH,
        exact:     true,
        component: RemoteEventsPage,
      },
    ],
  },
];

export default routes;
export {
  HOME_PATH,
  LOGIN_PATH,
  REMOTE_EVENTS_PATH,
};
