import React from 'react';
import { renderRoutes } from 'react-router-config';

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
    ],
  },
];

export default routes;
