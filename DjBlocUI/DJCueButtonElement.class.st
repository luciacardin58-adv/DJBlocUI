"
I jump a deck to its cue point, or set the cue point when stopped.
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
