"
I match my deck''s tempo to the other deck''s.

I latch on, and release when the deck is nudged by hand. My deck wires
that up: it sets a callBack on the tempo fader that sends me release.
Sync itself moves the fader with setValueSilently:, which does not fire
that callBack, so I never unlatch myself.

My latch and release are silent for the same reason - the deck asked,
so telling it back would echo.
"
Class {
	#name : 'DJSyncButtonElement',
	#superclass : 'DJButtonElement',
	#category : 'DjBlocUI-DeckBody',
	#package : 'DjBlocUI',
	#tag : 'DeckBody'
}

{ #category : 'initialization' }
DJSyncButtonElement >> initialize [
	inputText := 'sync'.
	super initialize.
	self isToggleable: true
]
