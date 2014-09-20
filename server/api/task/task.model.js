'use strict';

var mongoose = require('mongoose'),
		Schema = mongoose.Schema;

var TaskSchema = new Schema({
	name: String,
	userIds: [ Schema.Types.ObjectId ],
	isFinished: Boolean
});

var validatePresenceOf = function(value) {
	return value && value.length;
};

TaskSchema
	.path('name')
	.validate(function(name) { 
		return name.length; 
	}, 'Name cannot be blank');

module.exports = mongoose.model('Task', TaskSchema);