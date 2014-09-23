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
  TaskList.findById(req.params.id, function (err, taskList) {
    if(err) { return handleError(res, err); }
    if(!taskList) { return res.send(404); }
    if (!_.some(taskList.userIds, function(id) { return id.equals(req.user._id); })) { 
      return res.send(401);
    }
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
    taskList.name = req.body.name;
    taskList.tasks = req.body.tasks;
    taskList.userIds = req.body.userIds;
    if (!_.some(taskList.userIds, function(id) { return id.equals(req.user._id); })) { 
      taskList.userIds.push(req.user._id);
    }

    taskList.save(function (err) {
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