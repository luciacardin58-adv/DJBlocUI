"
I am the common base for things drawn over a waveform: playheads, beat
grids, cue markers.
 
I hold the window my host is showing - windowStart and windowSpan, both
fractions of the whole track - and turn a track fraction into an x
coordinate through xFor:. An overview passes 0 and 1; a scrolling view
passes its visible slice.
 
I redraw on resize, because I cannot place anything until I know how wide
I am, and again when I enter the scene graph, because a host may set my
content while I am still detached and zero-width.
 
Subclasses override buildContent, and canDraw if they can be empty.
"
Class {
	#name : 'DJWaveformOverlayElement',
	#superclass : 'BlElement',
	#instVars : [
		'windowStart',
		'windowSpan'
	],
	#category : 'DjBlocUI-DeckBody',
	#package : 'DjBlocUI',
	#tag : 'DeckBody'
}

{ #category : 'building' }
DJWaveformOverlayElement >> buildContent [
	^ self subclassResponsibility
]

{ #category : 'building' }
DJWaveformOverlayElement >> canDraw [
	"I cannot place anything before layout has given me a width.
	 Subclasses that can be empty narrow this."
	^ self width > 0
]

{ #category : 'initialization' }
DJWaveformOverlayElement >> initialize [
	windowStart := 0.
	windowSpan := 1.
	super initialize.
	self background: Color transparent.
	self constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical matchParent ].
	self addEventHandlerOn: BlElementExtentChangedEvent do: [ :each |
		self rebuild ]
]

{ #category : 'geometry' }
DJWaveformOverlayElement >> isVisibleAt: aNumber [
	^ aNumber between: 0 and: self width
]

{ #category : 'building' }
DJWaveformOverlayElement >> lineAt: aNumber width: aWidth color: aColor [
	"A full-height vertical rule. Positioned by fraction, so the layout
	 must leave it alone."
	^ BlElement new
		  background: aColor;
		  extent: aWidth @ self height;
		  position: aNumber @ 0;
		  constraintsDo: [ :c | c ignoreByLayout ];
		  yourself
]

{ #category : 'hooks - children' }
DJWaveformOverlayElement >> onAddedToSceneGraph [
	"My content may have been set while I was detached and zero-width."
	super onAddedToSceneGraph.
	self rebuild
]

{ #category : 'building' }
DJWaveformOverlayElement >> rebuild [
	"Template. Subclasses supply buildContent."
	self removeChildren.
	self canDraw ifFalse: [ ^ self ].
	self buildContent
]

{ #category : 'accessing' }
DJWaveformOverlayElement >> windowFrom: aStart span: aSpan [
	"The slice of the track my host is showing."
	windowStart := aStart.
	windowSpan := aSpan.
	self rebuild
]

{ #category : 'accessing' }
DJWaveformOverlayElement >> windowSpan [

	^ windowSpan
]

{ #category : 'accessing' }
DJWaveformOverlayElement >> windowStart [

^ windowStart
]

{ #category : 'geometry' }
DJWaveformOverlayElement >> xFor: aFraction [
	"Track fraction to local x."
	^ (aFraction - windowStart) / windowSpan * self width
]
