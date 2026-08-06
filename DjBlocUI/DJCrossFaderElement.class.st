"
I am the horizontal fader blending the two decks.
I sit between the transport bars and belong to neither deck.
"
Class {
	#name : 'DJCrossFaderElement',
	#superclass : 'DJFaderElement',
	#category : 'DjBlocUI-Transport',
	#package : 'DjBlocUI',
	#tag : 'Transport'
}

{ #category : 'initialization' }
DJCrossFaderElement >> initialize [
	"beHorizontal sends rebuild, which may reset widgetSize - so the
	 size constraints DJFaderElement declared for the vertical default
	 have to be re-read afterwards."
	super initialize.
	self beHorizontal.
	self constraintsDo: [ :c |
		c horizontal exact: self widgetSize x.
		c vertical exact: self widgetSize y ]
]
