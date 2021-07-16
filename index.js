require('dotenv').config();

const fetch = require('node-fetch');
const cron = require('node-cron');

const items =  [];
const postCMCDaily = async () => {
  const response = await fetch('https://cmc-daily-api.wouterdeschuyter.be');
  const data = await response.json();

  if (items.length === 0) {
    items.push(...data);
  }

  for (const item of data) {
    if (items.includes(item)) {
      continue;
    }

    console.log(`New article: ${item}`);
    items.push(item);

    await fetch(process.env.SLACK_WEBHOOK, {
      method: 'post',
      body: JSON.stringify({
        text: `Coinmarketcap daily → ${item}`,
        unfurl_links: true,
      }),
      headers: {'Content-Type': 'application/json'}
    });
  }
};

(async () => {
  console.log('Slack bot is running!');
  await postCMCDaily();

  cron.schedule('*/15 * * * *', postCMCDaily);
})();
