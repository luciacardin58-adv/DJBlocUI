"
I am the strip above a deck: artwork, title and time.

I forward what I am told to my parts rather than holding a track myself.
I do not mirror - mirrored text reads badly - so a mirrored deck reverses only its jog, tempo and sync row.

The key display was suspended, and the overview waveform is not mine yet:
DJTrackOverviewElement has still to be written.
"
Class {
	#name : 'DJDeckHeaderElement',
	#superclass : 'DJPanelElement',
	#instVars : [
		'artwork',
		'trackTitle',
		'timeDisplay'
	],
	#category : 'DjBlocUI-DeckHeader',
	#package : 'DjBlocUI',
	#tag : 'DeckHeader'
}

{ #category : 'examples' }
DJDeckHeaderElement class >> example [
	<script>
	| header space |
	header := self new.
	header title: 'midnight_drive.wav'.
	header bpm: 128.0.
	header elapsed: 134 of: 361.
	space := header inSpace.
	space extent: 430 @ 90.
	space title: 'DJDeckHeaderElement'.
	space show
]

{ #category : 'accessing' }
DJDeckHeaderElement >> artwork [
^ artwork 
]

{ #category : 'accessing' }
DJDeckHeaderElement >> bpm: aNumber [
	trackTitle bpm: aNumber
]

{ #category : 'helper' }
DJDeckHeaderElement >> elapsed: elapsedSeconds of: totalSeconds [
	timeDisplay elapsed: elapsedSeconds of: totalSeconds
]

{ #category : 'initialization' }
DJDeckHeaderElement >> initialize [
	super initialize.
	self beRow.
	self constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical exact: 90 ]
]

{ #category : 'initialization' }
DJDeckHeaderElement >> initializeParts [
	artwork := DJArtworkElement new.
	trackTitle := DJTrackTitleElement new.
	timeDisplay := DJTrackTimeDisplayElement new.
	self addChildren: { artwork. trackTitle. timeDisplay }
]

{ #category : 'accessing' }
DJDeckHeaderElement >> timeDisplay [ 
^ timeDisplay 
]

{ #category : 'accessing' }
DJDeckHeaderElement >> title: aString [
	trackTitle title: aString
]

{ #category : 'accessing' }
DJDeckHeaderElement >> trackTitle [ 
^ trackTitle 
]
