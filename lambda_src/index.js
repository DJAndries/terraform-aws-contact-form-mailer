const { processError } = require('./error');
const { validateAndParseRequest } = require('./parse');
const { sendEmail } = require('./email');
const genHeaders = require('./headers');

exports.handler =  async function(event, context) {
  const successResp = { statusCode: 200, headers: genHeaders(event) }
  if (event.httpMethod === 'OPTIONS') {
    return successResp;
  }
  try {
    console.log('Start validation');
    const content = validateAndParseRequest(event);
    console.log(`Sending email from ${content.email}`);
    await sendEmail(content);
    console.log('Email sent, responding');
    return Object.assign(successResp, { body: JSON.stringify({ message: 'Message sent' }) });
  } catch (e) {
    return processError(e, event);
  }
}

