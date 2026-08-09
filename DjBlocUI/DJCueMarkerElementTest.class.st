Class {
	#name : 'DJCueMarkerElementTest',
	#superclass : 'TestCase',
	#instVars : [
		'marker'
	],
	#category : 'DjBlocUI-Tests',
	#package : 'DjBlocUI',
	#tag : 'Tests'
}

{ #category : 'running' }
DJCueMarkerElementTest >> setUp [
"initialize declares matchParent, which resolves to zero on a
	 detached element. Exact constraints hold through a rebuild."
	super setUp.
	marker := DJCueMarkerElement new.
	marker constraintsDo: [ :c |
		c horizontal exact: 100.
		c vertical exact: 40 ].
]

{ #category : 'tests' }
DJCueMarkerElementTest >> testClearRemovesTheMarker [
	marker cuePosition: 0.5.
	marker clear.
	self deny: marker isSet.
	self assert: marker childrenCount equals: 0
]

{ #category : 'tests' }
DJCueMarkerElementTest >> testDiagnostic [
	| before after |
	before := marker width.
	marker windowFrom: 0.25 span: 0.5.
	after := marker width.
	self assert: { before. after. (marker xFor: 0.75) } equals: #( 100 100 100 )
]

{ #category : 'tests' }
DJCueMarkerElementTest >> testDoesNotOverrideBlocPosition [
	"A slot named position with accessors shadows BlElement >> position,
	 and Bloc's bounds updater then sends x to a Float."
	self deny: (DJCueMarkerElement includesSelector: #position).
	self deny: (DJCueMarkerElement includesSelector: #position:).
	self assert: marker position isPoint
]

{ #category : 'tests' }
DJCueMarkerElementTest >> testRebuildDoesNotAccumulate [
	marker cuePosition: 0.5.
	marker cuePosition: 0.5.
	self assert: marker childrenCount equals: 2
]

{ #category : 'tests' }
DJCueMarkerElementTest >> testScrollingBackIntoViewRedraws [
	marker cuePosition: 0.9.
	marker windowFrom: 0 span: 0.5.
	marker windowFrom: 0.8 span: 0.2.
	self assert: marker childrenCount equals: 2
]

{ #category : 'tests' }
DJCueMarkerElementTest >> testSettingACueDrawsLineAndFlag [
	marker cuePosition: 0.5.
	self assert: marker isSet.
	self assert: marker childrenCount equals: 2
]

{ #category : 'tests' }
DJCueMarkerElementTest >> testStartsUnset [
	"A deck with no cue draws nothing, not a marker at zero."
	self deny: DJCueMarkerElement new isSet.
	self assert: DJCueMarkerElement new childrenCount equals: 0
]

{ #category : 'tests' }
DJCueMarkerElementTest >> testUnsetDrawsNothingEvenWhenSized [
	self assert: marker childrenCount equals: 0
]

{ #category : 'tests' }
DJCueMarkerElementTest >> testWindowStartMapsToLeftEdge [
	marker windowFrom: 0.25 span: 0.5.
	self assert: (marker xFor: 0.75) closeTo: 100
]
