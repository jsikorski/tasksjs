'use strict';

var express = require('express');
var controller = require('./task.controller');
var auth = require('../../auth/auth.service');

var router = express.Router();

var ensureIsCurrentUser = function(req, res, next) {
	console.log(req.user);
	if (req.user && (req.params.userId === req.user.id)) return next();
	res.send(401);
};

router.use('/users/:userId/tasks', auth.isAuthenticated());
router.use('/users/:userId/tasks', ensureIsCurrentUser);

router.get('/users/:userId/tasks', controller.index);
router.get('/users/:userId/tasks/:id', controller.show);
router.post('/users/:userId/tasks', controller.create);
router.put('/users/:userId/tasks/:id', controller.update);
router.patch('/users/:userId/tasks/:id', controller.update);
router.delete('/users/:userId/tasks/:id', controller.destroy);

module.exports = router;