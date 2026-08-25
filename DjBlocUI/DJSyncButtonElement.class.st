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
	#instVars : [
		'sync'
	],
	#category : 'DjBlocUI-DeckBody',
	#package : 'DjBlocUI',
	#tag : 'DeckBody'
}

{ #category : 'examples' }
DJSyncButtonElement class >> example [ 

<script>
	| container button readout space |
	button := self new.
	readout := DJTheme textElement: 'released' color: DJTheme dimText size: 12.
	button callback: [ :each |
		readout text: (DJTheme
				 textElement: (button isLatched ifTrue: [ 'latched' ] ifFalse: [ 'released' ])
				 color: DJTheme dimText
				 size: 12) text ].
	container := DJPanelElement new
		             layout: (BlLinearLayout vertical
				              cellSpacing: DJTheme gap;
				              alignCenter);
		             beMatchingParent;
		             yourself.
	container addChildren: { button. readout }.
	space := container inSpace.
	space extent: 240 @ 160.
	space title: 'DJSyncButtonElement'.
	space show
]

{ #category : 'initialization' }
DJSyncButtonElement >> initialize [

	super initialize.
	self label: 'sync'.
	self isToggleable: true
]

{ #category : 'testing' }
DJSyncButtonElement >> isLatched [ 
^ self isOn
]

{ #category : 'operations' }
DJSyncButtonElement >> latch [
	self setValueSilently: true
]

{ #category : 'operations' }
DJSyncButtonElement >> release [
	"The deck was nudged by hand, so the latch drops."
	self setValueSilently: false
]
