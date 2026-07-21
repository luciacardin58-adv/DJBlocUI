"
I am a Bloc element that draws an audio waveform.

I render the min/max peak envelope held by a DJAudioThumbnail,
mirroring the split JUCE uses: the thumbnail owns the peak data
, and I own the drawing (UI layer).


See DJAudioThumbnail for the peak model.
"
Class {
	#name : 'DJWaveformElement',
	#superclass : 'BlElement',
	#instVars : [
		'thumbnail',
		'peaks',
		'zoomFactor',
		'playheadPositionBlock',
		'waveElement',
		'playheadElement',
		'zoomButton'
	],
	#category : 'DjBlocUI',
	#package : 'DjBlocUI'
}

{ #category : 'building' }
DJWaveformElement >> buildPlayhead [
	playheadElement := BlElement new
		background: Color red;
		size: 2 @ self extent y;
		yourself.
	self addChild: playheadElement
]

{ #category : 'building' }
DJWaveformElement >> buildWave [
	waveElement := BlElement new
		background: (Color cyan alpha: 0.8);
		yourself.
	self addChild: waveElement
]

{ #category : 'building' }
DJWaveformElement >> buildZoomButton [
	zoomButton := BlTextElement new
		text: ('x1' asRopedText foreground: Color white);
		padding: (BlInsets all: 6);
		background: (Color gray alpha: 0.6);
		position: 8 @ 8;
		yourself.
	zoomButton addEventHandlerOn: BlClickEvent do: [ :evt | self cycleZoom ].
	self addChild: zoomButton
]

{ #category : 'zoom' }
DJWaveformElement >> cycleZoom [
	zoomFactor := zoomFactor >= self maxZoom
		ifTrue: [ 1 ]
		ifFalse: [ zoomFactor * 2 ].
	zoomButton text: (('x' , zoomFactor asString) asRopedText foreground: Color white).
	self rebuildWaveGeometry.
	self updatePlayhead
]

{ #category : 'initialization' }
DJWaveformElement >> initialize [
	super initialize.
	peaks := #().
	zoomFactor := 1.
	playheadPositionBlock := [ 0 ].
	self clipChildren: true.
	self background: Color black.
	self constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical matchParent ].
	self buildWave.
	self buildPlayhead.
	self buildZoomButton.
	self addEventHandlerOn: BlElementExtentChangedEvent
		do: [ :evt | self onExtentChanged ].
	self startPlayheadTask
]

{ #category : 'accessing' }
DJWaveformElement >> maxZoom [ 
^ 4
]

{ #category : 'api - tasks' }
DJWaveformElement >> onExtentChanged [
	playheadElement size: 2 @ self extent y.
	self rebuildWaveGeometry.
	self updatePlayhead
]

{ #category : 'accessing' }
DJWaveformElement >> peaks: aCollection [
	"aCollection of Points: x = min, y = max, both normalized -1..1"
	peaks := aCollection.
	self rebuildWaveGeometry.
	self updatePlayhead
]

{ #category : 'accessing' }
DJWaveformElement >> player: aDJPlayer [
	"Decouple from the player's API: we only need a 0..1 position"
	playheadPositionBlock := [ aDJPlayer normalizedPosition ]
]

{ #category : 'geometry' }
DJWaveformElement >> rebuildWaveGeometry [
	peaks isEmpty ifTrue: [ ^ self ].
	waveElement
		size: self waveWidth @ self extent y;
		geometry: (BlPolygonGeometry vertices: self waveVertices)
]

{ #category : 'api - tasks' }
DJWaveformElement >> startPlayheadTask [
	self enqueueTask: (BlRepeatedTaskAction new
		delay: 50 milliSeconds;
		action: [ self updatePlayhead ];
		yourself)
]

{ #category : 'api - tasks' }
DJWaveformElement >> updatePlayhead [
	| x offset |
	x := playheadPositionBlock value * self waveWidth.
	offset := (x - (self extent x / 2))
		clampBetween: 0
		and: (self waveWidth - self extent x max: 0).
	waveElement position: offset negated @ 0.
	playheadElement position: (x - offset) @ 0
]

{ #category : 'geometry' }
DJWaveformElement >> waveVertices [
	"Closed polygon: max edge left→right, min edge right→left"
	| mid top bottom |
	mid := self extent y / 2.
	top := OrderedCollection new.
	bottom := OrderedCollection new.
	peaks doWithIndex: [ :pair :i |
		| x |
		x := (i - 1) * zoomFactor.
		top add: x @ (mid - (pair y * mid)).
		bottom addFirst: x @ (mid - (pair x * mid)) ].
	^ (top , bottom) asArray
]

{ #category : 'geometry' }
DJWaveformElement >> waveWidth [ 
^ peaks size * zoomFactor 
]
