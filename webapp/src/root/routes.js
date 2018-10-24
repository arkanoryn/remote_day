import React from 'react';
import { renderRoutes } from 'react-router-config';
import { LoginPage } from '../pages';

const Root = ({ route }) => {
  return (
    <div>
      {renderRoutes(route.routes)}
    </div>
  );
};

const Home = () => {
  return (
    <div>
      <h2>Home</h2>
    </div>
  );
};

const routes = [
  {
    component: Root,
    routes:    [
      {
        path:      '/',
        exact:     true,
        component: Home,
      },
      {
        path:      '/login',
        exact:     true,
        component: LoginPage,
      },
    ],
  },
];

export default routes;
