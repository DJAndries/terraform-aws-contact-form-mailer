const { allowedOrigin } = require('./env');

function genHeaders(event) {
  const headers = {
    'Content-Type': 'application/json',
    'Access-Control-Allow-Headers': 'Content-Type, x-api-key',
    'Access-Control-Allow-Method': 'POST'
  };

  if (allowedOrigin !== '*') {
    const origins = allowedOrigin.split(',');
    let headerAllowedOrigin = origins[0];
    const requestOrigin = event.headers['Origin'] || event.headers['origin'];
    
    if (!!requestOrigin && origins.find((v) => v.toLowerCase() === requestOrigin.toLowerCase())) {
      // Dynamically set allow-origin based on request origin
      headerAllowedOrigin = requestOrigin;
    }

    headers['Access-Control-Allow-Origin'] = headerAllowedOrigin;
    headers['Vary'] = 'Origin';
  }
  return headers;
}

module.exports = genHeaders;
