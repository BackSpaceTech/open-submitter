fs = require('fs')
system = require('system')
colors = require('colors')
imports = require('./app/imports')
spinner = require('./app/spinner')
page = require('webpage').create()

casper = require('casper').create(
  pageSettings: webSecurityEnabled: false
  viewportSize: {width: 800, height: 600}
  timeout: 3600000 # 1 hour general timeout
  stepTimeout: 300000 # 5 min default step timeout
  waitTimeout: 60000  # 1 min default wait timeout
  verbose: true
  onError: (self, msg) ->
    console.log ('FATAL:' + msg).red
    self.exit()
    return
  onTimeout: (self, msg) ->
    @.capture('./capture/timeout.png')
    console.log ('general timeout error: ' + msg).red
    return
  onStepTimeout: (self, msg) ->
    @.capture('./capture/timeout.png')
    console.log ('step timeout error: step ' + msg).red
    return
  onWaitTimeout: (self, msg) ->
    @.capture('./capture/timeout.png')
    console.log ('wait timeout error: ' + msg).red
    return
)

casper.userAgent 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 ' +
  '(KHTML, like Gecko) Chrome/51.0.2704.103 Safari/537.36'

fileAccounts = './accounts/' + casper.cli.get(0) + '.csv'
fileArticles = './articles/' + casper.cli.get(1) + '.txt'
fileBacklinks = './backlinks/' + casper.cli.get(2) + '.txt'
numPosts = casper.cli.get(3)

console.log '\n'
console.log '---------------- Submission Details ----------------------'.cyan
console.log ('Accounts file: ' + fileAccounts).cyan
console.log ('Articles file: ' + fileArticles).cyan
console.log ('Backlinks saved to file: ' + fileBacklinks).cyan
console.log ('Number of Submissions: ' + numPosts).cyan

currentService = 0
currentStep = 0
submitArticle =
  title: ''
  body: ''
  keywords: ''

# Import settings
services = imports.services('./settings/services.txt')
indexerDetails = imports.indexers('./settings/indexers.txt')

# Load services
numLoops = 0
service = []
currentService = 0
for i in [0...services.length]
  if services[i].status.toLowerCase() == 'ok'
    service[currentService] = require('./services/' + services[i].name)
    numLoops += service[currentService].steps.length
    ++currentService
numLoops *= numPosts

# Load indexer
if indexerDetails.status.toLowerCase() == 'ok'
  indexer = require('./indexers/' + indexerDetails.name)

# ---------------- Import Files  ------------------------

console.log ('------------------- Import Files -------------------------')
accounts = imports.accounts(fileAccounts)
articles = imports.articles(fileArticles)

# ------------------ Utils  ------------------------

currentStep = 0
randomAccount =
  username: ''
  password: ''
  site: ''
submitArticle =
  title: ''
  body: ''
  keywords: ''
backlinksList = ''

skipService = ->
  console.log  'Skipping ' + service[currentService].name
  ++currentService
  currentStep = 0

errorMsg = ->
  console.log  'Failed step ' + currentStep
  console.log  'Check error.png file'
  skipService()

# ------------------------ Step Commands  ------------------------------

casper.doStep = (objStep, serviceName) ->
  @echo 'Step: ' + currentStep
# -------------------------- Create -------------------------------------
  if objStep.command == 'create'
    @echo 'Creating article...'
    submitArticle = spinner.getArticle(articles, objStep.micro,objStep.noHTML)
    randomAccount = spinner.getAccount(accounts, serviceName)
    str = '-------------- Submit to ' + serviceName+' ----------------'
    console.log (str).yellow
# -------------------------- Open ---------------------------------------
  else if objStep.command == 'open'
    @echo 'Opening url '+objStep.url+'...'
    @open(objStep.url).then ->
      @capture('./capture/capture' + currentStep + '.png')
      if objStep.confirm
        @waitForSelector objStep.confirm,
          ->
            @echo 'Opened url'
          ->
            errorMsg()
            @capture('./capture/error.png')
      else if objStep.confirmtxt
        @waitForText objStep.confirmtxt,
          ->
            @echo 'Opened url'
          ->
            errorMsg()
            @capture('./capture/error.png')
# -------------------------- Open Site -----------------------------------
  else if objStep.command == 'open-site'
    tempURL = objStep.begin + randomAccount.site + objStep.end
    @echo 'Opening url ' + tempURL + '...'
    @open(tempURL).then ->
      @capture('./capture/capture' + currentStep + '.png')
      if objStep.confirm
        @waitForSelector objStep.confirm,
          ->
            @echo 'Opened url'
          ->
            errorMsg()
            @capture('./capture/error.png')
      else if objStep.confirmtxt
        @waitForText objStep.confirmtxt,
          ->
            @echo 'Opened url'
          ->
            errorMsg()
            @capture('./capture/error.png')
# -------------------------- Login ----------------------------------------
  else if objStep.command == 'login'
    if randomAccount.username == 'no accounts'
      @echo 'No '+ serviceName + ' accounts!'
      skipService()
    else
      @echo 'Logging in: ' +  randomAccount.username + '...'
      # Login to WordPress with random account
      tempObj =
        formElem: objStep.form
        nameElem: objStep.username
        pwdElem: objStep.password
        name: randomAccount.username
        pwd: randomAccount.password
        submit: objStep.submit
      @evaluate ((s) ->
        document.querySelector(s.nameElem).value = s.name
        document.querySelector(s.pwdElem).value = s.pwd
        if s.submit
          document.querySelector(s.formElem).submit()
        return
      ), tempObj
      @capture('./capture/capture' + currentStep + '.png')
      @echo 'Waiting for login confirmation...'
      if objStep.submit
        @waitForSelector objStep.confirm,
          ->
            @echo 'Login success.'
          ->
            errorMsg()
            @capture('./capture/error.png')
      else if objStep.confirmtxt
        @waitForText objStep.confirmtxt,
          ->
            @echo 'Login success.'
          ->
            errorMsg()
            @capture('./capture/error.png')
# -------------------------- Login-Indexer -----------------------------------
  else if objStep.command == 'login-indexer'
    if indexer.username == 'no accounts'
      @echo 'No indexer accounts!'
    else
      @echo 'Logging in: ' +  indexerDetails.username + '...'
      # Login to Indexer
      tempObj =
        formElem: objStep.form
        nameElem: objStep.username
        pwdElem: objStep.password
        name: indexerDetails.username
        pwd: indexerDetails.password
        submit: objStep.submit
      @evaluate ((s) ->
        document.querySelector(s.nameElem).value = s.name
        document.querySelector(s.pwdElem).value = s.pwd
        if s.submit
          document.querySelector(s.formElem).submit()
        return
      ), tempObj
      @capture('./capture/indexer0.png')
      @echo 'Waiting for login confirmation...'
      if objStep.submit
        @waitForSelector objStep.confirm,
          ->
            @echo 'Login success.'
          ->
            errorMsg()
            @capture('./capture/error.png')
      else if objStep.confirmtxt
        @waitForText objStep.confirmtxt,
          ->
            @echo 'Login success.'
          ->
            errorMsg()
            @capture('./capture/error.png')
# --------------------------- Click ---------------------------------------
  if objStep.command == 'click'
    if objStep.selector
      tempObj = objStep.selector
    else if objStep.xpath
      tempObj = {
        type: 'xpath',
        path: objStep.xpath
      }
    if @exists(tempObj)
      @click tempObj
      @echo 'Clicked on DOM selector'
      if objStep.confirm
        @waitForSelector objStep.confirm,
          ->
            @echo 'Confirmed.'
          ->
            @echo 'Confirm DOM selector not found', 'ERROR'
            errorMsg()
            @capture('./capture/error.png')
      if objStep.confirmtxt
        @waitForText objStep.confirmtxt,
          ->
            @echo 'Confirmed: ' + objStep.confirmtxt
          ->
            @echo 'Confirm text not found', 'ERROR'
            errorMsg()
            @capture('./capture/error.png')
    else
      @echo 'DOM selector not found', 'ERROR'
      errorMsg()
# --------------------------- Wait ---------------------------------------
  if objStep.command == 'wait'
    @echo 'Waiting for ' + objStep.value + ' ms'
    @wait objStep.value, ->
      @echo 'Finished wait time.'
      return
# --------------------------- Title ---------------------------------------
  if objStep.command == 'title'
    if objStep.selector
      tempObj = objStep.selector
    else if objStep.xpath
      tempObj = {
        type: 'xpath',
        path: objStep.xpath
      }
    if @exists(tempObj)
      @sendKeys(tempObj, submitArticle.title)
      @echo 'Entered title'
    else
      @echo 'Input field not found', 'ERROR'
      errorMsg()
# --------------------------- Title ---------------------------------------
  if objStep.command == 'backlinks'
    if objStep.selector
      tempObj = objStep.selector
    else if objStep.xpath
      tempObj = {
        type: 'xpath',
        path: objStep.xpath
      }
    if @exists(tempObj)
      @sendKeys(tempObj, backlinksList)
      @echo 'Entered backlinks list'
    else
      @echo 'Input field not found', 'ERROR'
      errorMsg()
# --------------------------- Body ---------------------------------------
  if objStep.command == 'body'
    if objStep.selector
      tempObj = objStep.selector
    else if objStep.xpath
      tempObj = {
        type: 'xpath',
        path: objStep.xpath
      }
    if @exists(tempObj)
      @sendKeys(tempObj, submitArticle.body)
      @echo 'Entered body'
    else
      @echo 'Input field not found', 'ERROR'
      errorMsg()
# --------------------------- Save-href -----------------------------------
  if objStep.command == 'save-href'
    if objStep.selector
      tempObj = objStep.selector
    else if objStep.xpath
      tempObj = {
        type: 'xpath',
        path: objStep.xpath
      }
    if @exists(tempObj)
      submitURL = @getElementAttribute tempObj, 'href'
      backlinksList += submitURL + '\n'
      console.log ('Submitted post to URL: ' + submitURL).cyan
      # Save backlinks.txt
      try
        fs.write fileBacklinks, submitURL, 'a'
        fs.write fileBacklinks, '\n', 'a'
      catch e
        @echo e
      @echo 'Saved backlink to ' + fileBacklinks
    else
      @echo 'DOM selector not found' +tempObj, 'ERROR'
      errorMsg()

# ------------------ Submit to Services  ------------------------

currentSubmission = 0
currentService = 0
currentIndexerStep = 0
console.log 'numLoops: ' + numLoops
casper.start()
casper.repeat numLoops, ->
  @then ->
    if currentService >= service.length
      ++currentSubmission
      currentService = 0
      currentStep = 0
    if currentSubmission < numPosts
      serviceName = service[currentService].name
      objStep = service[currentService].steps[currentStep]
      @.doStep(objStep, serviceName)
      @then  ->
        @capture('./capture/capture' + currentStep + '.png')
        ++currentStep
        if currentStep == service[currentService].steps.length
          serviceName = service[currentService].name
          console.log ('Completed submit to '+serviceName + '\n').green
          ++currentService
          currentStep = 0
      return
    return

casper.repeat (indexer.steps.length + 1), ->
  @then ->
    if currentIndexerStep == indexer.steps.length
      serviceName = indexerDetails.name
      console.log ('Submitted backlinks to '+serviceName + '\n').green
    else
      if indexerDetails.status.toLowerCase() == 'ok'
        serviceName = indexerDetails.name
        objStep = indexer.steps[currentIndexerStep]
        @.doStep(objStep, serviceName)
        @capture('./capture/indexer' + currentIndexerStep + '.png')
        ++currentIndexerStep

casper.run ->
  console.log  ('Finished all submissions.').green
  @echo 'Press ctrl C to exit'
  @exit(0)
  @bypass(1)
  return
#
