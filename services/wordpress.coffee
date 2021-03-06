exports.name = 'wordpress'
exports.steps = [
  {
    command: 'create'
    micro: false
    noHTML: false
  }
  {
    command: 'open'
    url: 'https://wordpress.com/wp-login.php'
    confirm: '#user_login'
  }
  {
    command: 'login'
    form: '#loginform'
    username: '#user_login'
    password: '#user_pass'
    submit: true
    confirm: 'a[data-tip-target="my-sites"]'
  }
  {
    command: 'open-site'
    begin: 'https://wordpress.com/post/'
    end: ''
    confirm: '#tinymce-1'
  }
  {
    command: 'click'
    selector: 'svg.gridicon.gridicons-create'
  }
  {
    command: 'wait'
    value: 1000
  }
  {
    command: 'title'
    selector: 'textarea.textarea-autosize.editor-title__input'
  }
  {
    command: 'click'
    selector: 'a[title="Edit the raw HTML code"]'
  }
  {
    command: 'wait'
    value: 1000
  }
  {
    command: 'body'
    selector: '#tinymce-1'
  }
  {
    command: 'click'
    xpath: '//*[text()[contains(.,"Publish")]]'
    confirm: '.is-success'
  }
  {
    command: 'save-href'
    selector: 'a.notice__action'
  }
  {
    command: 'click'
    selector: 'img[class="gravatar"]'
    confirm: 'button[title="Sign out of WordPress.com"]'
  }
  {
    command: 'click'
    selector: 'button[title="Sign out of WordPress.com"]'
  }
  {
    command: 'wait'
    value: 5000
  }
]
