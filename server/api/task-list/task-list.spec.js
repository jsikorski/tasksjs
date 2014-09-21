'use strict';

var should = require('should');
var app = require('../../app');
var request = require('supertest');

describe('GET /api/task-lists', function() {

  it('should respond with 401 for not logged in user', function(done) {
    request(app)
      .get('/api/task-lists')
      .expect(401)
      .end(done)
  });
});

describe('GET /api/task-lists/:taskListId', function() {

  it('should respond with 401 for not logged in user', function(done) {
    request(app)
      .get('/api/task-lists/1')
      .expect(401)
      .end(done)
  });
});

describe('POST /api/task-lists', function() {

  it('should respond with 401 for not logged in user', function(done) {
    request(app)
      .post('/api/task-lists')
      .expect(401)
      .end(done)
  });
});

describe('PUT /api/task-lists', function() {

  it('should respond with 401 for not logged in user', function(done) {
    request(app)
      .put('/api/task-lists')
      .expect(401)
      .end(done)
  });
});

describe('PATCH /api/task-lists', function() {

  it('should respond with 401 for not logged in user', function(done) {
    request(app)
      .patch('/api/task-lists')
      .expect(401)
      .end(done)
  });
});

describe('DELETE /api/task-lists/:taskListId', function() {

  it('should respond with 401 for not logged in user', function(done) {
    request(app)
      .delete('/api/task-lists/1')
      .expect(401)
      .end(done)
  });
});