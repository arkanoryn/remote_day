import React from 'react';
import { connect } from 'react-redux';
import { withCookies } from 'react-cookie';
import { Button, Col, Menu, Layout, Row } from 'antd';
import { push as pushAction } from 'connected-react-router';

import { paths } from '../..';
import { Authentication } from '../../../features';

const { actions } = Authentication;
const { Header } = Layout;

const handleClick = (push, cookies, logout) => {
  logout(cookies);
  push(paths.LOGIN_PATH);
};

const AuthenticatedNavbar = ({ push, cookies, username, logout }) => {
  return (
    <Header style={{ position: 'fixed', zIndex: 1, width: '100%' }}>
      <Row>
        <Col span={20}>
          <Menu
            theme="dark"
            mode="horizontal"
            defaultSelectedKeys={['2']}
            style={{ lineHeight: '64px' }}
          >
            <Menu.Item key="1">nav 1</Menu.Item>
            <Menu.Item key="2">nav 2</Menu.Item>
            <Menu.Item key="3">nav 3</Menu.Item>
          </Menu>
        </Col>
        <Col span={4} style={{ textAlign: 'right' }}>
          <span style={{ color: '#fff', marginRight: 12 }}>{username}</span>
          <Button ghost icon="logout" onClick={() => { handleClick(push, cookies, logout); }}>Logout</Button>
        </Col>
      </Row>
    </Header>
  );
};

const mapStateToProps = ({ authentication: { user } }) => {
  return { username: user.username || '' };
};
const mapDispatchToProps = {
  logout: actions.logout,
  push:   pushAction,
};

export default withCookies(connect(mapStateToProps, mapDispatchToProps)(AuthenticatedNavbar));
