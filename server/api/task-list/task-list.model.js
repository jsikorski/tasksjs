'use strict';

var mongoose = require('mongoose'),
    Schema = mongoose.Schema;


var TaskSchema = new Schema({
	name: String,
	isFinished: Boolean
});

TaskSchema
	.path('name')
	.validate(function(name) { 
		return name.length; 
	}, 'Name cannot be blank');


var TaskListSchema = new Schema({
  name: String,
  userIds: [ Schema.Types.ObjectId ],
  tasks: [ TaskSchema ]
});

TaskListSchema
	.path('name')
	.validate(function(name) { 
		return name.length; 
	}, 'Name cannot be blank');


module.exports = mongoose.model('TaskList', TaskListSchema);