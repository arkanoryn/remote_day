import React from 'react';
import { Avatar, Card, Col } from 'antd';

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
            <Avatar
              src={`https://api.adorable.io/avatars/100/${user.userId}.png`}
              style={{ marginTop: -44 }}
              size="large"
            />
          )}
          title={`${user.userId}`}
          description={comment || 'NC'}
        />
      </Card>
    </Col>
  );
};

export default EventCard;
