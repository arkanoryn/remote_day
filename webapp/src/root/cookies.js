const cookiesPaths = {
  'authentication.token': { name: 'token' },
  'authentication.user':  { name: 'user' },
};

const initialState = { authentication: { user: {}, token: null } };

export { cookiesPaths, initialState };
