import React from 'react';
import { Card, Col } from 'antd';
import { Gravatar } from '../../components';

const { Meta } = Card;
const DAY_BACKGROUND_IMG = 'https://images.pexels.com/photos/847402/pexels-photo-847402.jpeg?auto=compress&cs'
  + '=tinysrgb&dpr=2&h=750&w=1260';
const PART_BACKGROUND_IMG = 'https://images.pexels.com/photos/604895/pexels-photo-604895.jpeg?auto=compress&cs'
  + '=tinysrgb&dpr=2&h=750&w=1260';

const EventCard = ({ user, comment, kind }) => {
  return (
    <Col xs={24} sm={24} md={12} lg={8} xl={6}>
      <Card
        style={{ marginBottom: 12 }}
        cover={(
          <img
            alt="simple background for the card"
            src={kind === 'day' ? DAY_BACKGROUND_IMG : PART_BACKGROUND_IMG}
            style={{ height: 40 }}
          />
        )}
      >
        <Meta
          avatar={(
            <Gravatar email={user.email} />
          )}
          title={`${user.username}`}
          description={comment}
        />
      </Card>
    </Col>
  );
};

export default EventCard;
