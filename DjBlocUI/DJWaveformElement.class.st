"
I am a Bloc element that draws the waveform of an audio track.

I do not hold raw PCM. I render a DJAudioThumbnail, which stores a precomputed set of min/max peak pairs, so the cost of drawing is independent of the track length.

A playhead is drawn at trackPosition, expressed as a fraction of the track (0.0 to 1.0). Horizontal detail is controlled by zoomFactor.

## Example, opening a waveform from a file path:
```language=Pharo
	| space |
	space := (DJWaveformElement fromFilePath:
		'/Users/music/myfavouritetune.wav') inSpace.
	space extent: 800 @ 200.
	space title: 'Waveform'.
	space show
```

## Public API and Key Messages

- thumbnail: aDJAudioThumbnail  — install an already built thumbnail
- fromFilePath: aPathOrReference — build the thumbnail from an audio file
- trackPosition: aFraction       — move the playhead
- zoomFactor: aNumber            — set horizontal magnification


Internal Representation and Key Implementation Points

	Instance Variables
		thumbnail:      <DJAudioThumbnail>  peak summary being drawn
		trackPosition:  <Number>            playhead, 0.0 to 1.0
		zoomFactor:     <Number>            horizontal magnification

	Implementation Points

	The domain accessors are prefixed (trackPosition, not position) to
	avoid shadowing the BlElement geometry protocol.
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
	#category : 'DjBlocUI-Waveform',
	#package : 'DjBlocUI',
	#tag : 'Waveform'
}

{ #category : 'instance creation' }
DJWaveformElement class >> fromFilePath: aPath [

	^ self new
		  fromFilePath: aPath;
		  yourself
]

{ #category : 'building' }
DJWaveformElement >> buildPlayhead [

	playheadElement := BlElement new
		                   background: Color red;
		                   extent: 2 @ self extent y;
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

{ #category : 'loading' }
DJWaveformElement >> fromFilePath: aPath [
	"Build and install a thumbnail from a file path (String or FileReference)."

	self thumbnail: (DJAudioThumbnail fromFile: aPath asFileReference fullName)
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

	playheadElement extent: 2 @ self extent y.
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
	self positionBlock: [ aDJPlayer normalizedPosition ]
]

{ #category : 'accessing' }
DJWaveformElement >> positionBlock: aBlock [
	"A block answering 0 to 1. player: wraps a player in one of these."
	playheadPositionBlock := aBlock
]

{ #category : 'building' }
DJWaveformElement >> rebuildWaveGeometry [

	| columns |
	thumbnail ifNil: [ ^ self ].
	columns := thumbnail peaksForColumns: self waveWidth.
	columns isEmpty ifTrue: [ ^ self ].
	waveElement
		extent: self waveWidth @ self extent y;
		geometry: (BlPolygonGeometry vertices: (self verticesFor: columns))
]

{ #category : 'api - tasks' }
DJWaveformElement >> scrollOffset [
	"How far the wave is pushed left. An overview never scrolls and
	 answers 0; I keep the playhead centred until I hit an end."
	^ (playheadPositionBlock value * self waveWidth - (self extent x / 2))
		  clampBetween: 0
		  and: (self waveWidth - self extent x max: 0)
]

{ #category : 'api - tasks' }
DJWaveformElement >> startPlayheadTask [
	self enqueueTask: (BlRepeatedTaskAction new
		delay: 50 milliSeconds;
		action: [ self updatePlayhead ];
		yourself)
]

{ #category : 'accessing' }
DJWaveformElement >> thumbnail: aDJAudioThumbnail [ 
	thumbnail := aDJAudioThumbnail.
	self rebuildWaveGeometry.
	self updatePlayhead
]

{ #category : 'api - tasks' }
DJWaveformElement >> updatePlayhead [
	| x offset |
	x := playheadPositionBlock value * self waveWidth.
	offset := self scrollOffset.
	waveElement position: offset negated @ 0.
	playheadElement position: x - offset @ 0
]

{ #category : 'building' }
DJWaveformElement >> verticesFor: columns [
"Closed polygon: max edge left→right, then min edge right→left. columns: Array of min@max Points, normalized -1.0..1.0.
A short track yields fewer columns than pixels, so x is scaled to waveWidth instead of being taken as the column index."

	| mid top bottom xScale |
	mid := self extent y / 2.
	xScale := self waveWidth / (columns size max: 1).
	top := OrderedCollection new.
	bottom := OrderedCollection new.
	columns doWithIndex: [ :pair :i |
		| x |
		x := (i - 1) * xScale.
		top add: x @ (mid - (pair y * mid)).
		bottom addFirst: x @ (mid - (pair x * mid)) ].
	^ (top , bottom) asArray
]

{ #category : 'geometry' }
DJWaveformElement >> waveWidth [
	"Must agree with the column count rebuildWaveGeometry asks for, or the playhead maps against a width the wave does not have."
	^ (self width * zoomFactor) rounded
]
