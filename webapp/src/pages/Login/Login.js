import React from 'react';
import { connect } from 'react-redux';
import { Card, Col, Row } from 'antd';
import { UnauthenticatedLayout } from '../../root';
import { Authentication } from '../../features';

const { LoginForm, actions } = Authentication;

const Login = ({ authenticate }) => {
  const onSubmit = (values) => {
    authenticate(values.remember);
  };

  return (
    <UnauthenticatedLayout>
      <Row>
        <Col xs={24} sm={24} md={{ span: 20, offset: 2 }} lg={{ span: 12, offset: 6 }} xl={{ span: 6, offset: 8 }}>
          <Card title="Login">
            <LoginForm onSubmit={onSubmit} />
          </Card>
        </Col>
      </Row>
    </UnauthenticatedLayout>
  );
};

const mapStateToProps = ({ authentication }) => {
  return ({ authentication });
};

const mapDispatchToProps = { authenticate: actions.authenticate };

export default connect(mapStateToProps, mapDispatchToProps)(Login);
