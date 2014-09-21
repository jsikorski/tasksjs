/**
 * Broadcast updates to client when the model changes
 */

'use strict';

var TaskList = require('./task-list.model');

exports.register = function(socket) {
  TaskList.schema.post('save', function (doc) {
    onSave(socket, doc);
  });
  TaskList.schema.post('remove', function (doc) {
    onRemove(socket, doc);
  });
}

function onSave(socket, doc, cb) {
  socket.emit('task-list:save', doc);
}

function onRemove(socket, doc, cb) {
  socket.emit('task-list:remove', doc);
}