'use strict'

angular.module('tasksjsApp').service 'taskListErrorResolver', ->
	
	@getErrorMessage = (error) ->
		if error.status is 403
			return 'Nie masz uprawnień do tej listy zadań.'
		else if error.status is 404
			return 'Lista zadań nie została znaleziona.'
		else
			return error.data.message ? 'Wystąpił nieznany błąd.'

	return @