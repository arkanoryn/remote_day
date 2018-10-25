import React from 'react';
import { Col, Row } from 'antd';
import { AuthenticatedLayout } from '../../root';
import { Events } from '../../features';

const TITLE = 'Remote workers';
const { EventsTimeline } = Events;

const RemoteEvents = () => {
  return (
    <AuthenticatedLayout title={TITLE}>
      <Row>
        <Col xs={24} sm={24} md={24} lg={{ span: 20, offset: 2 }} xl={{ span: 18, offset: 3 }}>
          <EventsTimeline />
        </Col>
      </Row>
    </AuthenticatedLayout>
  );
};

export default RemoteEvents;
