"
I draw the whole file as one static waveform and mark the play position.
Clicking me seeks; I never scroll.
"
Class {
	#name : 'DJTrackOverviewElement',
	#superclass : 'BlElement',
	#category : 'DjBlocUI-DeckHeader',
	#package : 'DjBlocUI',
	#tag : 'DeckHeader'
}

{ #category : 'initialization' }
DJTrackOverviewElement >> initialize [
	super initialize.
	self constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical exact: 60 ]
]
