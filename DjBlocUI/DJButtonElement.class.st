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

{ #category : 'initialization' }
DJButtonElement >> initialize [
"ICLabelButton builds inputLabel only via class >> label:, so a plain
	 new gives a button whose toggle raises DNU on inputLabel."
	self inputText ifNil: [ self inputText: '' ].
	super initialize.
	self initializeLabel
]

{ #category : 'initialization' }
DJButtonElement >> initializeButton [
	"ICLabelButton gives the resting button an opaque grey gaussian
	 shadow at zero offset, which reads as a lighter rectangle behind
	 it on a dark panel. The lit state keeps its glow."
	super initializeButton.
	self button effect: (BlGaussianShadowEffect
			 color: (Color white alpha: 0.0)
			 offset: 0 @ 0
			 width: 10)
]

{ #category : 'accessing' }
DJButtonElement >> inputLabel [
	"ICLabelButton declares inputLabel with no accessor."
	^ inputLabel
]

{ #category : 'accessing' }
DJButtonElement >> label: aString [
	inputText := aString.
	inputLabel text: (self isOn
			 ifTrue: [ self configuredString: aString ]
			 ifFalse: [ self configuredStringDark: aString ])
]
