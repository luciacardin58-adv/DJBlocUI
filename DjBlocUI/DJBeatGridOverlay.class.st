"
I draw bar numbers and downbeat lines over a waveform.
I am inert until beat detection provides a grid.
"
Class {
	#name : 'DJBeatGridOverlay',
	#superclass : 'BlElement',
	#instVars : [
		'beats',
		'beatsPerBar',
		'windowStart',
		'windowSpan'
	],
	#category : 'DjBlocUI-DeckBody',
	#package : 'DjBlocUI',
	#tag : 'DeckBody'
}

{ #category : 'examples' }
DJBeatGridOverlay class >> example [
	"A 128 bpm grid over a 4 minute track, showing bars 1 to 8."
	<script>
	| grid host space |
	grid := self new.
	grid beats: ((0 to: 31) collect: [ :each | each * 0.5 / 60 ]).
	grid windowFrom: 0 span: 0.25.
	host := DJPanelElement new beMatchingParent; yourself.
	host addChild: grid.
	space := host inSpace.
	space extent: 600 @ 140.
	space title: 'DJBeatGridOverlay'.
	space show
]

{ #category : 'accessing' }
DJBeatGridOverlay >> beats: aCollection [
	"Fractions of the whole track, 0 to 1, one per beat."
	beats := aCollection.
	self rebuild
]

{ #category : 'accessing' }
DJBeatGridOverlay >> beatsPerBar: anInteger [
	beatsPerBar := anInteger.
	self rebuild
]

{ #category : 'initialization' }
DJBeatGridOverlay >> initialize [
	beats := #(  ).
	beatsPerBar := 4.
	windowStart := 0.
	windowSpan := 1.
	super initialize.
	self background: Color transparent.
	self constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical matchParent ].
	self addEventHandlerOn: BlElementExtentChangedEvent do: [ :e | self rebuild ]
]

{ #category : 'accessing' }
DJBeatGridOverlay >> lineAt: aNumber isDownbeat: aBoolean [
	"Downbeats carry the bar; the beats between are hairlines."

	^ BlElement new
		  background: (aBoolean
				   ifTrue: [ DJTheme text ]
				   ifFalse: [ DJTheme dimText ]);
		  extent: (aBoolean
				   ifTrue: [ 2 ]
				   ifFalse: [ 1 ]) @ self height;
		  position: aNumber @ 0;
		  constraintsDo: [ :c | c ignoreByLayout ];
		  yourself
]

{ #category : 'building' }
DJBeatGridOverlay >> rebuild [
	self removeChildren.
	self width > 0 ifFalse: [ ^ self ].
	beats doWithIndex: [ :each :index |
		| x |
		x := self xFor: each.
		(x between: 0 and: self width) ifTrue: [
			self addChild: (self lineAt: x isDownbeat: index \\ beatsPerBar = 1) ] ]
]

{ #category : 'accessing' }
DJBeatGridOverlay >> windowFrom: aStart span: aSpan [
	"The slice of the track my host is showing. An overview passes
	 0 and 1; a scrolling view passes its visible window."
	windowStart := aStart.
	windowSpan := aSpan.
	self rebuild
]

{ #category : 'accessing' }
DJBeatGridOverlay >> xFor: aFraction [
	^ (aFraction - windowStart) / windowSpan * self width
]
