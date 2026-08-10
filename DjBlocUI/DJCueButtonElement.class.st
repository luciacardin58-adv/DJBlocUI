"
I jump a deck to its cue point, or set the cue point when the deck is stopped.

I am momentary, not toggleable: the deck plays from the cue while I am held and returns when released. That is the default ICButton behaviour / mouse down toggles, mouse up toggles back, so I add nothing.
"
Class {
	#name : 'DJCueButtonElement',
	#superclass : 'DJButtonElement',
	#category : 'DjBlocUI-Transport',
	#package : 'DjBlocUI',
	#tag : 'Transport'
}

{ #category : 'initialization' }
DJCueButtonElement >> initialize [
	"Momentary, unlike play and sync."

	inputText := 'cue'.
	super initialize
]
