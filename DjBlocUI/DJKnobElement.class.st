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
	container addChild: ((self label: 'MID')
			 constraintsDo: [ :c |
				 c frame horizontal alignCenter.
				 c frame vertical alignCenter ];
			 yourself).
	(container openInSpace)
		extent: 260 @ 260;
		title: 'DJKnobElement'
]

{ #category : 'accessing' }
DJKnobElement >> backColor [
	

	^ Color transparent
]

{ #category : 'accessing' }
DJKnobElement >> diskSize [ 

^ self outerRingSize
]

{ #category : 'initialization' }
DJKnobElement >> initialize [
	"ICKnob sets extent: diameter + 100 in initializeGeometry, but an
	 explicit extent does not survive a parent layout. The frame
	 collapses toward the ring and takes the label band with it.
	 minLabel, maxLabel and currentLabel all live in that band."
	super initialize.
	self constraintsDo: [ :c |
		c horizontal exact: self diameter + 100.
		c vertical exact: self diameter + 100 ]
]

{ #category : 'accessing' }
DJKnobElement >> knobSize [ 
	^ self diameter * 4 / 3

]

{ #category : 'accessing' }
DJKnobElement >> outerRingSize [ 
^ self diameter * 3 / 2
]
