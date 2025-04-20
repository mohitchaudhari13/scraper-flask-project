const puppeteer = require('puppeteer');
const fs = require('fs');

const url = process.env.SCRAPE_URL || 'https://example.com';

(async () => {
  const browser = await puppeteer.launch({
    headless: true,
    args: ['--no-sandbox']
  });
  const page = await browser.newPage();
  await page.goto(url);

  const title = await page.title();
  const heading = await page.$eval('h1', el => el.textContent);

  const data = { title, heading };
  fs.writeFileSync('scraped_data.json', JSON.stringify(data, null, 2));

  await browser.close();
})();
