Class {
	#name : 'DJWaveformElementTest',
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
DJWaveformElementTest >> setUp [
	"In a space, because width is 0 until layout runs and every
	 geometry method divides by it."
	super setUp.
	wave := DJWaveformElement new.
	space := BlSpace new.
	space extent: 200 @ 100.
	space root addChild: wave.
	space root forceLayout
]

{ #category : 'tests' }
DJWaveformElementTest >> testBuildsWavePlayheadAndZoomButton [
	self assert: wave childrenCount equals: 3
]

{ #category : 'tests' }
DJWaveformElementTest >> testCycleZoomWrapsAtMax [
	wave cycleZoom.
	wave cycleZoom.
	self assert: wave waveWidth equals: 800.
	wave cycleZoom.
	self assert: wave waveWidth equals: 200
]

{ #category : 'tests' }
DJWaveformElementTest >> testDefaultZoomIsOne [
	self assert: wave waveWidth equals: 200
]

{ #category : 'tests' }
DJWaveformElementTest >> testPlayheadSitsAtCentreWhileScrolling [
	| playhead |
	wave cycleZoom.
	wave positionBlock: [ 0.5 ].
	wave updatePlayhead.
	playhead := wave children asArray second.
	self assert: playhead position x equals: 100
]

{ #category : 'tests' }
DJWaveformElementTest >> testPlayheadSpansTheFullHeight [
	self assert: wave children asArray second extent equals: 2 @ 100
]

{ #category : 'tests' }
DJWaveformElementTest >> testScrollOffsetCentresThePlayheadMidTrack [
	"Zoom 2: wave 400 wide in a 200 view. Halfway is x 200, so the
	 wave is pushed left 100 to bring it to the centre."
	wave cycleZoom.
	wave positionBlock: [ 0.5 ].
	self assert: wave scrollOffset equals: 100
]

{ #category : 'tests' }
DJWaveformElementTest >> testScrollOffsetClampsAtTrackEnd [
	"The wave stops when its right edge reaches the right of the view,
	 so the playhead runs on past centre instead."
	wave cycleZoom.
	wave positionBlock: [ 1 ].
	self assert: wave scrollOffset equals: 200
]

{ #category : 'tests' }
DJWaveformElementTest >> testScrollOffsetIsZeroAtTrackStart [
	wave cycleZoom.
	wave positionBlock: [ 0 ].
	self assert: wave scrollOffset equals: 0
]

{ #category : 'tests' }
DJWaveformElementTest >> testVerticesClosesThePolygon [
	"One vertex per column on the top edge, one on the bottom."
	self
		assert: (wave verticesFor: { 0 @ 0. -1 @ 1 }) size
		equals: 4
]

{ #category : 'tests' }
DJWaveformElementTest >> testVerticesMirrorAroundTheMidline [
	"A full-scale column reaches both edges of a 100 high element."
	| vertices |
	vertices := wave verticesFor: { -1 @ 1 }.
	self assert: vertices first y equals: 0.
	self assert: vertices last y equals: 100
]

{ #category : 'tests' }
DJWaveformElementTest >> testWaveIsPushedLeftByTheScrollOffset [
	| waveChild |
	wave cycleZoom.
	wave positionBlock: [ 0.5 ].
	wave updatePlayhead.
	waveChild := wave children asArray first.
	self assert: waveChild position x equals: -100
]

{ #category : 'tests' }
DJWaveformElementTest >> testWaveWidthTracksZoom [
	wave cycleZoom.
	self assert: wave waveWidth equals: 400
]
