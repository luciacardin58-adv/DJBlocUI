"
I am a channel''s bipolar filter knob: low-pass left of centre, high-pass right. Centre is bypass.

Like the EQ knobs I answer -100 to 100 and leave the cutoff mapping to the deck. isLowPass and isHighPass say which side I am on so a caller does not have to know which sign means what.
"
Class {
	#name : 'DJFilterKnobElement',
	#superclass : 'DJKnobElement',
	#category : 'DjBlocUI-MixerStrip',
	#package : 'DjBlocUI',
	#tag : 'MixerStrip'
}

{ #category : 'examples' }
DJFilterKnobElement class >> example [
	<script>
	| container space |
	container := DJPanelElement new beMatchingParent; yourself.
	container addChild: (self label: 'FILTER').
	space := container inSpace.
	space extent: 200 @ 200.
	space title: 'DJFilterKnobElement'.
	space show
]

{ #category : 'accessing' }
DJFilterKnobElement >> diameter [ 
^ 30
]

{ #category : 'initialization' }
DJFilterKnobElement >> initialize [
	super initialize.
	self minValue: -100.
	self maxValue: 100.
	self setValueSilently: 0.
	self constraintsDo: [ :c |
		c horizontal exact: 80.
		c vertical exact: 80 ]
]

{ #category : 'testing' }
DJFilterKnobElement >> isBypassed [
	^ self value abs < 1
]

{ #category : 'testing' }
DJFilterKnobElement >> isHighPass [
	^ self value > 0
]

{ #category : 'testing' }
DJFilterKnobElement >> isLowPass [
	^ self value < 0
]

{ #category : 'helper' }
DJFilterKnobElement >> reset [
	self setValueSilently: 0
]
