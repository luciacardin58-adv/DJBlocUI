"
I toggle a deck between playing and paused and reflect its state.
"
Class {
	#name : 'DJPlayButtonElement',
	#superclass : 'DJButtonElement',
	#category : 'DjBlocUI-Transport',
	#package : 'DjBlocUI',
	#tag : 'Transport'
}

{ #category : 'evaluating' }
DJPlayButtonElement >> initialize [
	inputText := 'play'.
	super initialize.
	self isToggleable: true
]
