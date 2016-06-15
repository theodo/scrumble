_ = require('underscore')
Parse = require('parse/node').Parse
Parse.initialize 'UTkdR7MH2Wok5lyPEm1VHoxyFKWVcdOKAu6A4BWG', 'c8v3Y5mg7VEnNN5u1encLS1GKqsqEWC1vZOYLmQb', 'yLM0zIxaICtwlpPtp4YokCQwo1Z3WrESzH44GzN6'
Parse.Cloud.useMasterKey()

companies = [
  name: 'BAM'
  checklists: [
    name: 'Agilité Technique'
    list: [
      label: 'PROD : les serveurs prod et preprod sont iso'
      value: 1
    ,
      label: 'PROD : scripts automatisés pour le build prod et staging'
      value: 1
    ,
      label: 'PROD : la validation Apple demandée'
      value: 1
    ,
      label: 'Aucun regression la semaine dernière'
      value: 3
    ,
      label: 'Si regression, PDCA en réaction'
      value: 2
    ,
      label: 'Vocabulaire du code identique au vocabulaire métier'
      value: 2
    ,
      label: 'Intégration continue verte'
      value: 2
    ,
      label: 'Au moins 1 test unitaire par jour'
      value: 2
    ,
      label: 'Code review sur chaque Merge requests'
      value: 2
    ,
      label: 'Au moins un refactoring par jour'
      value: 1
    ,
      label: 'Dépendances stables'
      value: 1
    ,
      label: 'README : installation du projet à jour'
      value: 1
    ,
      label: 'Kitchensink qui récapitule le CSS'
      value: 1
    ]
    standard: 18
  ,
    name: 'Standard UX'
    list: [
      label: 'Retour users: Un test utilisateur par sprint'
      value: 1
    ,
      label: 'Retour users: Au moins 1 ticket de retoru utilisateur réalisé dans le Sprint'
      value: 2
    ,
      label: 'Fluidité : Le clavier ne recouvre pas de champs ou de bouton important'
      value: 1
    ,
      label: 'Fluidité : Transitions fluides (60 fps)'
      value: 2
    ,
      label: 'Rapidité ouverture : Temps de chargement < 1s'
      value: 3
    ,
      label: 'Jolie : Respect des guidelines mobiles (iOS en Android, taille/positionnement boutons, utilisation icones)'
      value: 1
    ,
      label: 'Jolie : Respect de la chartre graphique du projet (couleur, police, logo, composants)'
      value: 2
    ,
      label: 'Simplicité : 1 call to action clair représentant le service'
      value: 1
    ,
      label: 'Simplicité : avoir toutes les features principales accessible et visible sur la home'
      value: 1
    ,
      label: 'Clareté : 3 écrans max pour atteindre son objectif'
      value: 1
    ,
      label: 'Clareté : avoir toutes les features principales accessible et visible sur la home'
      value: 1
    ,
      label: 'Besoin : L\'app repond à un besoin user ou résoud un problème'
      value: 2
    ,
      label: 'Feedback : retour visuel au click sur des boutons'
      value: 1
    ,
      label: 'Feedback : loader pour chaque temps d\'attente ou chargement'
      value: 2
    ]
    standard: 17
  ]
  satisfactionSurvey: [
    label: 'Quelle est votre appréciation sur la vitesse d\'avancement de l\'équipe BAM ?'
    type: 'radio'
    items: [
      value: 5
      label: '5 - Excellente'
    ,
      value: 4
      label: '4 - Très bonne'
    ,
      value: 3
      label: '3 - Bonne'
    ,
      value: 2
      label: '2 - Moyenne'
    ,
      value: 1
      label: '1 - Insuffisante'
    ,
      value: 0
      label: '0 - Très insuffisante'
    ,
    ]
  ,
    label: 'Quelle est votre appréciation sur la qualité de l\'accompagnement BAM ?'
    type: 'radio'
    items: [
      value: 5
      label: '5 - Excellente'
    ,
      value: 4
      label: '4 - Très bonne'
    ,
      value: 3
      label: '3 - Bonne'
    ,
      value: 2
      label: '2 - Moyenne'
    ,
      value: 1
      label: '1 - Insuffisante'
    ,
      value: 0
      label: '0 - Très insuffisante'
    ,
    ]
  ,
    label: 'Quel changement/amélioration prioritaire pourrait vous amener à améliorer votre appréciation ?'
    type: 'textarea'
  ,
    label: 'Si vous aviez une baguette magique, quelle est apporteriez vous chez BAM ?'
    type: 'textarea'
  ,
    label: 'Seriez-vous prêt à recommander BAM ?'
    type: 'radio'
    items: [
      value: 'yes-of-course'
      label: 'Oui bien sûr'
    ,
      value: 'yes'
      label: 'Oui'
    ,
      value: 'not-really'
      label: 'Pas vraiment'
    ,
      value: 'not-at-all'
      label: 'Pas du tout'
    ]
  ,
    label: 'Souhaitez-vous faire un point commercial avec BAM dans la semaine à venir ?'
    type: 'radio'
    items: [
      value: 'yes'
      label: 'Oui'
    ,
      value: 'no'
      label: 'Non, ce n’est pas nécessaire pour l’instant'
    ]
  ,
  ]
]

Company = Parse.Object.extend("Company")
query = new Parse.Query(Company)
query.find
  success: (results) ->
    for result in results
      result.destroy()
.then ->
  for company in companies
    s = new Company();
    s.set 'name', company.name
    s.set 'checklists', company.checklists
    s.set 'satisfactionSurvey', company.satisfactionSurvey
    s.save()
