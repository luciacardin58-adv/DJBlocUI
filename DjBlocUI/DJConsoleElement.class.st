"
I am the root element of the DJ application.
I lay out two decks, two channel strips, the transport bars and the crossfader.
"
Class {
	#name : 'DJConsoleElement',
	#superclass : 'DJPanelElement',
	#instVars : [
		'leftDeck',
		'rightDeck',
		'mixer',
		'browser'
	],
	#category : 'DjBlocUI-Root',
	#package : 'DjBlocUI',
	#tag : 'Root'
}

{ #category : 'accessing' }
DJConsoleElement class >> defaultExtent [ 
^ 1200 @ 600
]

{ #category : 'accessing' }
DJConsoleElement >> browser [ 
^ browser
]

{ #category : 'building' }
DJConsoleElement >> buildConsoleRow [

	| row |
	leftDeck := DJDeckElement new.
	mixer := DJMixerElement new.
	rightDeck := DJDeckElement mirrored.
	row := DJPanelElement new
		       beRow;
		       background: Color transparent;
		       border: BlBorder empty;
		       padding: BlInsets empty;
		       yourself.
	row constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical matchParent ].
	row addChildren: {
			leftDeck.
			mixer.
			rightDeck }.
	^ row
]

{ #category : 'initialization' }
DJConsoleElement >> initialize [

	super initialize.
	self background: DJTheme console.
	self extent: self class defaultExtent 
]

{ #category : 'initialization' }
DJConsoleElement >> initializeParts [

	self addChild: self buildConsoleRow.
	browser := DJBrowserElement new.
	self addChild: browser.
	self initializeWiring
]

{ #category : 'initialization' }
DJConsoleElement >> initializeWiring [
	"Each deck pulls the browser's selection when its LOAD is pressed."

	leftDeck loadAction: [ self loadSelectedTrackOnDeck: leftDeck ].
	rightDeck loadAction: [ self loadSelectedTrackOnDeck: rightDeck ]
]

{ #category : 'accessing' }
DJConsoleElement >> leftDeck [
^ leftDeck
]

{ #category : 'actions' }
DJConsoleElement >> loadSelectedTrackOnDeck: aDJDeckElement [
	"Pull the browser's current selection onto the given deck. Answers
	 self when nothing is selected, so a LOAD press on an empty browser
	 is a no-op rather than an error."

	| track |
	track := browser selectedTrack.
	track ifNil: [ ^ self ].
	aDJDeckElement loadTrack: track
]

{ #category : 'accessing' }
DJConsoleElement >> mixer [ 
^ mixer
]

{ #category : 'accessing' }
DJConsoleElement >> rightDeck [ 

	^ rightDeck
]
