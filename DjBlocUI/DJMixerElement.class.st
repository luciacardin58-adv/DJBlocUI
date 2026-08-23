"
I am  =two strips over a crossfader
"
Class {
	#name : 'DJMixerElement',
	#superclass : 'DJPanelElement',
	#instVars : [
		'leftStrip',
		'rightStrip',
		'crossfader'
	],
	#category : 'DjBlocUI-Root',
	#package : 'DjBlocUI',
	#tag : 'Root'
}

{ #category : 'defaults' }
DJMixerElement class >> defaultWidth [ 

^ 340
]

{ #category : 'building' }
DJMixerElement >> buildStripsRow [
| row |
    leftStrip := DJChannelStripElement new.
    rightStrip := DJChannelStripElement new.
 
    row := DJPanelElement new
               beRow;
               background: Color transparent;
               border: BlBorder empty;
               padding: BlInsets empty;
               yourself.
    row constraintsDo: [ :c |
        c horizontal matchParent.
        c vertical matchParent ].
    row addChildren: { leftStrip. rightStrip }.
    ^ row
]

{ #category : 'accessing' }
DJMixerElement >> crossfader [ 
^ crossfader
]

{ #category : 'initialization' }
DJMixerElement >> initialize [
 
    super initialize.
    self constraintsDo: [ :c |
        c horizontal exact: 340.
        c vertical matchParent ]
 
]

{ #category : 'initialization' }
DJMixerElement >> initializeParts [

	crossfader := DJCrossfaderElement new.
	crossfader spanWidth: self class defaultWidth - (DJTheme gap * 2).
	self addChild: self buildStripsRow.
	self addChild: crossfader
]

{ #category : 'accessing' }
DJMixerElement >> leftStrip [ 
^ leftStrip 
]

{ #category : 'accessing' }
DJMixerElement >> rightStrip [

^ rightStrip
]
