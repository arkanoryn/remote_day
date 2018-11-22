import React from 'react';
import { Button, Card, Col, Layout, Row } from 'antd';
import { isEmpty } from 'lodash';
import { connect } from 'react-redux';
import { goBack as goBackAction } from 'connected-react-router';

import Footer from '../Footer';

const { Content } = Layout;

const AlreadyLoggedIn = ({ goBack }) => {
  return (
    <Row>
      <Col xs={24} sm={24} md={{ span: 20, offset: 2 }} lg={{ span: 12, offset: 6 }} xl={{ span: 6, offset: 8 }}>
        <Card
          bordered={false}
          style={{ minHeight: 380 }}
          title="You are already logged in."
        >
          <Button type="primary" onClick={() => { goBack(); }}>
            Go back
          </Button>
        </Card>
      </Col>
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
