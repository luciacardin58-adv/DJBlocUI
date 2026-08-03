Class {
	#name : 'DJFaderElementTest',
	#superclass : 'TestCase',
	#instVars : [
		'fader',
		'fired'
	],
	#category : 'DjBlocUI-Tests',
	#package : 'DjBlocUI',
	#tag : 'Tests'
}

{ #category : 'running' }
DJFaderElementTest >> setUp [
    super setUp.
    fader := DJFaderElement new.
    fired := OrderedCollection new.
    fader callBack: [ :v | fired add: v ]
]

{ #category : 'tests' }
DJFaderElementTest >> testCallbackRestoredAfterError [
    self should: [ fader setValueSilently: 'not a number' ] raise: Error.
    fader setValue: 7.
    self assert: fired asArray equals: #(7)
]

{ #category : 'tests' }
DJFaderElementTest >> testCallbackRestoredAfterSilentSet [
    fader setValueSilently: 42.
    fader setValue: 7.
    self assert: fired asArray equals: #(7)
]

{ #category : 'tests' }
DJFaderElementTest >> testNestedSilentSetRestoresOuterCallback [
    fader callBack: [ :v |
        fired add: v.
        fader setValueSilently: 10 ].
    fader setValue: 42.
    self assert: fired asArray equals: #(42).
    fired removeAll.
    fader setValue: 7.
    self assert: fired asArray equals: #(7)

]

{ #category : 'tests' }
DJFaderElementTest >> testSetValueFiresCallback [
    fader setValue: 42.
    self assert: fired size equals: 1.
    self assert: fired first equals: 42
]

{ #category : 'tests' }
DJFaderElementTest >> testSetValueSilentlyMovesHandle [
    | before |
    before := fader handle position.
    fader setValueSilently: 90.
    self deny: fader handle position equals: before
]

{ #category : 'tests' }
DJFaderElementTest >> testSetValueSilentlyStillUpdatesValue [
    fader setValueSilently: 42.
    self assert: fader value equals: 42
]

{ #category : 'tests' }
DJFaderElementTest >> testSilentSetWithNoCallback [
    fader callBack: nil.
    fader setValueSilently: 42.
    self assert: fader value equals: 42.
    self assert: fader callBack isNil
]
