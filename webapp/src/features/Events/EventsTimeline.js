import React from 'react';
import { Card, Timeline, Row } from 'antd';
import { groupBy, map } from 'lodash';
import moment from 'moment';
import EventCard from './EventCard';

const { Item: TimeItem } = Timeline;

const CALENDAR_FORMAT = {
  sameDay:  '[Today]',
  nextDay:  '[Tomorrow]',
  nextWeek: 'dddd',
  lastDay:  '[Yesterday]',
  lastWeek: '[Last] dddd',
  sameElse: 'DD/MM/YYYY',
};

const DEFAULT = [
  { date: moment().format(), user: { username: 'John' } },
  { date: moment().format(), user: { username: 'Depp' } },
  { date: moment().add(1, 'days').format(), user: { username: 'Jane' } },
  { date: moment().add(1, 'days').format(), user: { username: 'John' } },
  { date: moment().add(2, 'days').format(), user: { username: 'Tian' } },
  { date: moment().add(2, 'days').format(), user: { username: 'John' } },
  { date: moment().add(2, 'days').format(), user: { username: 'Depp' } },
];

const EventsTimeline = ({ events = DEFAULT }) => {
  const groupedEvents = groupBy(events, 'date');

  return (
    <Timeline>
      {
        map(groupedEvents, (group, date) => {
          return (
            <TimeItem key={`${moment(date).calendar(null, CALENDAR_FORMAT)}`}>
              <Card title={moment(date).calendar(null, CALENDAR_FORMAT)} type="inner">
                <Row gutter={16}>
                  {
                    map(group, ({ user }) => { return (<EventCard key={`${date}-${user.username}`} user={user} />); })
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

export default EventsTimeline;
