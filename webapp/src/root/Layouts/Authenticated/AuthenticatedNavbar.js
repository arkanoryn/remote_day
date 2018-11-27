import React from 'react';
import { Col, Dropdown, Menu, Layout, Row, Icon } from 'antd';
import { compose } from 'recompose';
import { connect } from 'react-redux';
import { map } from 'lodash';
import { push as pushAction } from 'connected-react-router';
import { withCookies } from 'react-cookie';

import { paths } from '../..';
import { Gravatar } from '../../../components';
import { Authentication } from '../../../features';

const { actions } = Authentication;
const { Header } = Layout;
const { Item } = Menu;

const LIST_REMOTE = paths.REMOTE_EVENTS_PATH;

const MENU_ITEMS = [
  {
    icon:   'team',
    title:  'Remote workers',
    action: LIST_REMOTE,
  },
  {
    icon:    'stop',
    title:   'filler',
    action:  'tmp',
    options: { disabled: true },
  },
];

const handleLogoutClick = (push, cookies, logout) => {
  logout(cookies);
  push(paths.LOGIN_PATH);
};

const handleMenuClick = ({ key }, clickActions) => {
  switch (key) {
    case LIST_REMOTE:
      clickActions.push(paths.REMOTE_EVENTS_PATH);
      break;

    default:
      return false;
  }
  return true;
};


const menu = (items, clickActions) => {
  return (
    <Menu
      theme="dark"
      mode="horizontal"
      style={{ lineHeight: '64px' }}
      onClick={(args) => { return handleMenuClick(args, clickActions); }}
    >
      {
        map(
          items,
          ({ action, icon, title, options = {} }) => {
            return (
              <Item {...options} key={action}>
                <Icon type={icon} />
                {' '}
                {title}
              </Item>
            );
          },
        )
      }
    </Menu>
  );
};

const RightMenu = ({ username, email, push, cookies, logout }) => {
  const insideMenu = (
    <Menu onClick={({ key }) => { if (key === 'logout') { handleLogoutClick(push, cookies, logout); } }}>
      <Item key="sign as" disabled>{username}</Item>
      <Item key="logout">
        <Icon type="logout" />
        Logout
      </Item>
    </Menu>
  );

  return (
    <div>
      <Dropdown overlay={insideMenu}>
        <div style={{ color: '#fff' }}>
          <Gravatar email={email} size="small" style={{ marginTop: 0, marginRight: 5 }} />
          <Icon type="down" />
        </div>
      </Dropdown>
    </div>
  );
};


const AuthenticatedNavbar = (props) => {
  const { push } = props;
  const clickActions = { push };

  return (
    <Header style={{ position: 'fixed', zIndex: 1, width: '100%' }}>
      <Row>
        <Col xs={20} sm={20} md={20} lg={16} xl={18} xxl={20}>
          {menu(MENU_ITEMS, clickActions)}
        </Col>

        <div style={{ textAlign: 'right' }}>
          <Col span={4} style={{ textAlign: 'right' }}>
            <RightMenu {...props} />
          </Col>
        </div>
      </Row>
    </Header>
  );
};

const mapStateToProps = ({ authentication: { user } }) => {
  return {
    username: user.username || '',
    email:    user.email || '',
  };
};

const mapDispatchToProps = {
  logout: actions.logout,
  push:   pushAction,
};

const enhance = compose(
  connect(mapStateToProps, mapDispatchToProps),
);

export default withCookies(enhance(AuthenticatedNavbar));
