Class {
	#name : 'DJChannelFaderElementTest',
	#superclass : 'TestCase',
	#instVars : [
		'fader'
	],
	#category : 'DjBlocUI-Tests',
	#package : 'DjBlocUI',
	#tag : 'Tests'
}

{ #category : 'running' }
DJChannelFaderElementTest >> setUp [
	super setUp.

	fader := DJChannelFaderElement new
]

{ #category : 'tests' }
DJChannelFaderElementTest >> testGainIsZeroToOne [
	self assert: fader gain closeTo: 1.
	fader setValueSilently: 50.
	self assert: fader gain closeTo: 0.5.
	fader setValueSilently: 0.
	self assert: fader gain closeTo: 0
]

{ #category : 'tests' }
DJChannelFaderElementTest >> testRangeIsZeroToOneHundred [
	self assert: fader minValue equals: 0.
	self assert: fader maxValue equals: 100
]

{ #category : 'tests' }
DJChannelFaderElementTest >> testSetValueSilentlyDoesNotNotify [
	| fired |
	fired := OrderedCollection new.
	fader callBack: [ :each | fired add: each ].
	fader setValueSilently: 40.
	self assert: fader gain closeTo: 0.4.
	self assert: fired isEmpty
]

{ #category : 'tests' }
DJChannelFaderElementTest >> testSetValueStillNotifies [
	| fired |
	fired := OrderedCollection new.
	fader callBack: [ :each | fired add: each ].
	fader setValue: 40.
	self assert: fired size equals: 1
]

{ #category : 'tests' }
DJChannelFaderElementTest >> testSilenceIsAWindowNotANumber [
	fader setValueSilently: 0.4.
	self assert: fader isSilent
]

{ #category : 'tests' }
DJChannelFaderElementTest >> testStartsOpen [
	"initializeValues leaves the value at minValue, which for a volume
	 fader means a channel that loads silent and looks broken."
	self assert: fader value closeTo: 100.
	self deny: fader isSilent
]
