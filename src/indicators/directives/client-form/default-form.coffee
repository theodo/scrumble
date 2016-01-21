angular.module 'Scrumble.indicators'
.service 'defaultSatisfactionForm', ->
  [
    label: 'What is your appreciation of the speed of the team?'
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
    label: 'What is your appreciation of the quality of the coaching?'
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
    label: 'If you had a magic wand, what is "the" thing you would change'
    type: 'textarea'
  ,
    label: 'Would you recommend us?'
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
