import React from 'react';
import { Card, Layout, Col, Row } from 'antd';
import { map } from 'lodash';

import AuthenticatedNavbar from './AuthenticatedNavbar';
import Footer from '../Footer';

const { Content } = Layout;

const AuthenticatedLayout = ({ children, title, actions = [] }) => {
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

export default AuthenticatedLayout;
