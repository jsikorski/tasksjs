'use strict'

angular.module 'tasksjsApp'
.factory 'Modal', ($rootScope, $modal) ->
  
  ###
  Opens a modal
  @param  {Object} scope      - an object to be merged with modal's scope
  @param  {String} modalClass - (optional) class(es) to be applied to the modal
  @return {Object}            - the instance $modal.open() returns
  ###
  openModal = (scope, modalClass) ->
    modalScope = $rootScope.$new()
    scope = scope or {}
    modalClass = modalClass or 'modal-default'
    angular.extend modalScope, scope
    $modal.open
      templateUrl: 'components/modal/modal.html'
      windowClass: modalClass
      scope: modalScope

  
  # Public API here  

  # Confirmation modals 
  confirm:
    
    warning: (action) ->
      action = action or angular.noop
      
      (title, message) ->
        warningModal = undefined
        warningModal = openModal(
          modal:
            dismissable: true
            title: title
            html: message
            buttons: [
              {
                classes: 'btn-danger'
                text: 'Usuń'
                click: (e) ->
                  warningModal.close e
                  return
              }
              {
                classes: 'btn-default'
                text: 'Anuluj'
                click: (e) ->
                  warningModal.dismiss e
                  return
              }
            ]
        , 'modal-danger')
        warningModal.result.then (event) ->
          action.apply event
          return

        return


    delete: (del) ->
      that = @
      ->
        args = Array::slice.call arguments
        name = args.shift()
        that.warning(del)('Potwierdź usunięcie', '<p>Czy na pewno chcesz usunąć <strong>' + name + '</strong> ?</p>')