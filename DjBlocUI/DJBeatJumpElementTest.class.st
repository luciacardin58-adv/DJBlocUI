Class {
	#name : 'DJBeatJumpElementTest',
	#superclass : 'TestCase',
	#instVars : [
		'jump'
	],
	#category : 'DjBlocUI-Tests',
	#package : 'DjBlocUI',
	#tag : 'Tests'
}

{ #category : 'running' }
DJBeatJumpElementTest >> setUp [
	super setUp.
	jump := DJBeatJumpElement new
]

{ #category : 'tests' }
DJBeatJumpElementTest >> testBeatCountIsSettable [
	jump beatCount: 8.
	self assert: jump beatCount equals: 8
]

{ #category : 'tests' }
DJBeatJumpElementTest >> testDefaultsToFourBeats [
	self assert: jump beatCount equals: 4
]

{ #category : 'tests' }
DJBeatJumpElementTest >> testHasBothButtons [
	"Only the back arrow rendered in the transport bar - the row had
	 no size constraint and collapsed."
	self assert: jump childrenCount equals: 2
]

{ #category : 'tests' }
DJBeatJumpElementTest >> testLaysOutHorizontally [
	self
		assert: jump layout orientation class
		equals: BlLinearLayoutHorizontalOrientation
]
