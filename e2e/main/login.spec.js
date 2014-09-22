'use strict';

describe('Login View', function() {
  var page;

  beforeEach(function() {
    browser.get('/login');
    page = require('./login.po');
  });

  it('should include login form', function() {
    expect(page.form).toBeDefined();
    expect(page.emailInput).toBeDefined();
    expect(page.passwordInput).toBeDefined();
  });
});
