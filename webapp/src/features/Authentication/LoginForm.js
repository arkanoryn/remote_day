import React from 'react';
import { Form, Icon } from 'antd';

import { FormItems } from '../../components';

const { decorators, FormItemCheckbox, FormItemInput, FormItemSubmitButton } = FormItems;
const USERNAME_STR = 'Username';

const handleSubmit = (e, form, onSubmit) => {
  e.preventDefault();
  form.validateFields((err, values) => {
    if (!err) {
      onSubmit(values);
    }
  });
};

const WrappedLoginForm = ({ form, onSubmit }) => {
  const { getFieldDecorator } = form;

  return (
    <Form onSubmit={(e) => { return (handleSubmit(e, form, onSubmit)); }} className="login-form">
      <FormItemInput
        id="username"
        decorator={decorators.requiredDecorator()}
        getFieldDecorator={getFieldDecorator}
        customInputProps={{
          prefix:      (<Icon type="user" style={{ color: 'rgba(0,0,0,.25)' }} />),
          placeholder: USERNAME_STR,
        }}
      />

      <FormItemInput
        id="password"
        decorator={decorators.requiredDecorator()}
        getFieldDecorator={getFieldDecorator}
        customInputProps={{
          prefix:      (<Icon type="lock" style={{ color: 'rgba(0,0,0,.25)' }} />),
          placeholder: 'Password',
          type:        'password',
        }}
      />

      <FormItemCheckbox id="remember" getFieldDecorator={getFieldDecorator}>
        Remember me
      </FormItemCheckbox>

      <FormItemSubmitButton />
    </Form>
  );
};

const LoginForm = Form.create()(WrappedLoginForm);
export default LoginForm;
