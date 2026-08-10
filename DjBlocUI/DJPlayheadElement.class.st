"
I am a vertical line marking the current play position on a waveform.
 
My playPosition is a fraction of the whole track, 0 to 1. It is never
nil - a deck always has a position, even at zero - so unlike a cue
marker I have nothing to clear.
 
A scrolling view holds me at its centre by moving its window rather than
by moving me; an overview leaves me where the fraction falls. Either way
I hide myself when the position is outside the window.'!
"
Class {
	#name : 'DJPlayheadElement',
	#superclass : 'DJWaveformOverlayElement',
	#instVars : [
		'playPosition',
		'lineColor'
	],
	#category : 'DjBlocUI-DeckBody',
	#package : 'DjBlocUI',
	#tag : 'DeckBody'
}

{ #category : 'examples' }
DJPlayheadElement class >> example [
	"Three playheads at different positions over one strip."
	<script>
	| host space |
	host := DJPanelElement new beMatchingParent; yourself.
	#( 0.2 0.5 0.8 ) do: [ :each |
		host addChild: (DJPlayheadElement new playPosition: each; yourself) ].
	space := host inSpace.
	space extent: 600 @ 140.
	space title: 'DJPlayheadElement'.
	space show
]

{ #category : 'building' }
DJPlayheadElement >> buildContent [
	| x |
	x := self xFor: playPosition.
	(self isVisibleAt: x) ifFalse: [ ^ self ].
	self addChild: (self lineAt: x width: 2 color: lineColor)
]

{ #category : 'initialization' }
DJPlayheadElement >> initialize [
	playPosition := 0.
	lineColor := Color red.
	super initialize
]

{ #category : 'accessing' }
DJPlayheadElement >> lineColor [ 
^ lineColor
]

{ #category : 'accessing' }
DJPlayheadElement >> lineColor: aColor [
	lineColor := aColor.
	self rebuild
]

{ #category : 'accessing' }
DJPlayheadElement >> playPosition [ 

^ playPosition 
]

{ #category : 'accessing' }
DJPlayheadElement >> playPosition: aFraction [
	playPosition := aFraction.
	self rebuild


]
