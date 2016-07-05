describe '[Service] TagRepository', ->
  beforeEach module 'Scrumble.problems'
  TagRepository = null

  beforeEach inject (_TagRepository_) ->
    TagRepository = _TagRepository_

  it 'should format tag label to lower case and without space', ->
    formattedLabel = TagRepository.format('CHUCK NORIS')
    expect(formattedLabel).toEqual('chuck-noris')
