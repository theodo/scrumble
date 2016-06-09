angular.module 'Scrumble.organization'
.controller 'OrganizationCtrl', (
  $scope
  $stateParams
  Organization
) ->
  formSkeleton = [
    label: 'Quelle est votre appréciation sur la vitesse de traitement de vos demandes par l\'équipe Theodo ?'
    type: 'radio'
    items: [
      label: '5 - Excellente'
      value: 5
    ,
      label: '4 - Très bonne'
      value: 4
    ,
      label: '3 - Bonne'
      value: 3
    ,
      label: '2 - Moyenne'
      value: 2
    ,
      label: '1 - Insuffisante'
      value: 1
    ,
      label: '0 - Très insuffisante'
      value: 0
    ]
  ,
    label: 'Quelle est votre appréciation sur la qualité de l\'accompagnement Theodo ?'
    type: 'radio'
    items: [
      label: '5 - Excellente'
      value: 5
    ,
      label: '4 - Très bonne'
      value: 4
    ,
      label: '3 - Bonne'
      value: 3
    ,
      label: '2 - Moyenne'
      value: 2
    ,
      label: '1 - Insuffisante'
      value: 1
    ,
      label: '0 - Très insuffisante'
      value: 0
    ]
  ,
    label: 'Quel changement/amélioration prioritaire pourrait vous amener à améliorer votre appréciation ?'
    type: 'textarea'
  ,
    label: 'Si vous aviez une baguette magique, quelle est \"la\" chose que vous changeriez chez Theodo ?'
    type: 'textarea'
  ,
    label: 'Seriez vous prêt à recommander Theodo'
    type: 'radio'
    items: [
      label: 'Oui bien sûr'
      value: 'yes-of-course'
    ,
      label: 'Oui'
      value: 'yes'
    ,
      label: 'Pas vraiment'
      value: 'not-really'
    ,
      label: 'Pas du tout'
      value: 'not-at-all'
    ]
  ,
    label: 'Souhaitez-vous faire un point commercial avec Theodo dans la semaine à venir ?'
    type: 'radio'
    items: [
      label: 'Oui'
      value: 'yes'
    ,
      label: 'Non, ce n’est pas nécessaire pour l’instant'
      value: 'no'
    ]
  ]

  Organization.get(organizationId: $stateParams.organizationId)
  .then (organization) ->
    organization.satisfactionSurvey = _.defaultsDeep organization.satisfactionSurvey, formSkeleton
    $scope.organization = organization

  $scope.save = (organization) ->
    Organization.update organization
