"
I am the base rotary control, an ICDarkKnob2 with the same vow of silence
as DJFaderElement. Restyle me by overriding knobColor, markerColor,
outerRingColor and valueColor - ICDarkKnob2 holds nothing else.
"
Class {
	#name : 'DJKnobElement',
	#superclass : 'ICDarkKnob2',
	#traits : 'TDJSilentSettable',
	#classTraits : 'TDJSilentSettable classTrait',
	#category : 'DjBlocUI-SimpleWidgets',
	#package : 'DjBlocUI',
	#tag : 'SimpleWidgets'
}

{ #category : 'examples' }
DJKnobElement class >> example [
	<script>
	| container |
	container := BlElement new
		             background: DJTheme panel;
		             layout: BlFrameLayout new;
		             constraintsDo: [ :c |
			             c horizontal matchParent.
			             c vertical matchParent ];
		             yourself.
	container addChild: (self new
			 constraintsDo: [ :c |
				 c frame horizontal alignCenter.
				 c frame vertical alignCenter ];
			 yourself).
	(container openInSpace)
		extent: 260 @ 260;
		title: 'DJKnobElement'
]

{ #category : 'initialization' }
DJKnobElement >> backColor [
	"ICKnob paints an opaque diameter+100 frame behind itself.
	 ICDarkKnob2 does not override this - it is not one of its seven
	 cosmetic methods - so every knob carries 35pt of dead margin
	 that hides whatever panel it sits on."
	^ Color transparent
]

{ #category : 'initialization' }
DJKnobElement >> initialize [
	"initializeGeometry hardcodes extent: diameter + 100 while the ring
	 is only diameter + 30. Retighten so mixer layout is predictable."
	super initialize.
	self extent: (self outerRingSize + 20) asPoint
]
