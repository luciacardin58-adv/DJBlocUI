"
I display a track's filename and its BPM on a second line.
"
Class {
	#name : 'DJTrackTitleElement',
	#superclass : 'DJPanelElement',
	#instVars : [
		'titleLabel',
		'bpmLabel'
	],
	#category : 'DjBlocUI-DeckHeader',
	#package : 'DjBlocUI',
	#tag : 'DeckHeader'
}

{ #category : 'accessing' }
DJTrackTitleElement >> bpm: aNumber [
	bpmLabel text: (DJTheme
			 rope: (aNumber
					  ifNil: [ '--' ]
					  ifNotNil: [ :each | each printShowingDecimalPlaces: 1 ])
			 color: DJTheme accent
			 size: 13)
]

{ #category : 'initialization' }
DJTrackTitleElement >> initialize [
	super initialize.
	self constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical matchParent ]
]

{ #category : 'initialization' }
DJTrackTitleElement >> initializeParts [
	titleLabel := DJTheme textElement: 'no track' color: DJTheme text size: 14.
	bpmLabel := DJTheme textElement: '--' color: DJTheme accent size: 13.
	self addChildren: { titleLabel. bpmLabel }
]

{ #category : 'accessing' }
DJTrackTitleElement >> title: aString [
	titleLabel text: (DJTheme rope: aString color: DJTheme text size: 14)
]

{ #category : 'updating' }
DJTrackTitleElement >> track: aDJAudioFileInfo [
	^ self
]
