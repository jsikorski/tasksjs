'use strict';

var _ = require('lodash');
var TaskList = require('./task-list.model');

// Get list of task-lists
exports.index = function(req, res) {
  TaskList.find({}, function (err, taskLists) {
    if(err) { return handleError(res, err); }
    return res.json(200, taskLists);
  });
};

// Get a single task-list
exports.show = function(req, res) {
  TaskList.findById({}, function (err, taskList) {
    if(err) { return handleError(res, err); }
    if(!taskList) { return res.send(404); }
    return res.json(taskList);
  });
};

// Creates a new task-list in the DB.
exports.create = function(req, res) {
  var taskList = _.extend({}, req.body, { userIds: [ req.user._id ] });
  TaskList.create(taskList, function(err, taskList) {
    if(err) { return handleError(res, err); }
    return res.json(201, taskList);
  });
};

// Updates an existing task-list in the DB.
exports.update = function(req, res) {
  if(req.body._id) { delete req.body._id; }
  TaskList.findById(req.params.id, function (err, taskList) {
    if (err) { return handleError(res, err); }
    if(!taskList) { return res.send(404); }
    var updated = _.merge(taskList, req.body);
    if (!_.some(updated.userIds, function(id) { return id.equals(req.user._id); })) { 
      updated.userIds.push(req.user._id);
    }

    updated.save(function (err) {
      if (err) { return handleError(res, err); }
      return res.json(200, taskList);
    });
  });
};

// Deletes a task-list from the DB.
exports.destroy = function(req, res) {
  TaskList.findById(req.params.id, function (err, taskList) {
    if(err) { return handleError(res, err); }
    if(!taskList) { return res.send(404); }
    taskList.remove(function(err) {
      if(err) { return handleError(res, err); }
      return res.send(204);
    });
  });
};

function handleError(res, err) {
  return res.send(500, err);
}