import React from 'react';
import { Card, Col, notification, Row } from 'antd';
import { compose, withHandlers } from 'recompose';
import { connect } from 'react-redux';
import { graphql } from 'react-apollo';
import { isEmpty } from 'lodash';

import { UnauthenticatedLayout } from '../../root';
import { Authentication } from '../../features';
import { authenticationOperations } from '../../apollo_operations';

const { LoginForm, actions } = Authentication;

const handleSubmit = ({ authenticationMutation, authenticate, authenticationSuccessful, authenticationFailure }) => {
  return (variables) => {
    authenticate(variables.remember);
    return authenticationMutation({
      variables,
      refetchQueries: [],
    })
      .then(({ data: { authenticate: authenticationResults } }) => {
        authenticationSuccessful(authenticationResults.token, authenticationResults.user);
        notification.success({ message: 'Successfully logged in.' });
        return true;
      })
      .catch((e) => {
        authenticationFailure(e);
        notification.error({ message: 'An error occured. :(' });
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
};

const enhance = compose(
  graphql(authenticationOperations.authenticate, { name: 'authenticationMutation' }),
  connect(mapStateToProps, mapDispatchToProps),
  withHandlers({ onSubmit: handleSubmit }),
);

export default enhance(Login);
