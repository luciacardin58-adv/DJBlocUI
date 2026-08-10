Class {
	#name : 'DJPlayButtonElementTest',
	#superclass : 'TestCase',
	#instVars : [
		'button'
	],
	#category : 'DjBlocUI-Tests',
	#package : 'DjBlocUI',
	#tag : 'Tests'
}

{ #category : 'running' }
DJPlayButtonElementTest >> setUp [
	super setUp.
	button := DJPlayButtonElement new
]

{ #category : 'tests' }
DJPlayButtonElementTest >> testCarriesItsCaption [
	"The example rendered an empty outline where cue rendered its label."
	self assert: button inputText equals: 'play'
]

{ #category : 'tests' }
DJPlayButtonElementTest >> testIsToggleable [
	self assert: button isToggleable
]

{ #category : 'tests' }
DJPlayButtonElementTest >> testShowStoppedDoesNotNotify [
	"Track ends, deck stops itself, button must show stopped without
	 asking the deck to stop again."
	| fired |
	fired := OrderedCollection new.
	button toggle.
	button callback: [ :each | fired add: each ].
	button showStopped.
	self deny: button isPlaying.
	self assert: fired isEmpty
]

{ #category : 'tests' }
DJPlayButtonElementTest >> testShowStoppedIsIdempotent [
	button showStopped.
	self deny: button isPlaying
]

{ #category : 'tests' }
DJPlayButtonElementTest >> testStartsStopped [
	self deny: button isPlaying
]

{ #category : 'tests' }
DJPlayButtonElementTest >> testToggleStarts [
	button toggle.
	self assert: button isPlaying
]

{ #category : 'tests' }
DJPlayButtonElementTest >> testToggleableDoesNotDuplicateHandlers [
	"isToggleable: re-sends initializeEvents, and Bloc appends handlers."
	| downs ups |
	downs := button button eventDispatcher handlers select: [ :each |
		         each eventClass = BlMouseDownEvent ].
	ups := button button eventDispatcher handlers select: [ :each |
		       each eventClass = BlMouseUpEvent ].
	self assert: downs size equals: 1.
	self assert: ups size equals: 0
]
