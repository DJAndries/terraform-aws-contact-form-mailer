const { AppError } = require('./error');
const { requiredParams, optionalParams, maxOtherParamLength, maxMessageLength } = require('./env');

function validateEmail(email) {
  const re = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
  return re.test(email);
}

function validateParam(paramName, paramValue) {
  if (typeof paramName !== 'string') {
    throw new AppError(400, `${requiredParam} not provided, or is not string`);
  }
  if (paramName === 'email' && !validateEmail(paramValue)) {
    throw new AppError(400, `Email is invalid`);
  }
  if (paramName === 'message' && paramValue.length > maxMessageLength) {
    throw new AppError(400, `Message too big`);
  }
  if (paramName !== 'message' && paramValue.length > maxOtherParamLength) {
    throw new AppError(400, `${paramName} is too big`);
  }
}

function validateAndParseRequest(event) {
  if (event.httpMethod !== 'POST') {
    throw new AppError(400, 'Must be POST request');
  }

  const contentType = event.headers['Content-Type'] || event.headers['content-type'];
  if (!contentType || !contentType.startsWith('application/json')) {
    throw new AppError(400, 'Content must be JSON');
  }

  let parsedBody;
  try {
    parsedBody = JSON.parse(event.body);
  } catch (e) {
    throw new AppError(400, 'JSON parsing failed');
  }

  if (typeof parsedBody !== 'object') {
    throw new AppError(400, 'Body must be object');
  }

  const keys = Object.keys(parsedBody);
  if (keys.filter((v) => optionalParams.indexOf(v) === -1 && requiredParams.indexOf(v) === -1).length > 0) {
    throw new AppError(400, 'Unexpected parameter in request');
  }

  if (requiredParams.filter((v) => !!parsedBody[v]).length !== requiredParams.length) {
    throw new AppError(400, 'Required parameters missing');
  }

  for (const key of keys) {
    validateParam(key, parsedBody[key]);   
  }

  return parsedBody;
}

module.exports.validateAndParseRequest = validateAndParseRequest;
