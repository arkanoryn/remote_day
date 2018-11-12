import { combineReducers } from 'redux';
import { Authentication, Events } from '../features';

const { authenticationReducer } = Authentication;
const { eventsReducer } = Events;

const rootReducer = combineReducers({
  authentication: authenticationReducer,
  events:         eventsReducer,
});

export default rootReducer;
