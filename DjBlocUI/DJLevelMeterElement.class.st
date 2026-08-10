"
DJLevelMeterElement comment: 'I display a channel''s output level as a segmented bar.

I light from the bottom up: green through most of my range, amber near the top, red at the last segment. My level is a fraction, 0 to 1.

Like DJWaveformElement I take a block rather than an object, so I can be driven by a Phausto bargraph without knowing what one is. Until that is wired my block answers 0 and I sit dark.'
"
Class {
	#name : 'DJLevelMeterElement',
	#superclass : 'DJPanelElement',
	#instVars : [
		'segments',
		'levelBlock'
	],
	#category : 'DjBlocUI-MixerStrip',
	#package : 'DjBlocUI',
	#tag : 'MixerStrip'
}

{ #category : 'examples' }
DJLevelMeterElement class >> example [
	<script>
	| meter container space level |
	level := 0.
	meter := self new.
	meter levelBlock: [ level ].
	meter enqueueTask: (BlRepeatedTaskAction new
			 delay: 80 milliSeconds;
			 action: [
				 level := level + 0.05.
				 level > 1.1 ifTrue: [ level := 0 ].
				 meter refresh ];
			 yourself).
	container := DJPanelElement new beRow; beMatchingParent; yourself.
	container addChild: meter.
	space := container inSpace.
	space extent: 120 @ 260.
	space title: 'DJLevelMeterElement'.
	space show
]

{ #category : 'accessing' }
DJLevelMeterElement >> colorAt: anIndex [
	"Bottom eight green, next three amber, the last one red."
	anIndex <= 8 ifTrue: [ ^ Color green muchDarker ].
	anIndex <= 11 ifTrue: [ ^ Color orange ].
	^ Color red
]

{ #category : 'initialization' }
DJLevelMeterElement >> initialize [
	"levelBlock before super initialize: initializeParts reads it."
	levelBlock := [ 0 ].
	super initialize.
	self constraintsDo: [ :c |
		c horizontal exact: 24.
		c vertical matchParent ]
]

{ #category : 'initialization' }
DJLevelMeterElement >> initializeParts [
	"segments runs bottom to top, but a vertical layout renders first
	 child at the top - so they go in reversed."
	segments := (1 to: self segmentCount) collect: [ :each |
		            BlElement new
			            background: DJTheme hairline;
			            constraintsDo: [ :c |
				            c horizontal matchParent.
				            c vertical exact: 12 ];
			            yourself ].
	self addChildren: segments reversed
]

{ #category : 'accessing' }
DJLevelMeterElement >> level: aFraction [
	"0 to 1. Anything above 1 pins at full rather than overflowing."
	| lit |
	lit := ((aFraction min: 1) max: 0) * self segmentCount.
	segments doWithIndex: [ :each :index |
		each background: (index <= lit
				 ifTrue: [ self colorAt: index ]
				 ifFalse: [ DJTheme hairline ]) ]
]

{ #category : 'accessing' }
DJLevelMeterElement >> levelBlock: aBlock [
	"A block answering 0 to 1."
	levelBlock := aBlock
]

{ #category : 'helper' }
DJLevelMeterElement >> refresh [
	self level: levelBlock value
]

{ #category : 'accessing' }
DJLevelMeterElement >> segmentCount [ 
^ 12
]

{ #category : 'accessing' }
DJLevelMeterElement >> segments [ 
^ segments
]
