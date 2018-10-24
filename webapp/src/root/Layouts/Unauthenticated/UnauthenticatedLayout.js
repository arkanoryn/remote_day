import React from 'react';
import { Layout } from 'antd';

const { Content } = Layout;

const UnauthenticatedLayout = ({ children }) => {
  return (
    <Layout>
      <Content style={{ padding: '0 50px', marginTop: 64 }}>
        <h1>Unauthenticated</h1>

        <div style={{ background: '#fff', padding: 24, minHeight: 380 }}>
          {children}
        </div>
      </Content>
    </Layout>
  );
};

export default UnauthenticatedLayout;
