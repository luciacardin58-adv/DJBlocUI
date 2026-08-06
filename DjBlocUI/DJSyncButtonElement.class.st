"
I match my deck's tempo to the other deck's.
I latch on and release when the deck is nudged manually.
"
Class {
	#name : 'DJSyncButtonElement',
	#superclass : 'DJButtonElement',
	#category : 'DjBlocUI-DeckBody',
	#package : 'DjBlocUI',
	#tag : 'DeckBody'
}

{ #category : 'evaluating' }
DJSyncButtonElement >> initialize [
	inputText := 'sync'.
	super initialize.
	self isToggleable: true 
]
