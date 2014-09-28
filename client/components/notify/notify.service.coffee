"use strict"

$.growl(false, { allow_dismiss: false, placement: { align: 'center' } } );

angular.module('tasksjsApp').service 'notify', ->
	@error = (message) ->
		$.growl(message, { type: 'danger' })

	return @