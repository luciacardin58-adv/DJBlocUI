"
I draw bar numbers and downbeat lines over a waveform.
I am inert until beat detection provides a grid.
"
Class {
	#name : 'DJBeatGridOverlay',
	#superclass : 'DJWaveformOverlayElement',
	#instVars : [
		'beats',
		'beatsPerBar'
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
DJBeatGridOverlay >> beats [ 
^ beats
]

{ #category : 'accessing' }
DJBeatGridOverlay >> beats: aCollection [
	"Fractions of the whole track, 0 to 1, one per beat."
	beats := aCollection.
	self rebuild
]

{ #category : 'accessing' }
DJBeatGridOverlay >> beatsPerBar [ 
^ beatsPerBar 
]

{ #category : 'accessing' }
DJBeatGridOverlay >> beatsPerBar: anInteger [
	beatsPerBar := anInteger.
	self rebuild
]

{ #category : 'building' }
DJBeatGridOverlay >> buildContent [
	beats doWithIndex: [ :each :index |
		| x |
		x := self xFor: each.
		(self isVisibleAt: x) ifTrue: [
			self addChild: (self lineAt: x isDownbeat: index \\ beatsPerBar = 1) ] ]
]

{ #category : 'initialization' }
DJBeatGridOverlay >> initialize [
	beats := #(  ).
	beatsPerBar := 4.
	super initialize
]

{ #category : 'accessing' }
DJBeatGridOverlay >> lineAt: aNumber isDownbeat: aBoolean [
	"Downbeats carry the bar; the beats between are hairlines."
	^ aBoolean
		  ifTrue: [ self lineAt: aNumber width: 2 color: DJTheme text ]
		  ifFalse: [ self lineAt: aNumber width: 1 color: DJTheme dimText ]
]
