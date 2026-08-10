Class {
	#name : 'DJFilterKnobElementTest',
	#superclass : 'TestCase',
	#instVars : [
		'knob'
	],
	#category : 'DjBlocUI-Tests',
	#package : 'DjBlocUI',
	#tag : 'Tests'
}

{ #category : 'running' }
DJFilterKnobElementTest >> setUp [
	super setUp.
knob := DJFilterKnobElement new
]

{ #category : 'tests' }
DJFilterKnobElementTest >> testDiameterMatchesTheEqKnobs [
	"They share a strip, so they share a size."
	self assert: knob diameter equals: DJEqKnobElement new diameter
]

{ #category : 'tests' }
DJFilterKnobElementTest >> testIsBipolar [
	self assert: knob minValue equals: -100.
	self assert: knob maxValue equals: 100
]

{ #category : 'tests' }
DJFilterKnobElementTest >> testLeftOfCentreIsLowPass [
	knob setValueSilently: -50.
	self assert: knob isLowPass.
	self deny: knob isHighPass
]

{ #category : 'tests' }
DJFilterKnobElementTest >> testResetBypassesWithoutNotifying [
	| fired |
	fired := OrderedCollection new.
	knob setValueSilently: -70.
	knob callBack: [ :each | fired add: each ].
	knob reset.
	self assert: knob isBypassed.
	self assert: fired isEmpty
]

{ #category : 'tests' }
DJFilterKnobElementTest >> testRightOfCentreIsHighPass [
	knob setValueSilently: 50.
	self assert: knob isHighPass.
	self deny: knob isLowPass
]

{ #category : 'tests' }
DJFilterKnobElementTest >> testSidesAreMutuallyExclusive [
	#( -100 -50 -1 1 50 100 ) do: [ :each |
		knob setValueSilently: each.
		self deny: (knob isLowPass and: [ knob isHighPass ]) ]
]

{ #category : 'tests' }
DJFilterKnobElementTest >> testStartsBypassed [
	self assert: knob isBypassed.
	self deny: knob isLowPass.
	self deny: knob isHighPass
]
