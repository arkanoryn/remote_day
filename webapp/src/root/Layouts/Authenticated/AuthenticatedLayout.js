import React from 'react';
import { Layout } from 'antd';

import AuthenticatedNavbar from './AuthenticatedNavbar';
import Footer from '../Footer';

const { Content } = Layout;

const AuthenticatedLayout = ({ children }) => {
  return (
    <Layout>
      <AuthenticatedNavbar />

      <Content style={{ padding: '0 50px', marginTop: 64 }}>
        <div style={{ background: '#fff', padding: 24, marginTop: 40, minHeight: 380 }}>
          {children}
        </div>
      </Content>

      <Footer />
    </Layout>
  );
}

export default AuthenticatedLayout;
