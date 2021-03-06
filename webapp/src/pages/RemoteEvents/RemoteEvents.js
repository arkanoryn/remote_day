import React from 'react';
import { connect } from 'react-redux';
import { Button, Col, Dropdown, Menu, notification, Row } from 'antd';
import { compose, withHandlers } from 'recompose';
import { graphql } from 'react-apollo';
import moment from 'moment';
import { filter } from 'lodash';

import { eventsOperations } from '../../apollo_operations';
import { AuthenticatedLayout } from '../../root';
import { Events } from '../../features';

const TITLE = 'Remote workers';
const { EventsTimeline, actions: eventsActions } = Events;
const { Item: MenuItem } = Menu;

const handleSubmit = ({
  createEventMutation,
  fetchEventsVariables,
  events,
  fetchEvents,
  fetchEventsSuccess,
  fetchEventsFailure,
}) => {
  return (variables) => {
    fetchEvents();

    return createEventMutation({
      variables,
      refetchQueries: [{
        query:     eventsOperations.fetchEvents,
        variables: fetchEventsVariables,
      }],
    })
      .then(({ data: { createEvent } }) => {
        fetchEventsSuccess([...events, createEvent]);
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
        fetchEventsFailure(e);
        if (filter(e.graphQLErrors, (x) => { return (x.message === 'A user can only create one event per day'); })) {
          notification.warning({ message: 'You are already marked as remote worker for this date.' });
        } else {
          notification.error({ message: 'An error occured. :(' });
        }
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

const RemoteEvents = ({ handleOnClick, isLoading }) => {
  const actions = [
    <Dropdown key="addMenu" overlay={menu(handleOnClick)}>
      <Button icon="plus" type="primary" shape="circle" loading={isLoading} />
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

const mapStateToProps = ({ events: { fetchEventsVariables, isLoading, events } }) => {
  return { fetchEventsVariables, isLoading, events };
};

const mapDispatchToProps = {
  fetchEvents:        eventsActions.fetchEvents,
  fetchEventsSuccess: eventsActions.fetchEventsSucceeded,
  fetchEventsFailure: eventsActions.fetchEventsFailed,
};

const enhance = compose(
  graphql(eventsOperations.createEvent, { name: 'createEventMutation' }),
  connect(mapStateToProps, mapDispatchToProps),
  withHandlers({ handleOnClick: handleSubmit }),
);

export default enhance(RemoteEvents);
