module.exports = {
  "extends": [
    "airbnb"
  ],
  "plugins": [
    "import"
  ],
  "env": {
    "browser": true,
    "node": true,
    "jasmine": true
  },
  "globals": {
    "test": true,
    "fetch": true,
    "window": true,
    "document": true,
    "localStorage": true
  },
  "rules": {
    "react/jsx-filename-extension": [1, { "extensions": [".js", ".jsx"] }],
    "react/jsx-quotes": 0,
    "jsx-quotes": [2, "prefer-single"],
    "max-len": [2, { "code": 140 }],
    "camelcase": 0,
    "react/prop-types": 0,
    "no-param-reassign": 0,
    "jsx-a11y/href-no-hash": 0,
    "no-debugger": 0,
  }
};
