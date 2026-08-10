Class {
	#name : 'DJScrollingWFElementTest',
	#superclass : 'TestCase',
	#instVars : [
		'wave',
		'space'
	],
	#category : 'DjBlocUI-Tests',
	#package : 'DjBlocUI',
	#tag : 'Tests'
}

{ #category : 'running' }
DJScrollingWFElementTest >> setUp [
	"In a space, because width is 0 until layout runs and every
	 window calculation divides by waveWidth."
	super setUp.
	wave := DJScrollingWFElement new.
	space := BlSpace new.
	space extent: 200 @ 100.
	space root addChild: wave.
	space root forceLayout
]

{ #category : 'tests' }
DJScrollingWFElementTest >> testAddOverlayAnswersTheOverlay [
	| marker |
	marker := DJCueMarkerElement new.
	self assert: (wave addOverlay: marker) identicalTo: marker
]

{ #category : 'tests' }
DJScrollingWFElementTest >> testBuildsOverlayLayerOnTopOfTheWave [
	"Wave, playhead, zoom button from the superclass, then my layer -
	 last, so overlays draw over the wave rather than under it."
	self assert: wave childrenCount equals: 4.
	self assert: wave children asArray last identicalTo: wave overlayLayer
]

{ #category : 'tests' }
DJScrollingWFElementTest >> testCueStaysPinnedToItsTrackPositionWhileScrolling [
	"A cue at 0.4 must not move relative to the audio as the window
	 slides. Its x within the view changes; its track fraction does not."
	| marker |
	wave cycleZoom.
	marker := wave addOverlay: (DJCueMarkerElement new cuePosition: 0.4; yourself).
	wave positionBlock: [ 0.2 ].
	wave updatePlayhead.
	wave positionBlock: [ 0.5 ].
	wave updatePlayhead.
	self assert: marker cuePosition equals: 0.4
]

{ #category : 'tests' }
DJScrollingWFElementTest >> testDiagnostic [
	self assert: { wave width. wave waveWidth. wave overlayLayer extent }
		equals: #( 200 200 nil )
]

{ #category : 'tests' }
DJScrollingWFElementTest >> testEveryOverlayGetsTheSameWindow [
	| first second |
	first := wave addOverlay: DJPlayheadElement new.
	second := wave addOverlay: (DJCueMarkerElement new cuePosition: 0.4; yourself).
	wave cycleZoom.
	wave positionBlock: [ 0.5 ].
	wave updatePlayhead.
	self assert: first windowStart equals: second windowStart.
	self assert: first windowSpan equals: second windowSpan
]

{ #category : 'tests' }
DJScrollingWFElementTest >> testOverlayLayerIsIgnoredByLayout [
	self assert: wave overlayLayer constraints ignoredByLayout
]

{ #category : 'tests' }
DJScrollingWFElementTest >> testOverlayLayerMatchesMyExtent [
	wave addOverlay: DJPlayheadElement new.
	wave updatePlayhead.
	self assert: wave overlayLayer extent equals: wave extent
]

{ #category : 'tests' }
DJScrollingWFElementTest >> testOverlayLayerUsesAFrameLayout [
	"A linear layout would stack overlays and split the height."
	self assert: wave overlayLayer layout class equals: BlFrameLayout
]

{ #category : 'tests' }
DJScrollingWFElementTest >> testOverlaysGoIntoTheLayerNotIntoMe [
	wave addOverlay: DJPlayheadElement new.
	self assert: wave overlayLayer childrenCount equals: 1.
	self assert: wave childrenCount equals: 4
]

{ #category : 'tests' }
DJScrollingWFElementTest >> testWindowClampsAtTrackEnd [
	"The wave stops when its right edge reaches the view, so the last
	 visible slice is the final half of the track, not beyond it."
	| overlay |
	wave cycleZoom.
	wave positionBlock: [ 1 ].
	overlay := wave addOverlay: DJPlayheadElement new.
	wave updatePlayhead.
	self assert: overlay windowStart closeTo: 0.5.
	self assert: overlay windowStart + overlay windowSpan closeTo: 1
]

{ #category : 'tests' }
DJScrollingWFElementTest >> testWindowIsHalfTheTrackAtZoomTwo [
	| overlay |
	wave cycleZoom.
	wave positionBlock: [ 0 ].
	wave updatePlayhead.
	overlay := wave addOverlay: DJPlayheadElement new.
	self assert: overlay windowSpan closeTo: 0.5
]

{ #category : 'tests' }
DJScrollingWFElementTest >> testWindowIsWholeTrackAtZoomOne [
	"At zoom 1 the wave exactly fills the view, so the visible slice
	 is the whole track."
	| overlay |
	overlay := wave addOverlay: DJPlayheadElement new.
	self assert: overlay windowStart equals: 0.
	self assert: overlay windowSpan equals: 1
]

{ #category : 'tests' }
DJScrollingWFElementTest >> testWindowStartFollowsTheScroll [
	"Zoom 2: wave 400 wide in a 200 view, halfway means scrollOffset
	 100, so the visible slice starts a quarter into the track."
	| overlay |
	wave cycleZoom.
	wave positionBlock: [ 0.5 ].
	overlay := wave addOverlay: DJPlayheadElement new.
	wave updatePlayhead.
	self assert: overlay windowStart closeTo: 0.25
]

{ #category : 'tests' }
DJScrollingWFElementTest >> testWindowStartIsZeroAtTrackStart [
	| overlay |
	wave cycleZoom.
	wave positionBlock: [ 0 ].
	overlay := wave addOverlay: DJPlayheadElement new.
	wave updatePlayhead.
	self assert: overlay windowStart equals: 0
]
