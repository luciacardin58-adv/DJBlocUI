Class {
	#name : 'DJConsoleElementTest',
	#superclass : 'TestCase',
	#instVars : [
		'console'
	],
	#category : 'DjBlocUI-Tests',
	#package : 'DjBlocUI',
	#tag : 'Tests'
}

{ #category : 'helpers' }
DJConsoleElementTest >> kickSample [

	^ self sampleNamed: 'kick/BD_dry909.wav'
]

{ #category : 'helpers' }
DJConsoleElementTest >> loadPlaylistWith: aFileReference [
	"Put one track in the browser's table and select it."

	| playlist |
	playlist := DJPlaylist named: 'Test'.
	playlist addTrack: (DJTrackModel on: nil path: aFileReference).
	console browser playlistNav playlists: { playlist }.
	console browser playlistNav selecter selectIndex: 1.
	console browser playlistNav notifyPlaylistSelected.
	console browser trackTable list selecter selectIndex: 1
]

{ #category : 'helpers' }
DJConsoleElementTest >> sampleNamed: aRelativePath [

	| target |
	target := (FileLocator imageDirectory / 'TurboSamples') asFileReference
		          resolve: aRelativePath.
	^ target exists
		  ifTrue: [ target ]
		  ifFalse: [ nil ]
]

{ #category : 'running' }
DJConsoleElementTest >> setUp [

	super setUp.
	console := DJConsoleElement new
]

{ #category : 'tests' }
DJConsoleElementTest >> testLeftDeckLoadButtonLoadsSelectedTrack [

	| sample |
	sample := self kickSample.
	sample ifNil: [ ^ self skip: 'TurboSamples not installed' ].
	self loadPlaylistWith: sample.
	console leftDeck transportBar loadButton callback value.
	self assert: console leftDeck header trackTitle title equals: 'BD_dry909.wav'
]

{ #category : 'tests' }
DJConsoleElementTest >> testLoadSelectedTrackLeavesOtherDeckAlone [

	| sample |
	sample := self kickSample.
	sample ifNil: [ ^ self skip: 'TurboSamples not installed' ].
	self loadPlaylistWith: sample.
	console loadSelectedTrackOnDeck: console leftDeck.
	self deny: console rightDeck header trackTitle title equals: 'BD_dry909.wav'
]

{ #category : 'tests' }
DJConsoleElementTest >> testLoadSelectedTrackOnLeftDeck [

	| sample |
	sample := self kickSample.
	sample ifNil: [ ^ self skip: 'TurboSamples not installed' ].
	self loadPlaylistWith: sample.
	console loadSelectedTrackOnDeck: console leftDeck.
	self assert: console leftDeck header trackTitle title equals: 'BD_dry909.wav'
]

{ #category : 'tests' }
DJConsoleElementTest >> testLoadSelectedTrackOnRightDeck [

	| sample |
	sample := self kickSample.
	sample ifNil: [ ^ self skip: 'TurboSamples not installed' ].
	self loadPlaylistWith: sample.
	console loadSelectedTrackOnDeck: console rightDeck.
	self assert: console rightDeck header trackTitle title equals: 'BD_dry909.wav'
]

{ #category : 'tests' }
DJConsoleElementTest >> testLoadSelectedTrackWithNoSelectionIsNoOp [

	console loadSelectedTrackOnDeck: console leftDeck.
	self assert: console browser selectedTrack isNil
]

{ #category : 'tests' }
DJConsoleElementTest >> testRightDeckLoadButtonLoadsSelectedTrack [

	| sample |
	sample := self kickSample.
	sample ifNil: [ ^ self skip: 'TurboSamples not installed' ].
	self loadPlaylistWith: sample.
	console rightDeck transportBar loadButton callback value.
	self assert: console rightDeck header trackTitle title equals: 'BD_dry909.wav'
]
