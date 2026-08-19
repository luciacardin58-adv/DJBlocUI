Class {
	#name : 'DJTransportBarElementTest',
	#superclass : 'TestCase',
	#instVars : [
		'bar'
	],
	#category : 'DjBlocUI-Tests',
	#package : 'DjBlocUI',
	#tag : 'Tests'
}

{ #category : 'running' }
DJTransportBarElementTest >> setUp [
	super setUp.
	bar := DJTransportBarElement new
]

{ #category : 'tests' }
DJTransportBarElementTest >> testAccessorsAnswerRealChildren [
	"A body pasted as [ ^ ivar ] compiles to an unused block and the
	 method answers self."
	| broken |
	broken := #( playButton cueButton beatJump ) select: [ :each |
		          (bar perform: each) == bar ].
	self
		assert: broken isEmpty
		description: 'dead block in: ' , broken asArray printString
]

{ #category : 'tests' }
DJTransportBarElementTest >> testControlOrder [


	self assert: bar children asArray equals: {
			bar loadButton.
			bar playButton.
			bar cueButton.
			bar beatJump }
]

{ #category : 'tests' }
DJTransportBarElementTest >> testHasLoadButton [

	
	self assert: bar loadButton class equals: DJLoadButtonElement
]

{ #category : 'tests' }
DJTransportBarElementTest >> testHasThreeControls [
	self assert: bar childrenCount equals: 4
]

{ #category : 'tests' }
DJTransportBarElementTest >> testLaysOutHorizontally [
	self
		assert: bar layout orientation class
		equals: BlLinearLayoutHorizontalOrientation
]

{ #category : 'tests' }
DJTransportBarElementTest >> testLoadButtonIsFirst [


	self assert: bar children first equals: bar loadButton
]
