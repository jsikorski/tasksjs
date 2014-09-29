/**
 * Main application routes
 */

'use strict';

var errors = require('./components/errors');
var config = require('./config/environment');
var version = require(config.root + '/package.json').version;

module.exports = function(app) {

  // Insert routes below
  app.use('/api/task-lists', require('./api/task-list'));
  app.use('/api/users', require('./api/user'));

  app.use('/auth', require('./auth'));

  app.get('/version', function(req, res) {
    res.send(version);
  });
  
  // All undefined asset or api routes should return a 404
  app.route('/:url(api|auth|components|app|bower_components|assets)/*')
   .get(errors[404]);

  // All other routes should redirect to the index.html
  app.route('/*')
    .get(function(req, res) {
      res.sendfile(app.get('appPath') + '/index.html');
    });
};
