Class {
	#name : 'DJCueButtonElementTest',
	#superclass : 'TestCase',
	#category : 'DjBlocUI-Tests',
	#package : 'DjBlocUI',
	#tag : 'Tests'
}

{ #category : 'tests' }
DJCueButtonElementTest >> testCarriesItsCaption [
	self assert: DJCueButtonElement new inputText equals: 'cue'
]

{ #category : 'tests' }
DJCueButtonElementTest >> testIsMomentary [
	"Held, not latched - the deck plays from the cue while I am down."
	self deny: DJCueButtonElement new isToggleable
]

{ #category : 'tests' }
DJCueButtonElementTest >> testKeepsItsMouseUpHandler [
	"Momentary behaviour is mouse-up toggling back."
	| ups |
	ups := DJCueButtonElement new button eventDispatcher handlers select: [ :each |
		       each eventClass = BlMouseUpEvent ].
	self assert: ups size equals: 1
]
