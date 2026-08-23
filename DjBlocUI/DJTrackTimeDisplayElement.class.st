"
I show a track''s elapsed and remaining time in the deck header.

Elapsed is the large figure, remaining the small one beneath it, prefixed with a minus so the two never read as a single number.

I take both in one call: remaining is only meaningful against a total, and keeping a total of my own would let it drift from the deck''s. 
"
Class {
	#name : 'DJTrackTimeDisplayElement',
	#superclass : 'DJPanelElement',
	#instVars : [
		'elapsedLabel',
		'remainingLabel'
	],
	#category : 'DjBlocUI-DeckHeader',
	#package : 'DjBlocUI',
	#tag : 'DeckHeader'
}

{ #category : 'helper' }
DJTrackTimeDisplayElement >> elapsed: elapsedSeconds of: totalSeconds [
	"One call, because remaining is only meaningful against a total."
	elapsedLabel text: (DJTheme
			 rope: (self format: elapsedSeconds)
			 color: DJTheme text
			 size: 18).
	remainingLabel text: (DJTheme
			 rope: '-' , (self format: totalSeconds - elapsedSeconds)
			 color: DJTheme dimText
			 size: 12)
]

{ #category : 'accessing' }
DJTrackTimeDisplayElement >> elapsedLabel [ 
^ elapsedLabel 
]

{ #category : 'helper' }
DJTrackTimeDisplayElement >> format: aNumberOfSeconds [
	"mm:ss, floored. Negative clamps to zero so a slight overrun at the
	 end of a track does not print a negative time."
	| whole |
	whole := (aNumberOfSeconds max: 0) truncated.
	^ ((whole // 60) printPaddedWith: $0 to: 2) , ':'
	  , ((whole \\ 60) printPaddedWith: $0 to: 2)
]

{ #category : 'initialization' }
DJTrackTimeDisplayElement >> initialize [
	super initialize.
	self constraintsDo: [ :c |
		c horizontal exact: 90.
		c vertical matchParent ]
]

{ #category : 'initialization' }
DJTrackTimeDisplayElement >> initializeParts [
	elapsedLabel := DJTheme textElement: '00:00' color: DJTheme text size: 18.
	remainingLabel := DJTheme textElement: '-00:00' color: DJTheme dimText size: 12.
	self addChildren: { elapsedLabel. remainingLabel }
]

{ #category : 'accessing' }
DJTrackTimeDisplayElement >> remainingLabel [ 
^ remainingLabel
]
