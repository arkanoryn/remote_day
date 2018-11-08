import React from 'react';
import { Card, Timeline, Row } from 'antd';
import { groupBy, map, sortBy } from 'lodash';
import moment from 'moment';
import { withRouter } from 'react-router-dom';
import { graphql } from 'react-apollo';
import { compose } from 'recompose';

import EventCard from './EventCard';
import { eventsOperations } from '../../apollo_operations';

const { Item: TimeItem } = Timeline;

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
                    map(group, ({ id, kind, userId }) => {
                      return (
                        <EventCard
                          key={`${date}-${id}`}
                          kind={kind}
                          user={{ userId }}
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
  options: () => {
    return {
      name:      'fetchEvents',
      variables: { startingDate: moment().format('YYYY-MM-DD'), limit: 7 },
    };
  },
};

const enhance = compose(
  graphql(eventsOperations.fetchEvents, fetchEventsOptions),
  withRouter,
);

export default enhance(EventsTimeline);
