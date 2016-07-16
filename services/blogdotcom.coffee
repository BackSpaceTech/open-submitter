exports.name = 'blog.com'
exports.steps = [
  {
    command: 'create'
    micro: false
    noHTML: false
  }
  {
    command: 'open'
    url: 'http://blog.com/'
    confirm: '#loginform'
  }
  {
    command: 'login'
    form: '#loginform'
    username: '#user_login'
    password: '#user_pass'
    submit: true
    confirm: '#site-title'
  }
  {
    command: 'open-site'
    begin: 'http://'
    end: '.blog.com/wp-admin/post-new.php'
    confirm: '#post-body'
  }
  {
    command: 'click'
    selector: '#edButtonHTML'
  }
  {
    command: 'title'
    selector: 'input#title'
  }
  {
    command: 'wait'
    value: 1000
  }
  {
    command: 'body'
    selector: 'textarea#content'
  }
  {
    command: 'wait'
    value: 1000
  }
  {
    command: 'click'
    selector: 'input#publish'
    confirmtxt: 'Post published. '
  }
  {
    command: 'wait'
    value: 1000
  }
  {
    command: 'save-href'
    selector: '#message  p  a'
  }
  {
    command: 'click'
    selector: 'a[title="Sign Out"]'
    confirm: '#loginform'
  }
]
