import React from 'react';
import { connect } from 'react-redux';
import { Card, Timeline, Row } from 'antd';
import { groupBy, map, sortBy } from 'lodash';
import moment from 'moment';
import { withRouter } from 'react-router-dom';
import { graphql } from 'react-apollo';
import { compose } from 'recompose';

import EventCard from './EventCard';
import { Apollo } from '../../components';
import { eventsOperations } from '../../apollo_operations';

const { Item: TimeItem } = Timeline;
const { displayErrorState, displayLoadingState } = Apollo;

const CALENDAR_FORMAT = {
  sameDay:  '[Today]',
  nextDay:  '[Tomorrow]',
  nextWeek: 'dddd',
  lastDay:  '[Yesterday]',
  lastWeek: '[Last] dddd',
  sameElse: 'DD/MM/YYYY',
};

const EventsTimeline = ({ data: { allEvents: events } }) => {
  const sortedEvents = sortBy(events, (a) => { return (moment(a.date)); });
  const groupedEvents = groupBy(sortedEvents, 'date');

  return (
    <Timeline>
      {
        map(groupedEvents, (group, date) => {
          return (
            <TimeItem key={`${moment(date).calendar(null, CALENDAR_FORMAT)}`}>
              <Card title={moment(date).calendar(null, CALENDAR_FORMAT)} type="inner">
                <Row gutter={16}>
                  {
                    map(group, ({ id, kind, user }) => {
                      return (
                        <EventCard
                          key={`${date}-${id}`}
                          kind={kind}
                          user={{ username: 'John Doe', email: 'psormani@avarteq.de' }}
                        />
                      );
                    })
                  }
                </Row>
              </Card>
            </TimeItem>
          );
        })
      }
    </Timeline>
  );
};

const fetchEventsOptions = {
  options: ({ fetchEventsVariables }) => {
    return {
      name:      'fetchEvents',
      variables: fetchEventsVariables,
    };
  },
};

const mapStateToProps = ({ events: { fetchEventsVariables } }) => {
  return { fetchEventsVariables };
};

const enhance = compose(
  connect(mapStateToProps, {}),
  graphql(eventsOperations.fetchEvents, fetchEventsOptions),
  withRouter,
  displayLoadingState,
  displayErrorState,
);

export default enhance(EventsTimeline);
