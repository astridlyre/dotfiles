// Simple Script to See Crypto Prices
const fs = require('fs')
const https = require('https')

// globals to hold coin info
const baseURL = 'https://api.coingecko.com/api/v3/simple/'
const paddingLeft = ' '.repeat(5)
const ANSI = {
  green: '\u001b[32m',
  red: '\u001b[31m',
  yellow: '\u001b[0;33m',
  blue: '\u001b[1;34m',
  black: '\u001b[30m',
  boldWhite: '\u001b[1;37m',
  end: '\u001b[0;39m',
}

let coins = ''
let holdings = ''
let tickers = ''

// helper functions
const padToWidth = (str, w) => {
  while (str.length < w) str += ' '
  return str
}

const color = (c, str) => ANSI[c] + str + ANSI.end

const goodOrBad = n =>
  n > 0
    ? color('green', padToWidth(n.toFixed(2), 15))
    : color('red', padToWidth(n.toFixed(2), 15))

// printLine prints a divider
const printLine = w => console.log(color('black', paddingLeft + '-'.repeat(w)))

// does the actual printing
const printData = data => {
  const keys = coins.trim().split(',')
  const ticks = tickers.trim().split(',')
  const vals = holdings.trim().split(',').map(Number)
  let total = 0

  // Print header
  console.log('\n')
  console.log(
    paddingLeft,
    color('blue', padToWidth('Coins', 10)),
    color('blue', padToWidth('USD', 15)),
    color('blue', padToWidth('24h Change', 15)),
    color('blue', padToWidth('Hodlings', 15))
  )
  // Spacer
  printLine(55)
  for (let i = 0; i < keys.length; i++) {
    const price = Number(data[keys[i]].usd)
    const product = price * vals[i]
    const change = Number(data[keys[i]].usd_24h_change)

    // Print line
    console.log(
      paddingLeft,
      color('boldWhite', padToWidth(`${ticks[i]}`, 10)),
      color('yellow', padToWidth(`$${price}`, 15)),
      goodOrBad(change),
      color('green', padToWidth(`$${product.toFixed(2)}`, 15)),
      '\n'
    )

    // Update running total
    total += product
  }

  // Spacer
  printLine(55)

  // Print Total
  console.log(
    paddingLeft,
    padToWidth(' ', 26),
    color('blue', padToWidth('Total in USD:', 15)),
    color('boldWhite', padToWidth(`$${total.toFixed(2)}`, 15))
  )
}

// gets the coin data from coingecko
const getCoins = () => {
  // initialize the coins we are holding
  ;[coins, tickers, holdings] = fs
    .readFileSync('/home/ml/.config/coin/list', 'utf-8')
    .split('\n')

  // Make the request URL from our coins
  const reqURL = new URL(
    `price?ids=${coins}&vs_currencies=usd&include_24hr_change=true`,
    baseURL
  )

  const buffer = []

  // Make the request
  const req = https.get(reqURL.href, res => {
    res.on('data', data => buffer.push(data))
    res.on('close', () => {
      try {
        // Possible error if JSON parse fails
        printData(JSON.parse(buffer.join('').trim()))
      } catch (e) {
        console.log(e.message)
      }
    })
  })

  // Basic error handling
  req.on('error', e => console.error(e))
  req.end()
}

// do the thing
getCoins()
