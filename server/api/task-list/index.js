'use strict';

var express = require('express');
var controller = require('./task-list.controller');
var auth = require('../../auth/auth.service');

var router = express.Router();

var ensureIsCurrentUser = function(req, res, next) {
	console.log(req.user);
	if (req.user && (req.params.userId === req.user.id)) return next();
	res.send(401);
};

router.use(auth.isAuthenticated());

router.get('/', auth.hasRole('admin'), controller.index);
router.get('/:id', controller.show);
router.post('/', controller.create);
router.put('/:id', controller.update);
router.patch('/:id', controller.update);
router.delete('/:id', controller.destroy);

module.exports = router;