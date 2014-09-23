'use strict';

var express = require('express');
var controller = require('./user.controller');
var config = require('../../config/environment');
var auth = require('../../auth/auth.service');

var router = express.Router();

router.get('/', auth.hasRole('admin'), controller.index);
router.delete('/:id', auth.hasRole('admin'), controller.destroy);
router.get('/me', auth.isAuthenticated(), controller.me);
router.put('/:id/password', auth.isAuthenticated(), controller.changePassword);
router.get('/:id', auth.isAuthenticated(), controller.show);
router.post('/', controller.create);

var isCurrentUser = function(req, res, next) {
	if (req.params.id === req.user._id.toString()) { return next(); }
	res.send(401);
};
router.get('/:id/task-lists', auth.isAuthenticated(), isCurrentUser, controller.showTaskLists);

module.exports = router;
