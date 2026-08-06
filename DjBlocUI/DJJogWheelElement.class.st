"
I am a deck's pitch fader, +/-8% by default, with a reset to zero.
My value is a percentage; the deck converts it to a rate multiplier.
"
Class {
	#name : 'DJJogWheelElement',
	#superclass : 'BlElement',
	#category : 'DjBlocUI-DeckBody',
	#package : 'DjBlocUI',
	#tag : 'DeckBody'
}

{ #category : 'initialization' }
DJJogWheelElement >> initialize [
	super initialize.
	self geometry: BlCircleGeometry new.
	self constraintsDo: [ :c |
		c horizontal exact: 200.
		c vertical exact: 200 ]
]
