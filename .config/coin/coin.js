// Simple Script to See Crypto Prices
const fs = require('fs')
const https = require('https')

// global constants
const BASE_URL = 'https://api.coingecko.com/api/v3/simple/'
const URL_OPTIONS = '&vs_currencies=usd&include_24hr_change=true'
const PADDING_LEFT = ' '.repeat(5)
const ANSI = {
  green: '\u001b[32m',
  red: '\u001b[31m',
  yellow: '\u001b[0;33m',
  blue: '\u001b[1;34m',
  black: '\u001b[30m',
  boldWhite: '\u001b[1;37m',
  end: '\u001b[0;39m',
}

// global variables holding our coin info
let coins = ''
let holdings = ''
let tickers = ''

// ---------------------------------------------------------

// helper functions
const padToWidth = (str, w) => {
  while (str.length < w) str += ' '
  return str
}

// color wraps a string in ANSI color codes
const color = (c, str) => ANSI[c] + str + ANSI.end

// goodOrBad returns a green string if price goes up and red if it goes down
const goodOrBad = n =>
  n > 0
    ? color('green', padToWidth(n.toFixed(2), 15))
    : color('red', padToWidth(n.toFixed(2), 15))

// printDivider prints a divider
const printDivider = w =>
  console.log(color('black', PADDING_LEFT + '-'.repeat(w)))

// printLine prints a line
const printLine = (...options) => console.log(PADDING_LEFT, ...options)

// ---------------------------------------------------------

// does the actual printing
const printData = data => {
  // Split the strings containing our coin data
  const keys = coins.trim().split(',')
  const ticks = tickers.trim().split(',')
  const vals = holdings.trim().split(',').map(Number)
  let total = 0

  // Print header
  console.log('\n')
  printLine(
    color('blue', padToWidth('Coins', 10)),
    color('blue', padToWidth('USD', 15)),
    color('blue', padToWidth('24h Change', 15)),
    color('blue', padToWidth('Hodlings', 15))
  )

  // Divider
  printDivider(55)

  for (let i = 0; i < keys.length; i++) {
    const price = Number(data[keys[i]].usd)
    const product = price * vals[i]
    const change = Number(data[keys[i]].usd_24h_change)

    // Print line
    printLine(
      color('boldWhite', padToWidth(`${ticks[i]}`, 10)),
      color('yellow', padToWidth(`$${price}`, 15)),
      goodOrBad(change),
      color('green', padToWidth(`$${product.toFixed(2)}`, 15)),
      '\n'
    )

    // Update running total
    total += product
  }

  // Divider
  printDivider(55)

  // Print Total
  printLine(
    padToWidth(' ', 26),
    color('blue', padToWidth('Total in USD:', 15)),
    color('boldWhite', padToWidth(`$${total.toFixed(2)}`, 15)),
    '\n'
  )
}

// ---------------------------------------------------------

// gets the coin data from coingecko
const getCoins = () => {
  // initialize the coins we are holding
  const listFile = process.argv[2]
  ;[coins, tickers, holdings] = fs.readFileSync(listFile, 'utf-8').split('\n')

  // Make the request URL from our coins
  const reqURL = new URL(`price?ids=${coins}${URL_OPTIONS}`, BASE_URL)

  const buffer = []

  // Make the request
  const req = https.get(reqURL.href, res => {
    res.on('data', data => buffer.push(data))
    res.on('close', () => {
      try {
        // Possible error if JSON parse fails
        printData(JSON.parse(buffer.join('').trim()))
      } catch (e) {
        console.error(e)
      }
    })
  })

  // Basic error handling
  req.on('error', e => console.error(e))
  req.end()
}

// do the thing
getCoins()
