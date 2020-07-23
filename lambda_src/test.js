const { handler } = require('./index');
const testEvent = require('./test_event.json');

handler(testEvent, null).then((result) => {
  console.log(result);
}, (e) => {
  console.error(e);
});
