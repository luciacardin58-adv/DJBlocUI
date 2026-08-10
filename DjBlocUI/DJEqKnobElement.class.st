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
	"ICKnob reads the ivar directly in initializeGeometry, so what
	 actually sizes me is the constraint DJKnobElement declares from
	 this method."
	^ 30
]

{ #category : 'initialization' }
DJEqKnobElement >> initialize [
	super initialize.
	self minValue: -100.
	self maxValue: 100.
	self setValueSilently: 0.
	self constraintsDo: [ :c |
		c horizontal exact: 80.
		c vertical exact: 80 ]
]

{ #category : 'testing' }
DJEqKnobElement >> isKilled [
	^ self value <= self minValue
]

{ #category : 'testing' }
DJEqKnobElement >> isUnity [
	"The same pixel quantisation as the tempo fader: centre is a
	 window, not a number."
	^ self value abs < 1
]

{ #category : 'helper' }
DJEqKnobElement >> reset [
	self setValueSilently: 0
]
