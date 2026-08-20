"
I am the row of transport controls under one deck: play, cue and beat jump.

I do not mirror. A right-to-left transport reads badly, so a mirrored deck reverses only its jog, tempo and sync row.
"
Class {
	#name : 'DJTransportBarElement',
	#superclass : 'DJPanelElement',
	#instVars : [
		'playButton',
		'cueButton',
		'beatJump',
		'loadButton'
	],
	#category : 'DjBlocUI-Transport',
	#package : 'DjBlocUI',
	#tag : 'Transport'
}

{ #category : 'examples' }
DJTransportBarElement class >> example [
	<script>
	| space |
	space := self new inSpace.
	space extent: 430 @ 90.
	space title: 'DJTransportBarElement'.
	space show
]

{ #category : 'accessing' }
DJTransportBarElement >> beatJump [
	^ beatJump
]

{ #category : 'accessing' }
DJTransportBarElement >> cueButton [
	^ cueButton
]

{ #category : 'initialization' }
DJTransportBarElement >> initialize [
	super initialize.
	self beRow.
	self constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical exact: 63 ]
]

{ #category : 'initialization' }
DJTransportBarElement >> initializeParts [

	loadButton := DJLoadButtonElement new.
	playButton := DJPlayButtonElement new.
	cueButton := DJCueButtonElement new.
	beatJump := DJBeatJumpElement new.
	self addChildren: {
			loadButton.
			playButton.
			cueButton.
			beatJump }
]

{ #category : 'accessing' }
DJTransportBarElement >> loadAction: aBlock [

	"aBlock is evaluated with no arguments when LOAD is pressed."

	loadButton callback: aBlock
]

{ #category : 'accessing' }
DJTransportBarElement >> loadButton [ 
^ loadButton 
]

{ #category : 'accessing' }
DJTransportBarElement >> playButton [
	^ playButton
]
