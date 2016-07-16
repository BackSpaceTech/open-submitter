exports.name = 'backlinksindexer.com'
exports.steps = [
  {
    command: 'open'
    url: 'http://backlinksindexer.com/wp-login.php'
    confirm: '#user_login'
  }
  {
    command: 'login-indexer'
    form: '#loginform'
    username: '#user_login'
    password: '#user_pass'
    submit: false
  }
  {
    command: 'click'
    selector: '#wp-submit'
    confirmtxt: 'Log out'
  }
  {
    command: 'open'
    url: 'http://backlinksindexer.com/dashboard/'
    confirm: '#url-textarea'
  }
  {
    command: 'backlinks'
    selector: '#url-textarea'
  }
  {
    command: 'click'
    selector: '#submit_add'
    confirm: '.alert-success'
  }
]
