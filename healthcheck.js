const http = require('http');

const apiUrl = 'http://localhost:3000/api/messageSearch?address=1234567&limit=1&page=1';

http.get(apiUrl, (res) => {
  let rawData = '';
  res.on('data', (chunk) => {
    rawData += chunk;
  });
  res.on('end', () => {
    try {
      const response = JSON.parse(rawData);
      const messages = response.messages;
      
      if (messages && messages.length > 0) {
        const timestamp = messages[0].timestamp;
        const currentTime = Math.floor(Date.now() / 1000);
        
        if (timestamp !== undefined && currentTime - timestamp <= 90) {
          console.log('Receiver OK');
          process.exit(0);
        } else {
          console.log('No heartbeat received in 90 seconds', 'RTL-SDR may not be responding');
          process.exit(1);
        }
      } else {
        console.log('No messages found', 'PagerMon or network may not be responding');
        process.exit(1);
      }
    } catch (e) {
      console.error('General error', e.message);
	  process.exit(1);
    }
  });
}).on('error', (e) => {
  console.error(`Got error: ${e.message}`);
  process.exit(1);
});
