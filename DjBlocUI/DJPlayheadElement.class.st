"
I am a vertical line marking the current play position on a waveform.I am a vertical line marking the current play position on a waveform.

My playPosition is a fraction of the whole track, 0 to 1. Not position:
- BlElement owns that selector.

A scrolling view holds me at its centre and moves the waveform under me;
an overview leaves me where the fraction falls. Either way I hide myself
when the position is outside the window I was given.
"
Class {
	#name : 'DJPlayheadElement',
	#superclass : 'BlElement',
	#instVars : [
		'playPosition',
		'windowStart',
		'windowSpan',
		'lineColor'
	],
	#category : 'DjBlocUI-DeckBody',
	#package : 'DjBlocUI',
	#tag : 'DeckBody'
}

{ #category : 'initialization' }
DJPlayheadElement >> initialize [
	playPosition := 0.
	windowStart := 0.
	windowSpan := 1.
	lineColor := Color red.
	super initialize.
	self background: Color transparent.
	self constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical matchParent ].
	self addEventHandlerOn: BlElementExtentChangedEvent do: [ :e | self rebuild ]
]

{ #category : 'accessing' }
DJPlayheadElement >> playPosition: aFraction [
	playPosition := aFraction.
	self rebuild


]

{ #category : 'building' }
DJPlayheadElement >> rebuild [
	| x |
	self removeChildren.
	self width > 0 ifFalse: [ ^ self ].
	x := self xFor: playPosition.
	(x between: 0 and: self width) ifFalse: [ ^ self ].
	self addChild: (self lineAt: x)
]
