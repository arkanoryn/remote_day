import React from 'react';
import { Form, Checkbox } from 'antd';
import styles from './styles';

const FormItem = Form.Item;
const fluidFormItemLayout = styles;
const defaultFormItemProps = {
  ...fluidFormItemLayout,
  label: false,
};

const defaultInputProps = { size: 'large' };

const defaultDecorator = {
  valuePropName: 'checked',
  initialValue:  true,
};

const FormItemCheckbox = ({
  id, getFieldDecorator, children,
  decorator = defaultDecorator, customInputProps = {}, customFormItemProps = {},
}) => {
  const formItemProps = { ...defaultFormItemProps, ...customFormItemProps };
  const checkboxProps = { ...defaultInputProps, ...customInputProps };

  return (
    <FormItem {...formItemProps}>
      {
        getFieldDecorator(id, decorator)(
          <Checkbox {...checkboxProps}>
            {children}
          </Checkbox>,
        )
      }
    </FormItem>
  );
};

export default FormItemCheckbox;
