Class {
	#name : 'DJThemeTest',
	#superclass : 'TestCase',
	#category : 'DjBlocUI-Tests',
	#package : 'DjBlocUI',
	#tag : 'Tests'
}

{ #category : 'helpers' }
DJThemeTest >> colourSelectors [

    ^ self paletteSelectors reject: [ :each | each = #gap ]
]

{ #category : 'helpers' }
DJThemeTest >> paletteSelectors [
    "Behavior >> selectors answers only locally defined selectors, so this
     picks up every palette method on DJTheme's class side and nothing
     inherited. A new palette method is covered the moment it is written."

    ^ DJTheme class selectors select: [ :each | each numArgs = 0 ]
]

{ #category : 'tests' }
DJThemeTest >> testAccessorsDoNotAnswerTheReceiver [
    "Same dead-block trap as the palette: a body pasted as [ ^ ivar ]
     compiles to an unused block and the method answers self."

    | console broken |
    console := DJConsoleElement new.
    broken := #( leftDeck rightDeck mixer browser ) select: [ :each |
                  (console perform: each) == console ].
    self
        assert: broken isEmpty
        description: 'dead block in: ' , broken asArray printString
]

{ #category : 'tests' }
DJThemeTest >> testNoPaletteMethodAnswersTheClassItself [
    "A class-side method with no caret answers self, and self is DJTheme.
     The value reaches background: and fails deep inside Bloc as
     doesNotUnderstand: #asBlBackground, naming the wrong culprit."

    | broken |
    broken := self paletteSelectors select: [ :each |
                  (DJTheme perform: each) == DJTheme ].
    self
        assert: broken isEmpty
        description: 'missing ^ in: ' , broken asSortedCollection asArray printString
]
