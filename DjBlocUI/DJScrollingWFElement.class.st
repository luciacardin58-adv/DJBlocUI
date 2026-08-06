"
I draw a zoomed window of the track that scrolls under a fixed centre playhead.
I ask my thumbnail only for the columns currently visible.
"
Class {
	#name : 'DJScrollingWFElement',
	#superclass : 'BlElement',
	#category : 'DjBlocUI-DeckBody',
	#package : 'DjBlocUI',
	#tag : 'DeckBody'
}

{ #category : 'initialization' }
DJScrollingWFElement >> initialize [
	super initialize.
	self constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical exact: 110 ]
]
