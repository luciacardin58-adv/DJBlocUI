"
I mark a single cue point on a waveform at a given sample position.
"
Class {
	#name : 'DJCueMarkerElement',
	#superclass : 'BlElement',
	#instVars : [
		'windowStart',
		'windowSpan',
		'cueLabel',
		'markerColor',
		'position'
	],
	#category : 'DjBlocUI-DeckBody',
	#package : 'DjBlocUI',
	#tag : 'DeckBody'
}

{ #category : 'examples' }
DJCueMarkerElement class >> example [
	"Three cues over the same waveform strip, one scrolled out of view."
	<script>
	| host space cues |
	host := DJPanelElement new beMatchingParent; yourself.
	cues := {
		        { 0.15. 'A'. DJTheme accent }.
		        { 0.40. 'B'. Color yellow }.
		        { 0.85. 'C'. Color orange } }.
	cues do: [ :each |
		host addChild: (DJCueMarkerElement new
				 label: (each at: 2);
				 markerColor: (each at: 3);
				 position: (each at: 1);
				 yourself) ].
	space := host inSpace.
	space extent: 600 @ 140.
	space title: 'DJCueMarkerElement'.
	space show
]

{ #category : 'helper' }
DJCueMarkerElement >> clear [ 

"The deck dropped its cue point."
	position := nil.
	self rebuild
]

{ #category : 'building' }
DJCueMarkerElement >> flagAt: aNumber [
	"The flag hangs to the right of the line so it never covers the
	 sample the cue actually sits on."
	| flag |
	flag := BlElement new
		        background: markerColor;
		        size: 16 @ 14;
		        position: aNumber @ 0;
		        layout: BlFrameLayout new;
		        constraintsDo: [ :c | c ignoreByLayout ];
		        yourself.
	flag addChild: ((DJTheme textElement: cueLabel color: DJTheme console size: 11)
			 constraintsDo: [ :c |
				 c frame horizontal alignCenter.
				 c frame vertical alignCenter ];
			 yourself).
	^ flag
]

{ #category : 'initialization' }
DJCueMarkerElement >> initialize [
	windowStart := 0.
	windowSpan := 1.
	cueLabel := 'A'.
	markerColor := DJTheme accent.
	super initialize.
	self background: Color transparent.
	self constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical matchParent ].
	self addEventHandlerOn: BlElementExtentChangedEvent do: [ :e | self rebuild ]
]

{ #category : 'testing' }
DJCueMarkerElement >> isSet [
	^ position isNotNil
]

{ #category : 'accessing' }
DJCueMarkerElement >> label: aString [
	cueLabel := aString.
	self rebuild
]

{ #category : 'accessing' }
DJCueMarkerElement >> markerColor: aColor [
	markerColor := aColor.
	self rebuild
]

{ #category : 'helper' }
DJCueMarkerElement >> onAddedToSceneGraph [
	"A cue can be set while I am still detached, before layout has
	 given me a width."
	super onAddedToSceneGraph.
	self rebuild
]

{ #category : 'geometry position' }
DJCueMarkerElement >> position [ 
^ position 
]

{ #category : 'api - bounds' }
DJCueMarkerElement >> position: aFraction [
	"A fraction of the whole track, 0 to 1."
	position := aFraction.
	self rebuild
]

{ #category : 'building' }
DJCueMarkerElement >> rebuild [
	| x |
	self removeChildren.
	(self isSet and: [ self width > 0 ]) ifFalse: [ ^ self ].
	x := self xFor: position.
	(x between: 0 and: self width) ifFalse: [ ^ self ].
	self addChild: (self lineAt: x).
	self addChild: (self flagAt: x)
]

{ #category : 'accessing' }
DJCueMarkerElement >> windowFrom: aStart span: aSpan [
	windowStart := aStart.
	windowSpan := aSpan.
	self rebuild
]

{ #category : 'accessing' }
DJCueMarkerElement >> xFor: aFraction [
	^ (aFraction - windowStart) / windowSpan * self width
]
