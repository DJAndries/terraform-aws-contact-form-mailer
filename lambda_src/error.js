const genHeaders = require('./headers');

class AppError extends Error {
  constructor(statusCode, msg) {
    super();
    this.statusCode = statusCode;
    this.msg = msg;
  }
}

module.exports.AppError = AppError;

module.exports.processError = function processError(e, event) {
  if (e instanceof AppError) {
    console.error(e.msg);
    return {
      statusCode: e.statusCode,
      headers: genHeaders(event),
      body: JSON.stringify({ message: e.msg })
    };
  }
  throw e;
}
