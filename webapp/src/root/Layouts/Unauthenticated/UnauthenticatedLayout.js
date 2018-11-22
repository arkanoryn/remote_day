import React from 'react';
import { Card, Col, Layout, Row } from 'antd';
import Footer from '../Footer';

const { Content } = Layout;

const UnauthenticatedLayout = ({ children, title }) => {
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

export default UnauthenticatedLayout;
