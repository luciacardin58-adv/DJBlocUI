"
I am a bipolar filter knob: low-pass left of centre, high-pass right.
"
Class {
	#name : 'DJFilterKnobElement',
	#superclass : 'DJKnobElement',
	#category : 'DjBlocUI-MixerStrip',
	#package : 'DjBlocUI',
	#tag : 'MixerStrip'
}

{ #category : 'initialization' }
DJFilterKnobElement >> initialize [
	"Bipolar: low-pass left of centre, high-pass right."
	inputText ifNil: [ inputText := 'filter' ].
	super initialize.
	self initializeLabel
]
