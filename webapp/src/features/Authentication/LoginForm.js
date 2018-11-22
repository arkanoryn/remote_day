import React from 'react';
import { Form, Icon } from 'antd';

import { FormItems } from '../../components';

const { decorators, FormItemCheckbox, FormItemInput, FormItemSubmitButton } = FormItems;
const EMAIL_STR = 'Email';

const handleSubmit = (e, form, onSubmit) => {
  e.preventDefault();
  form.validateFields((err, values) => {
    if (!err) {
      onSubmit(values);
    }
  });
};

const WrappedLoginForm = ({ form, onSubmit, inProgress }) => {
  const { getFieldDecorator } = form;

  return (
    <Form onSubmit={(e) => { return (handleSubmit(e, form, onSubmit)); }} className="login-form">
      <FormItemInput
        id="email"
        decorator={decorators.requiredDecorator()}
        getFieldDecorator={getFieldDecorator}
        customInputProps={{
          prefix:      (<Icon type="user" style={{ color: 'rgba(0,0,0,.25)' }} />),
          placeholder: EMAIL_STR,
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

      <FormItemSubmitButton buttonProps={{ loading: inProgress }} buttonText="Login" />
    </Form>
  );
};

const LoginForm = Form.create()(WrappedLoginForm);
export default LoginForm;
