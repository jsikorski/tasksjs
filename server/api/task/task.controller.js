'use strict';

var _ = require('lodash');
var Task = require('./task.model');
var _ = require('lodash');


exports.index = function(req, res) {
  Task.find({ userIds: req.params.userId }, function (err, tasks) {
    if(err) { return handleError(res, err); }
    return res.json(200, tasks);
  });
};


exports.show = function(req, res) {
  Task.findById(req.params.id, function (err, task) {
    if(err) { return handleError(res, err); }
    if(!task) { return res.send(404); }
    return res.json(task);
  });
};


exports.create = function(req, res) {
  var task = _.extend({}, req.body, { userIds: [ req.params.userId ] });
  Task.create(task, function(err, task) {
    if(err) { return handleError(res, err); }
    return res.json(201, task);
  });
};


exports.update = function(req, res) {
  if(req.body._id) { delete req.body._id; }
  Task.findById(req.params.id, function (err, task) {
    if (err) { return handleError(res, err); }
    if(!task) { return res.send(404); }
    var updated = _.merge(task, req.body);
    updated.save(function (err) {
      if (err) { return handleError(res, err); }
      return res.json(200, task);
    });
  });
};


exports.destroy = function(req, res) {
  Task.findById(req.params.id, function (err, task) {
    if(err) { return handleError(res, err); }
    if(!task) { return res.send(404); }
    task.remove(function(err) {
      if(err) { return handleError(res, err); }
      return res.send(204);
    });
  });
};


function handleError(res, err) {
  return res.send(500, err);
}