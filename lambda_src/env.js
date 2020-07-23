module.exports.sender = process.env.SENDER || process.env.RECIPIENT || 'dtest@andno.org';
module.exports.recipient = process.env.RECIPIENT || 'dtest@andno.org';
module.exports.subject = process.env.SUBJECT || 'Message from your friendly mailer!';
module.exports.region = process.env.AWS_REGION || 'us-east-2'

module.exports.allowedOrigin = process.env.ALLOWED_ORIGIN || '*';

module.exports.requiredParams = process.env.REQUIRED_PARAMS ?
  process.env.REQUIRED_PARAMS.split(',') : ['name', 'email', 'message'];
module.exports.optionalParams = process.env.OPTIONAL_PARAMS ?
  process.env.OPTIONAL_PARAMS.split(',') : ['company', 'phone'];
module.exports.maxOtherParamLength = process.env.MAX_OTHER_PARAM_LENGTH ?
  parseInt(process.env.MAX_OTHER_PARAM_LENGTH) : 512;
module.exports.maxMessageLength = process.env.MAX_MESSAGE_LENGTH ?
  parseInt(process.env.MAX_MESSAGE_LENGTH) : 50000;
