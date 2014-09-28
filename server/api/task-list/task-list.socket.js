/**
 * Broadcast updates to client when the model changes
 */

'use strict';

var TaskList = require('./task-list.model');
var _ = require('lodash');

exports.register = function(socket) {
  TaskList.schema.post('save', function (doc) {
    onSave(socket, doc);
  });
  TaskList.schema.post('remove', function (doc) {
    onRemove(socket, doc);
  });
}

function onSave(socket, doc, cb) {
  if (doc.isPermittedFor(socket.decoded_token._id)) {
    socket.emit('task-list:save', doc);
  }
}

function onRemove(socket, doc, cb) {
  if (doc.isPermittedFor(socket.decoded_token._id)) {
    socket.emit('task-list:remove', doc);
  }
}