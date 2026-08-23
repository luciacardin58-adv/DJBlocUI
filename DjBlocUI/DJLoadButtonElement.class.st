"
I load the crate browser's selected track onto my deck.

I am momentary, like cue: a press is an action, not a state. The deck pulls from the browser rather than the browser pushing to a deck, so the browser never needs to know which deck exists.

I hold no wiring myself: **DJDeckElement** gives me its loadAction.
"
Class {
	#name : 'DJLoadButtonElement',
	#superclass : 'DJButtonElement',
	#category : 'DjBlocUI-Transport',
	#package : 'DjBlocUI',
	#tag : 'Transport'
}

{ #category : 'initialization' }
DJLoadButtonElement >> initialize [
	"Momentary, like cue."

super initialize.
	self label: 'load'
]
