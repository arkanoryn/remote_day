import { combineReducers } from 'redux';
import { Authentication } from '../features';

const { authenticationReducer } = Authentication;

const rootReducer = combineReducers({ authenticationReducer });

export default rootReducer;
