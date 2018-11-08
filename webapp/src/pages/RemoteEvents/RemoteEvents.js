import React from 'react';
import { connect } from 'react-redux';
import { Button, Col, Row } from 'antd';
import { compose, withHandlers } from 'recompose';
import { graphql } from 'react-apollo';
import moment from 'moment';

import { eventsOperations } from '../../apollo_operations';
import { AuthenticatedLayout } from '../../root';
import { Events } from '../../features';

const TITLE = 'Remote workers';
const { EventsTimeline } = Events;

const handleSubmit = ({ createEventMutation }) => {
  return (variables) => {
    return createEventMutation({
      variables,
      refetchQueries: [{
        query:     eventsOperations.fetchEvents,
        variables: { startingDate: moment().format('YYYY-MM-DD'), limit: 7 },
      }],
    })
      // .then(({ data: { createEvent } }) => {
      .then(() => {
        return true;
      })
      .catch(() => {
        return false;
      });
  };
};

const my_random = (max = 1000, min = 0) => {
  return Math.floor(Math.random() * (max - min + 1)) + min;
};

const AddButton = ({ handleClick = () => { } }) => {
  const variables = {
    userId: my_random(),
    kind:   Math.random() % 2 === 0 ? 'day' : 'partial',
    date:   moment().add(Math.random() % 7, 'days').format('YYYY-MM-DD'),
  };

  return (
    <Button
      type="primary"
      shape="circle"
      icon="plus"
      onClick={() => { handleClick(variables); }}
    />
  );
};

const actions = (addEventClick) => {
  return [
    <AddButton
      key="add_event"
      handleClick={(variables) => { addEventClick(variables); }}
    />,
  ];
};

const RemoteEvents = ({ handleOnClick }) => {
  return (
    <AuthenticatedLayout title={TITLE} actions={actions(handleOnClick)}>
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
