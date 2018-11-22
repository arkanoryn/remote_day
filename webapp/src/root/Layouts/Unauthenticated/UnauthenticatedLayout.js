import React from 'react';
import { Alert, Button, Card, Col, Layout, Row } from 'antd';
import { isEmpty } from 'lodash';
import { connect } from 'react-redux';
import { goBack as goBackAction } from 'connected-react-router';
import Footer from '../Footer';

const { Content } = Layout;

const AlreadyLoggedIn = ({ goBack }) => {
  return (
    <Row type="flex" justify="center" align="middle">
      <Alert
        message="Already logged in"
        description={(
          <div>
            <Button type="primary" onClick={() => { goBack(); }} style={{ float: 'right', marginTop: 24 }}>
              Go back
            </Button>
          </div>
        )}
        type="info"
        showIcon
        style={{ minWidth: 400, marginTop: 100 }}
      />
    </Row>
  );
};

const UnauthenticatedLayout = ({ children, title, isLoggedIn, goBack }) => {
  if (isLoggedIn) {
    return <AlreadyLoggedIn goBack={goBack} />;
  }

  return (
    <Layout>
      <Content style={{ padding: '0 50px', marginTop: 12 }}>
        <Row style={{ marginTop: 18 }}>
          <Col span="24">
            <Card
              style={{ minHeight: 380 }}
              title={title}
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

const mapDispatchToProps = { goBack: goBackAction };

export default connect(mapStateToProps, mapDispatchToProps)(UnauthenticatedLayout);
