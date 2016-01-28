_ = require('underscore')
Parse = require('parse/node').Parse
Parse.initialize 'UTkdR7MH2Wok5lyPEm1VHoxyFKWVcdOKAu6A4BWG', 'c8v3Y5mg7VEnNN5u1encLS1GKqsqEWC1vZOYLmQb', 'yLM0zIxaICtwlpPtp4YokCQwo1Z3WrESzH44GzN6'
Parse.Cloud.useMasterKey()

surveys = [
  company: 'FastIT'
  questions: [
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
  company: 'Theodo'
  questions: [
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
  company: 'Theodo UK'
  questions: [
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
Survey = Parse.Object.extend("SatisfactionSurveyTemplate")
query = new Parse.Query(Survey)
query.find
  success: (results) ->
    for result in results
      result.destroy()
.then ->
  for survey in surveys
    s = new Survey();
    s.set 'company', survey.company
    s.set 'questions', survey.questions
    s.save()
