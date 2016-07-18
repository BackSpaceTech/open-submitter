exports.log = (msgColor, msg) ->
  colorsANSI = [
    {
      text: 'black'
      code: '\x1b[30m'
    }
    {
      text: 'red'
      code: '\x1b[31m'
    }
    {
      text: 'green'
      code: '\x1b[32m'
    }
    {
      text: 'yellow'
      code: '\x1b[33m'
    }
    {
      text: 'blue'
      code: '\x1b[34m'
    }
    {
      text: 'magenta'
      code: '\x1b[35m'
    }
    {
      text: 'cyan'
      code: '\x1b[36m'
    }
    {
      text: 'white'
      code: '\x1b[37m'
    }
  ]
  colorCode =   ''
  for i in [0...colorsANSI.length]
    if msgColor == colorsANSI[i].text
      colorCode = colorsANSI[i].code
  console.log colorCode, msg, '\x1b[0m'
