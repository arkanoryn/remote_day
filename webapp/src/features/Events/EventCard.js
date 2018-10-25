import React from 'react';
import { Avatar, Card, Col } from 'antd';

const { Meta } = Card;
const BACKGROUND_IMG = 'https://static1.squarespace.com/static/56689def2399a3f0c3747e82/5759f0017c65e4182f2a88b4/'
  + '59c750fd2278e73c8274ea3b / 1506292080960 / sunset + wave.jpg ? format = 500w';

const EventCard = ({ user, comment }) => {
  return (
    <Col xs={24} sm={12} md={8} lg={8} xl={6}>
      <Card
        cover={(
          <img
            alt="simple background for the card"
            src={BACKGROUND_IMG}
            style={{ height: 40 }}
          />
        )}
      >
        <Meta
          avatar={(
            <Avatar
              src={`https://api.adorable.io/avatars/100/${user.username}.png`}
              style={{ marginTop: -44 }}
              size="large"
            />
          )}
          title={user.username}
          description={comment}
        />
      </Card>
    </Col>
  );
};

export default EventCard;
