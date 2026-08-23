"
I am a back/forward pair around a beat-count selector.
I move playback by whole beats
"
Class {
	#name : 'DJBeatJumpElement',
	#superclass : 'DJPanelElement',
	#instVars : [
		'backButton',
		'forwardButton',
		'beatCount'
	],
	#category : 'DjBlocUI-Transport',
	#package : 'DjBlocUI',
	#tag : 'Transport'
}

{ #category : 'accessing' }
DJBeatJumpElement >> beatCount [

^ beatCount 
]

{ #category : 'accessing' }
DJBeatJumpElement >> beatCount: anInteger [

	beatCount := anInteger 
]

{ #category : 'initialization' }
DJBeatJumpElement >> initialize [


	beatCount := 4.
	super initialize.
	self beBare.
	self beRow.
	self constraintsDo: [ :c |
		c horizontal fitContent.
		c vertical fitContent ]
]

{ #category : 'initialization' }
DJBeatJumpElement >> initializeParts [ 
	backButton := DJButtonElement label: '<'.
	forwardButton := DJButtonElement label: '>'.
	{ backButton. forwardButton } do: [ :each |
		each widgetSize: DJTheme buttonHeight asPoint ].
	self addChildren: { backButton. forwardButton }
]
