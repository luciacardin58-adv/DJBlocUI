"
I am the base button, an ICButton, momentary or toggleable via isToggleable.
I need no silence: my callback fires from mouse events only, never from a setter.
"
Class {
	#name : 'DJButtonElement',
	#superclass : 'ICLabelButton',
	#category : 'DjBlocUI-SimpleWidgets',
	#package : 'DjBlocUI',
	#tag : 'SimpleWidgets'
}

{ #category : 'as yet unclassified' }
DJButtonElement class >> exampleMomentary [
	"Default is momentary: down lights it, up releases. CUE behaves
	 this way; PLAY and SYNC are toggles."
	<script>
	| container |
	container := BlElement new
		             background: DJTheme panel;
		             layout: BlFrameLayout new;
		             constraintsDo: [ :c |
			             c horizontal matchParent.
			             c vertical matchParent ];
		             yourself.
	container addChild: ((self label: 'CUE')
			 constraintsDo: [ :c |
				 c frame horizontal alignCenter.
				 c frame vertical alignCenter ];
			 yourself).
	(container openInSpace)
		extent: 260 @ 200;
		title: 'DJButtonElement (momentary)'
]

{ #category : 'size' }
DJButtonElement >> applyButtonSize [ 
	"ICLabelButton gives the resting button an opaque grey gaussian shadow at
	 zero offset, which reads as a lighter rectangle behind it on a dark panel.
	 applySize reinstalls it on every resize, so overriding initializeButton is
	 not enough. The lit state keeps its glow: lightDown sets its own effect."

	super applyButtonSize.
	self button effect: (BlGaussianShadowEffect
			 color: (Color white alpha: 0.0)
			 offset: 0 @ 0
			 width: 10)
]

{ #category : 'defaults' }
DJButtonElement >> defaultFitsContent [

^ false

]

{ #category : 'defaults' }
DJButtonElement >> defaultWidgetSize [

^ 76 @ 36 
]

{ #category : 'defaults' }
DJButtonElement >> fontSizeRatio [ 

	^ 1 / 3
]

{ #category : 'initialization' }
DJButtonElement >> initialize [


	self inputText ifNil: [ self inputText: '' ].
	super initialize.
	self initializeLabel
]

{ #category : 'accessing' }
DJButtonElement >> inputLabel [
	"ICLabelButton declares inputLabel with no accessor."
	^ inputLabel
]

{ #category : 'accessing' }
DJButtonElement >> isOn [ 
	"currentValue is the real state and holds 0/1."

	^ self currentValue = 1
]

{ #category : 'accessing' }
DJButtonElement >> setValueSilently: aBoolean [
"Set my lit state without running my callback, for when the deck has already stopped and only needs me to agree. setValue: would notify the deck and it would stop itself a second time. 
Only fire and setValue: reach the callback; toggle just flips the value and repa"

	self isOn = aBoolean ifFalse: [ self toggle ]
]
