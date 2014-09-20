'use strict';

var should = require('should');
var app = require('../../app');
var request = require('supertest');

describe('GET /api/users/:userId/tasks', function() {

  it('should respond with 401 for not logged in user', function(done) {
    request(app)
      .get('/api/users/1/tasks')
      .expect(401)
      .end(done)
  });
});