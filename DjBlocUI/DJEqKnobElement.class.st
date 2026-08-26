"
I am one EQ band knob for a channel: high, mid or low.

I am bipolar. Centre is unity gain, full left is kill, full right is boost. My range is -100 to 100 rather than dB.

I answer a smaller diameter than ICKnob''s default 60. Three of me stack in one strip, and at 60 the frame is 160 apiece, which does not fit.
"
Class {
	#name : 'DJEqKnobElement',
	#superclass : 'DJKnobElement',
	#category : 'DjBlocUI-MixerStrip',
	#package : 'DjBlocUI',
	#tag : 'MixerStrip'
}

{ #category : 'defaults' }
DJEqKnobElement class >> defaultDiameter [ 
"Three of us stack in one strip; ICKnob's 60 gives a 160pt frame apiece, which does not fit."

	^ 18
]

{ #category : 'examples' }
DJEqKnobElement class >> example [
	<script>
	| container space |
	container := DJPanelElement new beMatchingParent; yourself.
	container addChild: (self label: 'MID').
	space := container inSpace.
	space extent: 200 @ 200.
	space title: 'DJEqKnobElement'.
	space show
]

{ #category : 'accessing' }
DJEqKnobElement >> diameter [
"ICKnob reads the ivar directly in initializeGeometry, so what actually sizes me is the constraint DJKnobElement declares from this method."
	^ 18
]

{ #category : 'initialization' }
DJEqKnobElement >> initialize [

super initialize.
	self diameter: self class defaultDiameter.
	self minValue: -100.
	self maxValue: 100.
	self setValueSilently: 0
]

{ #category : 'testing' }
DJEqKnobElement >> isKilled [
	^ self currentValue <= self minValue
]

{ #category : 'testing' }
DJEqKnobElement >> isUnity [
	"The same pixel quantisation as the tempo fader: centre is a
	 window, not a number."
	^ self currentValue abs < 1
]

{ #category : 'accessing' }
DJEqKnobElement >> maxValue: aNumber [ 
	super maxValue: aNumber.
	maxLabel text: '' asRopedText
]

{ #category : 'accessing' }
DJEqKnobElement >> minValue: aNumber [
"ICKnob prints the range into minLabel and maxLabel, which share thebottom band with currentLabel and overprint it at our diameter. Therange is fixed and known from the strip, so only the current valueearns the room. The elements stay, blank: applyLabelSizes sendstransformDo: to both without a nil guard."

	super minValue: aNumber.
	minLabel text: '' asRopedText
]

{ #category : 'helper' }
DJEqKnobElement >> reset [
	self setValueSilently: 0
]
