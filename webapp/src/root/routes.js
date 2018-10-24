import React from 'react';
import { renderRoutes } from 'react-router-config';

import { UnauthenticatedLayout, AuthenticatedLayout } from '.';

const Root = ({ route }) => {
  return (
    <div>
      {renderRoutes(route.routes)}
    </div>
  );
};

const Home = () => {
  return (
    <AuthenticatedLayout>
      <h2>Home</h2>
    </AuthenticatedLayout>
  );
};

const routes = [
  {
    component: Root,
    routes: [
      {
        path: '/',
        exact: true,
        component: Home,
      },
    ],
  },
];

export default routes;
