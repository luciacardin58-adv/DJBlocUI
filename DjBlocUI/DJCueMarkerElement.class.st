"
I mark a single cue point on a waveform at a given sample position.
"
Class {
	#name : 'DJCueMarkerElement',
	#superclass : 'DJWaveformOverlayElement',
	#instVars : [
		'cueLabel',
		'markerColor',
		'cuePosition'
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

{ #category : 'building' }
DJCueMarkerElement >> buildContent [
	| x |
	x := self xFor: cuePosition.
	(self isVisibleAt: x) ifFalse: [ ^ self ].
	self addChild: (self lineAt: x width: 2 color: markerColor).
	self addChild: (self flagAt: x)
]

{ #category : 'building' }
DJCueMarkerElement >> canDraw [
	"A deck with no cue draws nothing, not a marker at zero."
	^ super canDraw and: [ self isSet ]
]

{ #category : 'helper' }
DJCueMarkerElement >> clear [
	
	"The deck dropped its cue point."
	cuePosition := nil.
	self rebuild
]

{ #category : 'accessing' }
DJCueMarkerElement >> cuePosition [ 
^ cuePosition 
]

{ #category : 'as yet unclassified' }
DJCueMarkerElement >> cuePosition: aFraction [
 
	"A fraction of the whole track, 0 to 1. Not called position: -
	 that selector belongs to BlElement and overriding it breaks
	 Bloc's bounds machinery."
	cuePosition := aFraction.
	self rebuild
]

{ #category : 'helper' }
DJCueMarkerElement >> flagAt: aNumber [
	"The flag hangs to the right of the line so it never covers the
	 sample the cue actually sits on."
	| flag |
	flag := BlElement new
		        background: markerColor;
		        extent: 16 @ 14;
		        position: aNumber @ 0;
		        layout: BlFrameLayout new;
		        constraintsDo: [ :c | c ignoreByLayout ];
		        yourself.
	flag addChild:
		((DJTheme textElement: cueLabel color: DJTheme console size: 11)
			 constraintsDo: [ :c |
				 c frame horizontal alignCenter.
				 c frame vertical alignCenter ];
			 yourself).
	^ flag
]

{ #category : 'initialization' }
DJCueMarkerElement >> initialize [
	super initialize.
	cueLabel := 'A'.
	markerColor := DJTheme accent.

]

{ #category : 'testing' }
DJCueMarkerElement >> isSet [

	^ cuePosition isNotNil
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
