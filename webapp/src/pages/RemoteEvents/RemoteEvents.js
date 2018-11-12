import React from 'react';
import { connect } from 'react-redux';
import { Button, Col, Dropdown, Menu, notification, Row } from 'antd';
import { compose, withHandlers } from 'recompose';
import { graphql } from 'react-apollo';
import moment from 'moment';

import { eventsOperations } from '../../apollo_operations';
import { AuthenticatedLayout } from '../../root';
import { Events } from '../../features';

const TITLE = 'Remote workers';
const { EventsTimeline } = Events;
const { Item: MenuItem } = Menu;

const handleSubmit = ({ createEventMutation }) => {
  return (variables) => {
    return createEventMutation({
      variables,
      refetchQueries: [{
        query:     eventsOperations.fetchEvents,
        variables: eventsOperations.FETCH_EVENTS_DEFAULT_VARIABLES,
      }],
    })
      .then(({ data: { createEvent } }) => {
        notification.success({
          message: `Event for ${moment(createEvent.date).calendar(null, {
            sameDay:  '[today]',
            nextDay:  '[tomorrow]',
            nextWeek: 'dddd',
            lastDay:  '[yesterday]',
            lastWeek: '[last] dddd',
            sameElse: 'DD/MM/YYYY',
          })} successfully created`,
        });
        return true;
      })
      .catch((e) => {
        notification.error({ message: `An error occured. :( ${e}` });
        return false;
      });
  };
};

const my_random = (max = 1000, min = 0) => {
  return Math.floor(Math.random() * (max - min + 1)) + min;
};

const todaysVariable = {
  userId: my_random(),
  kind:   'day',
  date:   moment().format('YYYY-MM-DD'),
};

const tomorrowsVariable = {
  userId: my_random(),
  kind:   'day',
  date:   moment().add(1, 'days').format('YYYY-MM-DD'),
};

const menu = (createEventRequest) => {
  const handleMenuClick = ({ key }) => {
    if (key === 'today') {
      createEventRequest(todaysVariable);
    } else if (key === 'tomorrow') {
      createEventRequest(tomorrowsVariable);
    } else {
      // Unknown key
    }
  };

  return (
    <Menu onClick={handleMenuClick}>
      <MenuItem key="today">I make HO today</MenuItem>
      <MenuItem key="tomorrow">I will make HO tomorrow</MenuItem>
    </Menu>
  );
};

const RemoteEvents = ({ handleOnClick }) => {
  const actions = [
    <Dropdown overlay={menu(handleOnClick)}>
      <Button icon="plus" type="primary" shape="circle" />
    </Dropdown>,
  ];

  return (
    <AuthenticatedLayout title={TITLE} actions={actions}>
      <Row>
        <Col xs={24} sm={24} md={24} lg={{ span: 20, offset: 2 }} xl={{ span: 18, offset: 3 }}>
          <EventsTimeline />
        </Col>
      </Row>
    </AuthenticatedLayout>
  );
};

const mapStateToProps = () => {
  return { startLoading: true };
};
const mapDispatchToProps = {};

const enhance = compose(
  graphql(eventsOperations.createEvent, { name: 'createEventMutation' }),
  connect(mapStateToProps, mapDispatchToProps),
  withHandlers({ handleOnClick: handleSubmit }),
);

export default enhance(RemoteEvents);
