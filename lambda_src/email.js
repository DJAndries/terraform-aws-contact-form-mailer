const SES = require('aws-sdk/clients/ses');
const { sender, recipient, subject, region } = require('./env');

function capitalize(val) {
  return val.substring(0, 1).toUpperCase() + val.substring(1);
}

function constructBody(content) {
  let body = '';
  for (const entry of Object.entries(content)) {
    if (entry[0] === 'message') {
      continue;
    }
    body += `${capitalize(entry[0])}: ${entry[1]}\n\n`
  }
  body += `Message: ${content.message}\n\n`
  return body;
}

async function sendEmail(content) {
  const ses = new SES({ region });
  const emailParams = {
    Source: sender,
    Destination: {
      ToAddresses: [recipient]
    },
    Message: {
      Body: {
        Text: {
          Charset: "UTF-8",
          Data: constructBody(content) 
        }
      },
      Subject: {
        Charset: "UTF-8",
        Data: subject
      }
    },
    ReplyToAddresses: [content.email]
  };
  await ses.sendEmail(emailParams).promise();
}

module.exports.sendEmail = sendEmail;
