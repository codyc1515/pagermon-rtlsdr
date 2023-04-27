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
      const timestamp = response.messages[0].timestamp;
      const currentTime = Math.floor(Date.now() / 1000);
      if (currentTime - timestamp <= 90) {
		console.log('Timestamp is within the past 90 seconds');
        process.exit(0);
      } else {
        console.log('Timestamp is NOT within the past 90 seconds (either SDR is not responding or network is down)');
	    process.exit(1);
      }
    } catch (e) {
      console.error(e.message);
    }
  });
}).on('error', (e) => {
  console.error(`Got error: ${e.message}`);
  process.exit(1);
});
