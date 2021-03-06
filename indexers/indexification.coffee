exports.name = 'indexification.com'
exports.steps = [
  {
    command: 'open'
    url: 'http://www.indexification.com/'
    confirm: '#button-login'
  }
  {
    command: 'click'
    selector: '#button-login'
    confirm: '#dialog-login'
  }
  {
    command: 'login-indexer'
    form: '#LoginForm'
    username: '#loginuser'
    password: '#loginpass'
    submit: false
  }
  {
    command: 'click'
    xpath: '(//button[@type="button"])[4]'
  }
  {
    command: 'wait'
    value: 5000
  }
  {
    command: 'open'
    url: 'http://www.indexification.com/members/addcampaign.php'
    confirm: '#links'
  }
  {
    command: 'backlinks'
    selector: '#links'
  }
  {
    command: 'click'
    selector: '#user-updateprofile'
    confirmtxt: 'Success!'
  }
]
