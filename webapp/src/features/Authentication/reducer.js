const AUTHENTICATE = 'AUTHENTICATE_IN_PROGRESS';
const AUTHENTICATE_SUCCESS = 'AUTHENTICATE_SUCCESS';
const AUTHENTICATE_FAILURE = 'AUTHENTICATE_FAILURE';

const authenticate = (remember) => {
  return { type: AUTHENTICATE, remember };
};

const authenticationSuccessful = (token) => {
  return { type: AUTHENTICATE_SUCCESS, token };
};

const authenticationFailure = (errors) => {
  return { type: AUTHENTICATE_FAILURE, errors };
};

const initialState = {
  errors:                   [],
  token:                    null,
  authenticationInProgress: false,
  remember:                 false,
};

const authenticationReducer = (state = initialState, action) => {
  switch (action.type) {
    case AUTHENTICATE:
      return ({
        ...state,
        remember:                 action.remember,
        errors:                   [],
        token:                    null,
        authenticationInProgress: true,
      });

    case AUTHENTICATE_SUCCESS:
      return ({
        ...state,
        errors:                   [],
        token:                    action.token,
        authenticationInProgress: false,
      });

    case AUTHENTICATE_FAILURE:
      return ({
        ...state,
        errors:                   action.errors,
        token:                    null,
        authenticationInProgress: false,
      });

    default:
      return state;
  }
};

export default authenticationReducer;
export {
  authenticate,
  authenticationSuccessful,
  authenticationFailure,
};
