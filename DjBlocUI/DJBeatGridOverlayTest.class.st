Class {
	#name : 'DJBeatGridOverlayTest',
	#superclass : 'TestCase',
	#instVars : [
		'grid'
	],
	#category : 'DjBlocUI-Tests',
	#package : 'DjBlocUI',
	#tag : 'Tests'
}

{ #category : 'running' }
DJBeatGridOverlayTest >> setUp [
	"size: sets the constraint; extent only catches up after a layout
	 pass, and rebuild bails while width is still 0. forceLayout exists
	 for exactly this - see its comment in BlElement."

	super setUp.
	grid := DJBeatGridOverlay new.
	grid extent: 100 @ 40.
	grid forceLayout
]

{ #category : 'tests' }
DJBeatGridOverlayTest >> testBeatsDrawOneLineEach [
	grid beats: #( 0.1 0.2 0.3 ).
	self assert: grid childrenCount equals: 3
]

{ #category : 'tests' }
DJBeatGridOverlayTest >> testDefaultWindowIsTheWholeTrack [
	grid beats: #( 0.0 0.5 1.0 ).
	self assert: grid childrenCount equals: 3
]

{ #category : 'tests' }
DJBeatGridOverlayTest >> testDownbeatIsThickerThanOffbeat [
	grid beats: #( 0.0 0.1 ).
	self assert: grid children asArray first width > grid children asArray second width
]

{ #category : 'tests' }
DJBeatGridOverlayTest >> testEveryFourthBeatIsADownbeat [
	"doWithIndex: is 1-based, so index 1 is the first downbeat."
	| widths |
	grid beats: #( 0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 ).
	widths := grid children asArray collect: [ :each | each width ].
	self assert: (widths copyFrom: 1 to: 4) equals: #( 2 1 1 1 )
]

{ #category : 'tests' }
DJBeatGridOverlayTest >> testLinesAreIgnoredByLayout [
	"Lines are positioned by fraction, so the layout must leave them alone."
	grid beats: #( 0.5 ).
	self assert: grid children asArray first constraints ignoredByLayout
]

{ #category : 'tests' }
DJBeatGridOverlayTest >> testRebuildDoesNotAccumulate [
	"rebuild removes children first; without that, every scroll tick
	 would add a fresh set of lines on top of the old ones."
	grid beats: #( 0.1 0.2 0.3 ).
	grid beats: #( 0.1 0.2 0.3 ).
	self assert: grid childrenCount equals: 3
]

{ #category : 'tests' }
DJBeatGridOverlayTest >> testStartsInert [
	"No detection yet, so an empty grid is the normal state."
	self assert: DJBeatGridOverlay new beats isEmpty.
	self assert: DJBeatGridOverlay new childrenCount equals: 0
]

{ #category : 'tests' }
DJBeatGridOverlayTest >> testWindowChangeRedraws [
	grid beats: #( 0.1 0.2 0.9 ).
	grid windowFrom: 0.8 span: 0.2.
	self assert: grid childrenCount equals: 1
]

{ #category : 'tests' }
DJBeatGridOverlayTest >> testWindowEndMapsToRightEdge [
	grid windowFrom: 0.25 span: 0.5.
	self assert: (grid xFor: 0.75) closeTo: 100
]

{ #category : 'tests' }
DJBeatGridOverlayTest >> testWindowStartMapsToLeftEdge [
	grid windowFrom: 0.25 span: 0.5.
	self assert: (grid xFor: 0.25) closeTo: 0
]
