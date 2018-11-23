import React from 'react';
import { Avatar } from 'antd';
import md5 from 'js-md5';

const adorableUrl = (hash) => {
  return `https://api.adorable.io/avatars/100/${hash}.png`;
};

const gravatarUrl = (email) => {
  const hash = md5(email);
  const encodedAdorableUrl = encodeURI(adorableUrl(hash));

  return `https://www.gravatar.com/avatar/${hash}?d=${encodedAdorableUrl}`;
};

const Gravatar = ({ email, ...props }) => {
  return (
    <Avatar
      src={gravatarUrl(email)}
      style={{ marginTop: -44 }}
      size="large"
      {...props}
    />
  );
};

export default Gravatar;
