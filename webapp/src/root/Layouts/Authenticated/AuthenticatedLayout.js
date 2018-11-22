import React from 'react';
import { Alert, Button, Card, Layout, Col, Row } from 'antd';
import { map, isEmpty } from 'lodash';
import { connect } from 'react-redux';
import { push as pushAction } from 'connected-react-router';

import AuthenticatedNavbar from './AuthenticatedNavbar';
import { paths } from '../..';
import Footer from '../Footer';

const { Content } = Layout;

const Unauthorized = ({ push }) => {
  return (
    <Row type="flex" justify="center" align="middle">
      <Alert
        message="Unauthorized access"
        description={(
          <div style={{ padding: 10 }}>
            You need to be logged in in order to access this page.

            <div>
              <Button onClick={() => { push(paths.LOGIN_PATH); }} style={{ float: 'right', marginTop: 10 }}>
                Go to login
              </Button>
            </div>
          </div>
        )}
        type="warning"
        showIcon
        style={{ minWidth: 400, marginTop: 100 }}
      />
    </Row>
  );
};

const AuthenticatedLayout = ({ push, isLoggedIn, children, title, actions = [] }) => {
  if (!isLoggedIn) {
    return <Unauthorized push={push} />;
  }

  return (
    <Layout>
      <AuthenticatedNavbar />

      <Content style={{ padding: '0 50px', marginTop: 64 }}>
        <Row style={{ marginTop: 18 }}>
          <Col span="24">
            <Card
              style={{ minHeight: 380 }}
              title={title}
              extra={map(actions, (a) => { return a; })}
            >
              {children}
            </Card>
          </Col>
        </Row>
      </Content>

      <Footer />
    </Layout>
  );
};

const mapStateToProps = ({ authentication: { token } }) => {
  return { isLoggedIn: !isEmpty(token) };
};

const mapDispatchToProps = { push: pushAction };

export default connect(mapStateToProps, mapDispatchToProps)(AuthenticatedLayout);
