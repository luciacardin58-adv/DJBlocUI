"
I display a track's filename and its BPM on a second line.
"
Class {
	#name : 'DJTrackTitleElement',
	#superclass : 'DJStubElement',
	#category : 'DjBlocUI-DeckHeader',
	#package : 'DjBlocUI',
	#tag : 'DeckHeader'
}

{ #category : 'initialization' }
DJTrackTitleElement >> initialize [
	super initialize.
	self constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical matchParent ]
]

{ #category : 'updating' }
DJTrackTitleElement >> track: aDJAudioFileInfo [
	^ self
]
