const AUTHENTICATE = 'AUTHENTICATE_IN_PROGRESS';
const AUTHENTICATE_SUCCESS = 'AUTHENTICATE_SUCCESS';
const AUTHENTICATE_FAILURE = 'AUTHENTICATE_FAILURE';
const LOGOUT = 'AUTHENTICATION/LOGOUT';

const authenticate = (remember) => {
  return { type: AUTHENTICATE, remember };
};

const authenticationSuccessful = (token, user) => {
  return { type: AUTHENTICATE_SUCCESS, token, user };
};

const authenticationFailure = (errors) => {
  return { type: AUTHENTICATE_FAILURE, errors };
};

const logout = (cookies) => {
  cookies.set('token', '');
  cookies.set('user', {});

  return ({ type: LOGOUT });
};

const initialState = {
  authenticationInProgress: false,
  errors:                   [],
  remember:                 false,
  token:                    null,
  user:                     {},
};

const authenticationReducer = (state = initialState, action) => {
  switch (action.type) {
    case AUTHENTICATE: {
      const { remember } = action;

      return ({
        ...state,
        authenticationInProgress: true,
        errors:                   [],
        remember,
        token:                    null,
        user:                     {},
      });
    }

    case AUTHENTICATE_SUCCESS: {
      const { token, user } = action;

      return ({
        ...state,
        authenticationInProgress: false,
        errors:                   [],
        token,
        user,
      });
    }

    case AUTHENTICATE_FAILURE: {
      return ({
        ...state,
        authenticationInProgress: false,
        errors:                   action.errors,
        token:                    null,
        user:                     {},
      });
    }

    case LOGOUT: {
      return ({
        ...state,
        ...initialState,
      });
    }

    default:
      return state;
  }
};

export default authenticationReducer;
export {
  authenticate,
  authenticationSuccessful,
  authenticationFailure,
  logout,
};
