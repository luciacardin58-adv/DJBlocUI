Class {
	#name : 'DJTempoFaderElement',
	#superclass : 'DJFaderElement',
	#category : 'DjBlocUI-DeckBody',
	#package : 'DjBlocUI',
	#tag : 'DeckBody'
}

{ #category : 'initialization' }
DJTempoFaderElement >> initialize [
	"Percentage, plus or minus 8 percent. The deck converts to a rate
	 multiplier. Centre snapping still to come - see section 9."
	super initialize.
	self minValue: -8.
	self maxValue: 8
]
