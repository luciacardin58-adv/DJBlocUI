"
I hold the HIGH, MID and LOW EQ knobs for one channel.
Each is bipolar: centre is unity, full left is kill.
"
Class {
	#name : 'DJEqControlsElement',
	#superclass : 'DJPanelElement',
	#instVars : [
		'highKnob',
		'midKnob',
		'lowKnob'
	],
	#category : 'DjBlocUI-MixerStrip',
	#package : 'DjBlocUI',
	#tag : 'MixerStrip'
}

{ #category : 'examples' }
DJEqControlsElement class >> example [

	<script>
	| space |
	space := self new inSpace.
	space extent: 200 @ 420.
	space title: 'DJEqControlsElement'.
	space show
]

{ #category : 'accessing' }
DJEqControlsElement >> highKnob [ 
^ highKnob 
]

{ #category : 'initialization' }
DJEqControlsElement >> initialize [
	super initialize.
	self constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical fitContent ]
]

{ #category : 'initialization' }
DJEqControlsElement >> initializeParts [
	highKnob := DJEqKnobElement label: 'HIGH'.
	midKnob := DJEqKnobElement label: 'MID'.
	lowKnob := DJEqKnobElement label: 'LOW'.
	self addChildren: { highKnob. midKnob. lowKnob }
]

{ #category : 'accessing' }
DJEqControlsElement >> knobs [
	^ { highKnob. midKnob. lowKnob }
]

{ #category : 'accessing' }
DJEqControlsElement >> lowKnob [ 
^ lowKnob 
]

{ #category : 'accessing' }
DJEqControlsElement >> midKnob [ 
^ midKnob 
]

{ #category : 'helper' }
DJEqControlsElement >> resetAll [
	self knobs do: [ :each | each reset ]
]
