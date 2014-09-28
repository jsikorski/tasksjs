'use strict';

var mongoose = require('mongoose'),
    Schema = mongoose.Schema,
    _ = require('lodash');


var TaskSchema = new Schema({
	name: String,
	isFinished: { type: Boolean, default: false }
});

TaskSchema
	.path('name')
	.validate(function(name) { 
		return name.length; 
	}, 'Name cannot be blank');


var TaskListSchema = new Schema({
  name: String,
  tasks: [ TaskSchema ],
  owner: { type: Schema.Types.ObjectId, ref: 'User' },
  permittedUsers: [ { type: Schema.Types.ObjectId, ref: 'User' } ]
});

TaskListSchema
	.path('name')
	.validate(function(name) { 
		return name.length; 
	}, 'Name cannot be blank');

TaskListSchema.methods.isPermittedFor = function(userId) {
	return this.owner.equals(userId) || _.some(this.permittedUsers, function(user) { return user._id.equals(userId); });
};


module.exports = mongoose.model('TaskList', TaskListSchema);