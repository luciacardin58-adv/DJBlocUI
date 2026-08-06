"
I display a channel's output level as a segmented bar.
I read from a Phausto bargraph on a refresh tick.
"
Class {
	#name : 'DJLevelMeterElement',
	#superclass : 'DJStubElement',
	#category : 'DjBlocUI-MixerStrip',
	#package : 'DjBlocUI',
	#tag : 'MixerStrip'
}

{ #category : 'initialization' }
DJLevelMeterElement >> initialize [
	super initialize.
	self constraintsDo: [ :c |
		c horizontal exact: 24.
		c vertical matchParent ]
]
