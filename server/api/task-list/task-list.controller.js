'use strict';

var _ = require('lodash');
var TaskList = require('./task-list.model');
var User = require('../user/user.model');
var async = require('async');
var HttpError = require('../../components/errors/http-error');

// Get list of task-lists
exports.index = function(req, res) {
  TaskList.find({}, function (err, taskLists) {
    if(err) { return handleError(res, err); }
    return res.json(200, taskLists);
  });
};

// Get a single task-list
exports.show = function(req, res) {
  TaskList.findById(req.params.id).populate('permittedUsers').exec(function (err, taskList) {
    if(err) { return handleError(res, err); }
    if(!taskList) { return res.send(404); }
    if (!taskList.isPermittedFor(req.user._id)) { return res.send(403); }
    return res.json(taskList);
  });
};

// Creates a new task-list in the DB.
exports.create = function(req, res) {
  var taskList = _.extend({}, req.body, { owner: req.user._id });
  TaskList.create(taskList, function(err, taskList) {
    if(err) { return handleError(res, err); }
    return res.json(201, taskList);
  });
};

// Updates an existing task-list in the DB.
exports.update = function(req, res) {
  var taskList;
  if(req.body._id) { delete req.body._id; }

  async.series([
    function(callback) {
      TaskList.findById(req.params.id).populate('permittedUsers').exec(function (err, list) {
        if (err) { return callback(err); }
        if (!list) { return callback(new HttpError(404)); }
        if (!list.isPermittedFor(req.user._id)) { return callback(new HttpError(403)); }
        taskList = list;
        taskList.name = req.body.name;
        taskList.tasks = req.body.tasks;
        callback();
      });
    },

    function(callback) {
      var newUser = _.find(req.body.permittedUsers, function(user) { return !!user.email && !user._id; });
      if (!newUser) { return callback(); }
      User.findOne({ email: newUser.email }, function(err, user) {
        if (err) { return callback(err); }
        if (!user) { return callback(new HttpError(500, 'Użytkownik o podanym adresie email nie jest zarejestrowany.')); }
        if (taskList.owner.equals(user._id)) { return callback(new HttpError(500, 'Nie można udostępnić listy jej właścicielowi.')); }

        var index = req.body.permittedUsers.indexOf(newUser);
        req.body.permittedUsers.splice(index, 1);
        if (_.find(taskList.permittedUsers, { email: newUser.email })) { return callback(); }
        req.body.permittedUsers.push(user);
        callback();
      });
    },

    function(callback) {
      taskList.permittedUsers = req.body.permittedUsers;
      taskList.save(callback);
    }

  ], function(err) {
    if (err && err.status) { return res.send(err.status, err); }
    if (err) { handleError(res, err); }
    return res.json(200, taskList);
  });
};

// Deletes a task-list from the DB.
exports.destroy = function(req, res) {
  TaskList.findById(req.params.id).populate('permittedUsers').exec(function (err, taskList) {
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