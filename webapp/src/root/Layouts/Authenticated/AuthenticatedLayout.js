import React from 'react';
import { Card, Layout, Col, Row } from 'antd';

import AuthenticatedNavbar from './AuthenticatedNavbar';
import Footer from '../Footer';

const { Content } = Layout;

const AuthenticatedLayout = ({ children, title }) => {
  return (
    <Layout>
      <AuthenticatedNavbar />

      <Content style={{ padding: '0 50px', marginTop: 64 }}>
        <Row style={{ marginTop: 18 }}>
          <Col span="24">
            <Card style={{ minHeight: 380 }} title={title}>
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
