"
I am a zoomed window of a track, scrolling under a fixed centre playhead.

My superclass already does the scrolling: it moves the wave left byscrollOffset and holds the playhead centred until it reaches an end.
What I add is a layer for overlays, and the job of telling them which slice of the track is currently visible.

Overlays sit on top of each other, so my layer uses a frame layout. Alinear one would stack them and split the height between them.s
"
Class {
	#name : 'DJScrollingWFElement',
	#superclass : 'DJWaveformElement',
	#instVars : [
		'overlayLayer'
	],
	#category : 'DjBlocUI-DeckBody',
	#package : 'DjBlocUI',
	#tag : 'DeckBody'
}

{ #category : 'examples' }
DJScrollingWFElement class >> example [
	"A cue at 40 percent and a 128 bpm grid, over a wave scrolling
	 under a centred playhead. Click the zoom button to see the
	 overlays follow."
	<script>
	| wave space position |
	position := 0.
	wave := self new.
	wave positionBlock: [ position ].
	wave addOverlay: (DJCueMarkerElement new
			 label: 'A';
			 cuePosition: 0.4;
			 yourself).
	wave addOverlay: (DJBeatGridOverlay new
			 beats: ((0 to: 63) collect: [ :each | each / 64 ]);
			 yourself).
	wave enqueueTask: (BlRepeatedTaskAction new
			 delay: 50 milliSeconds;
			 action: [ position := position + 0.002 min: 1 ];
			 yourself).
	space := wave inSpace.
	space extent: 600 @ 140.
	space title: 'DJScrollingWFElement'.
	space show
]

{ #category : 'accessing' }
DJScrollingWFElement >> addOverlay: aDJWaveformOverlayElement [
	"Beat grid, cue markers, playhead. I push the visible window to
	 them, so they need to know nothing about zoom or scrolling."
	overlayLayer addChild: aDJWaveformOverlayElement.
	self updateOverlays.
	^ aDJWaveformOverlayElement
]

{ #category : 'building' }
DJScrollingWFElement >> buildOverlayLayer [
	overlayLayer := BlElement new
		                layout: BlFrameLayout new;
		                background: Color transparent;
		                constraintsDo: [ :c | c ignoreByLayout ];
		                yourself.
	self addChild: overlayLayer
]

{ #category : 'initialization' }
DJScrollingWFElement >> initialize [
	super initialize.
	self buildOverlayLayer
]

{ #category : 'accessing' }
DJScrollingWFElement >> overlayLayer [ 
^ overlayLayer 
]

{ #category : 'api - tasks' }
DJScrollingWFElement >> updateOverlays [

	| total |
	total := self waveWidth.
	total > 0 ifFalse: [ ^ self ].
	overlayLayer extent: self extent.
	overlayLayer forceLayout.
	overlayLayer childrenDo: [ :each |
		each
			windowFrom: self scrollOffset / total
			span: self extent x / total ]
]

{ #category : 'api - tasks' }
DJScrollingWFElement >> updatePlayhead [
	super updatePlayhead.
	self updateOverlays
]
