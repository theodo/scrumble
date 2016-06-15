_ = require('underscore')
Parse = require('parse/node').Parse
Parse.initialize 'UTkdR7MH2Wok5lyPEm1VHoxyFKWVcdOKAu6A4BWG', 'c8v3Y5mg7VEnNN5u1encLS1GKqsqEWC1vZOYLmQb', 'yLM0zIxaICtwlpPtp4YokCQwo1Z3WrESzH44GzN6'
Parse.Cloud.useMasterKey()

companies = [
  name: 'Fast IT'
  checklists: [
    name: 'Checklist Agilité Technique'
    list: [
      label: 'Pas de régression dans le sprint passé'
      value: 1
    ,
      label: 'Badge CI vert avant chaque merge'
      value: 1
    ,
      label: 'Code coverage en progression ou > 80%'
      value: 1
    ,
      label: 'Développeurs fiers du code produit durant le sprint passé'
      value: 1
    ,
      label: 'Pas de dépendance extérieure dans le sprint passé'
      value: 1
    ]
    standard: 5
  ,
    name: 'Réussir son projet'
    list: [
      label: 'Le readme est à jour, le RUN a les informations nécéssaires pour installer le projet, le tester et le mettre en production'
      value: 1
    ,
      label: 'Provisionning à jour, un membre de l\'équipe a détruit sa vagrant cette semaine'
      value: 1
    ,
      label: 'L\'équipe a testé le projet et n\'as pas trouvé de vulnérabilité présente dans la checklist sécurité'
      value: 1
    ,
      label: 'Projet en homologation'
      value: 1
    ,
      label: 'Projet en production'
      value: 1
    ,
      label: 'Feedbacks utilisateurs'
      value: 1
    ,
      label: 'Projet déployé en production durant les deux semaines précédentes'
      value: 1
    ,
      label: 'Moins de 15 minutes pour mettre en production'
      value: 1
    ,
      label: 'L\'équipe connait le succès du projet'
      value: 1
    ]
    standard: [3, 4, 5, 6, 7, 8, 9]
  ]
  satisfactionSurvey: [
    label: 'What is your appreciation of the speed of Fast IT\'s team?'
    type: 'radio'
    items: [
      value: 5
      label: '5 - Excellent'
    ,
      value: 4
      label: '4 - Very good'
    ,
      value: 3
      label: '3 - Good'
    ,
      value: 2
      label: '2 - Average'
    ,
      value: 1
      label: '1 - Insufficient'
    ,
      value: 0
      label: '0 - Very insufficient'
    ,
    ]
  ,
    label: 'What is your appreciation of the quality of Fast IT\'s coaching?'
    type: 'radio'
    items: [
      value: 5
      label: '5 - Excellent'
    ,
      value: 4
      label: '4 - Very good'
    ,
      value: 3
      label: '3 - Good'
    ,
      value: 2
      label: '2 - Average'
    ,
      value: 1
      label: '1 - Insufficient'
    ,
      value: 0
      label: '0 - Very insufficient'
    ,
    ]
  ,
    label: 'What change/improve would make you to improve your appreciation?'
    type: 'textarea'
  ,
    label: 'If you had a magic wand, what is "the" thing you would change at Fast IT'
    type: 'textarea'
  ,
    label: 'Would you be ok to recommend Fast IT?'
    type: 'radio'
    items: [
      value: 'yes-of-course'
      label: 'Yes of course'
    ,
      value: 'yes'
      label: 'Yes'
    ,
      value: 'not-really'
      label: 'Not really'
    ,
      value: 'not-at-all'
      label: 'Not at all'
    ]
  ,
    label: 'Would you like to have a sales meeting in the coming week?'
    type: 'radio'
    items: [
      value: 'yes'
      label: 'Yes'
    ,
      value: 'no'
      label: 'No, it is not necessary for now'
    ]
  ,
  ]
,
  name: 'Theodo'
  checklists: [
    name: 'Checklist Agilité Technique'
    list: [
      label: 'Pas de régression dans le sprint passé'
      value: 1
    ,
      label: 'Badge CI vert avant chaque merge'
      value: 1
    ,
      label: 'Code coverage en progression ou > 80%'
      value: 1
    ,
      label: 'Développeurs fiers du code produit durant le sprint passé'
      value: 1
    ,
      label: 'Pas de dépendance extérieure dans le sprint passé'
      value: 1
    ]
    standard: 5
  ,
    name: 'Réussir son projet'
    list: [
      label: 'Le readme est à jour, le RUN a les informations nécéssaires pour installer le projet, le tester et le mettre en production'
      value: 1
    ,
      label: 'Provisionning à jour, un membre de l\'équipe a détruit sa vagrant cette semaine'
      value: 1
    ,
      label: 'L\'équipe a testé le projet et n\'as pas trouvé de vulnérabilité présente dans la checklist sécurité'
      value: 1
    ,
      label: 'Projet en homologation'
      value: 1
    ,
      label: 'Projet en production'
      value: 1
    ,
      label: 'Feedbacks utilisateurs'
      value: 1
    ,
      label: 'Projet déployé en production durant les deux semaines précédentes'
      value: 1
    ,
      label: 'Moins de 15 minutes pour mettre en production'
      value: 1
    ,
      label: 'L\'équipe connait le succès du projet'
      value: 1
    ]
    standard: [3, 4, 5, 6, 7, 8, 9]
  ]
  satisfactionSurvey: [
    label: 'Quelle est votre appréciation sur la vitesse de traitement de vos demandes par l\'équipe Theodo ?'
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
    label: 'Quelle est votre appréciation sur la qualité de l\'accompagnement Theodo ?'
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
    label: 'Si vous aviez une baguette magique, quelle est "la" chose que vous changeriez chez Theodo ?'
    type: 'textarea'
  ,
    label: 'Seriez-vous prêt à recommander Theodo ?'
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
    label: 'Souhaitez-vous faire un point commercial avec Theodo dans la semaine à venir ?'
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
,
  name: 'Theodo UK'
  checklists: []
  satisfactionSurvey: [
    label: 'How do you feel about the speed of the team?'
    type: 'radio'
    items: [
      value: 5
      label: '5 - Excellent'
    ,
      value: 4
      label: '4 - Very good'
    ,
      value: 3
      label: '3 - Good'
    ,
      value: 2
      label: '2 - Average'
    ,
      value: 1
      label: '1 - Not good'
    ,
      value: 0
      label: '0 - Not good at all'
    ,
    ]
  ,
    label: 'How do you feel about the quality of Theodo’s support?'
    type: 'radio'
    items: [
      value: 5
      label: '5 - Excellent'
    ,
      value: 4
      label: '4 - Very good'
    ,
      value: 3
      label: '3 - Good'
    ,
      value: 2
      label: '2 - Average'
    ,
      value: 1
      label: '1 - Not good'
    ,
      value: 0
      label: '0 - Not good at all'
    ,
    ]
  ,
    label: 'What is the main priority the team should concentrate on to improve the score?'
    type: 'textarea'
  ,
    label: 'Should you have a magic wand, what is « the » thing you would change at Theodo?'
    type: 'textarea'
  ,
    label: 'Would you recommend Theodo?'
    type: 'radio'
    items: [
      value: 'yes-of-course'
      label: 'Yes, absolutely'
    ,
      value: 'yes'
      label: 'Yes'
    ,
      value: 'not-really'
      label: 'Not really'
    ,
      value: 'not-at-all'
      label: 'Not at all'
    ]
  ,
    label: 'Would you like to have an appointment with your sales person this week?'
    type: 'radio'
    items: [
      value: 'yes'
      label: 'Yes'
    ,
      value: 'no'
      label: 'No'
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
