Class {
	#name : 'DJEqKnobElementTest',
	#superclass : 'TestCase',
	#instVars : [
		'knob'
	],
	#category : 'DjBlocUI-Tests',
	#package : 'DjBlocUI',
	#tag : 'Tests'
}

{ #category : 'running' }
DJEqKnobElementTest >> setUp [
	super setUp.

	knob := DJEqKnobElement new
]

{ #category : 'tests' }
DJEqKnobElementTest >> testBoostIsNotUnity [
	knob setValueSilently: 50.
	self deny: knob isUnity.
	self deny: knob isKilled
]

{ #category : 'tests' }
DJEqKnobElementTest >> testDiameterIsSmallerThanTheCoypuDefault [
	"Three stack in one strip; at 60 the frames do not fit."
	self assert: knob diameter equals: 30
]

{ #category : 'tests' }
DJEqKnobElementTest >> testFullLeftIsKill [
	knob setValueSilently: -100.
	self assert: knob isKilled
]

{ #category : 'tests' }
DJEqKnobElementTest >> testIsBipolar [
	self assert: knob minValue equals: -100.
	self assert: knob maxValue equals: 100
]

{ #category : 'tests' }
DJEqKnobElementTest >> testResetReturnsToUnityWithoutNotifying [
	| fired |
	fired := OrderedCollection new.
	knob setValueSilently: 60.
	knob callBack: [ :each | fired add: each ].
	knob reset.
	self assert: knob isUnity.
	self assert: fired isEmpty
]

{ #category : 'tests' }
DJEqKnobElementTest >> testStartsAtUnity [
	"initializeDefaultValues left the value at the old minimum, so it
	 has to be restated once the range is right."
	self assert: knob value closeTo: 0.
	self assert: knob isUnity
]

{ #category : 'tests' }
DJEqKnobElementTest >> testUnityIsAWindowNotANumber [
	"Pixel quantisation means a centred knob lands near zero."
	knob setValueSilently: 0.4.
	self assert: knob isUnity
]
