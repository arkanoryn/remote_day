import React from 'react';
import { Card, Col, notification, Row } from 'antd';
import { compose, withHandlers } from 'recompose';
import { connect } from 'react-redux';
import { graphql } from 'react-apollo';
import { isEmpty } from 'lodash';
import { withCookies } from 'react-cookie';

import { push as pushAction } from 'connected-react-router';
import { UnauthenticatedLayout, paths } from '../../root';
import { Authentication } from '../../features';
import { authenticationOperations } from '../../apollo_operations';

const { LoginForm, actions } = Authentication;

const handleSubmit = (
  {
    authenticate,
    authenticationFailure,
    authenticationMutation,
    authenticationSuccessful,
    cookies,
    push,
  },
) => {
  return (variables) => {
    authenticate(variables.remember);
    return authenticationMutation({
      variables,
      refetchQueries: [],
    })
      .then(({ data: { authenticate: authenticationResults } }) => {
        const { token, user } = authenticationResults;

        authenticationSuccessful(token, user);

        if (variables.remember) {
          cookies.set('token', token);
          cookies.set('user', user);
        } else {
          cookies.set('token', '');
          cookies.set('user', {});
        }

        notification.success({ message: 'Successfully logged in.' });
        push(paths.REMOTE_EVENTS_PATH);
        return true;
      })
      .catch((e) => {
        authenticationFailure(e);
        if (e.message === 'invalid credentials') {
          notification.error({ message: 'invalid credentials' });
        } else {
          notification.error({ message: 'An error occured. :(' });
        }
        return false;
      });
  };
};

const Login = ({ onSubmit, authenticationInProgress }) => {
  return (
    <UnauthenticatedLayout>
      <Row>
        <Col xs={24} sm={24} md={{ span: 20, offset: 2 }} lg={{ span: 12, offset: 6 }} xl={{ span: 6, offset: 8 }}>
          <Card title="Login">
            <LoginForm onSubmit={onSubmit} inProgress={authenticationInProgress} />
          </Card>
        </Col>
      </Row>
    </UnauthenticatedLayout>
  );
};

const mapStateToProps = ({ authentication: { token, authenticationInProgress } }) => {
  return ({
    authenticationInProgress,
    isLoggedIn: !isEmpty(token),
  });
};

const mapDispatchToProps = {
  authenticate:             actions.authenticate,
  authenticationSuccessful: actions.authenticationSuccessful,
  authenticationFailure:    actions.authenticationFailure,
  push:                     pushAction,
};

const enhance = compose(
  graphql(authenticationOperations.authenticate, { name: 'authenticationMutation' }),
  connect(mapStateToProps, mapDispatchToProps),
  withHandlers({ onSubmit: handleSubmit }),
);

export default withCookies(enhance(Login));
