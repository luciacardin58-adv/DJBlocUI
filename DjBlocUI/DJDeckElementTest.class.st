Class {
	#name : 'DJDeckElementTest',
	#superclass : 'TestCase',
	#instVars : [
		'deck'
	],
	#category : 'DjBlocUI-Tests',
	#package : 'DjBlocUI',
	#tag : 'Tests'
}

{ #category : 'helpers' }
DJDeckElementTest >> clapSample [

	^ self sampleNamed: 'clap/CP_light909.wav'
]

{ #category : 'helpers' }
DJDeckElementTest >> kickSample [

	^ self sampleNamed: 'kick/BD_dry909.wav'
]

{ #category : 'helpers' }
DJDeckElementTest >> sampleNamed: aRelativePath [
	"Answer a TurboSamples file next to the image, or nil when Phausto's
	 samples are not installed."

	| target |
	target := (FileLocator imageDirectory / 'TurboSamples') asFileReference
		          resolve: aRelativePath.
	^ target exists
		  ifTrue: [ target ]
		  ifFalse: [ nil ]
]

{ #category : 'running' }
DJDeckElementTest >> setUp [

	super setUp.
	deck := DJDeckElement new
]

{ #category : 'tests' }
DJDeckElementTest >> testLoadTrackReplacesPreviousTitle [

	| kick clap |
	kick := self kickSample.
	clap := self clapSample.
	(kick isNil or: [ clap isNil ]) ifTrue: [ ^ self skip: 'TurboSamples not installed' ].
	deck loadTrack: (DJTrackModel on: nil path: kick).
	deck loadTrack: (DJTrackModel on: nil path: clap).
	self assert: deck header trackTitle title equals: 'CP_light909.wav'
]

{ #category : 'tests' }
DJDeckElementTest >> testLoadTrackSetsHeaderTitle [

	| sample |
	sample := self kickSample.
	sample ifNil: [ ^ self skip: 'TurboSamples not installed' ].
	deck loadTrack: (DJTrackModel on: nil path: sample).
	self assert: deck header trackTitle title equals: 'BD_dry909.wav'
]

{ #category : 'tests' }
DJDeckElementTest >> testLoadTrackWithoutMetadataUsesBasename [

	| sample track |
	sample := self kickSample.
	sample ifNil: [ ^ self skip: 'TurboSamples not installed' ].
	track := DJTrackModel on: nil path: sample.
	self deny: track hasMetadata.
	deck loadTrack: track.
	self assert: deck header trackTitle title equals: track title
]
