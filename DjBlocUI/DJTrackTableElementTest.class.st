Class {
	#name : 'DJTrackTableElementTest',
	#superclass : 'TestCase',
	#instVars : [
		'table'
	],
	#category : 'DjBlocUI-Tests',
	#package : 'DjBlocUI',
	#tag : 'Tests'
}

{ #category : 'running' }
DJTrackTableElementTest >> setUp [

	super setUp.
	table := DJTrackTableElement new.
	table tracks: {
			(DJTrackModel on: nil path: '/music/one.wav' asFileReference).
			(DJTrackModel on: nil path: '/music/two.wav' asFileReference) }
]

{ #category : 'tests' }
DJTrackTableElementTest >> testActionNotEvaluatedWithoutSelection [

	| notified |
	notified := false.
	table trackActivatedAction: [ :aTrack | notified := true ].
	table notifyTrackActivated.
	self deny: notified
]

{ #category : 'tests' }
DJTrackTableElementTest >> testActionReceivesActivatedTrack [

	| notified |
	notified := nil.
	table trackActivatedAction: [ :aTrack | notified := aTrack ].
	table list selecter selectIndex: 1.
	table notifyTrackActivated.
	self deny: notified isNil.
	self assert: notified title equals: 'one.wav'
]

{ #category : 'tests' }
DJTrackTableElementTest >> testColumnDataIndexes [

	| indexes |
	indexes := table columns collect: [ :each | each dataIndex ].
	self assert: indexes asArray equals: #( 'title' 'artist' 'bpm' 'genre' )
]

{ #category : 'tests' }
DJTrackTableElementTest >> testColumnTitles [

	| titles |
	titles := table columns collect: [ :each | each title ].
	self assert: titles asArray equals: #( 'Title' 'Artist' 'BPM' 'Genre' )
]

{ #category : 'tests' }
DJTrackTableElementTest >> testFourColumns [

	self assert: table columns size equals: 4
]

{ #category : 'tests' }
DJTrackTableElementTest >> testNothingSelectedInitially [

	self assert: table selectedTrack isNil
]

{ #category : 'tests' }
DJTrackTableElementTest >> testReplacingTracksClearsSelection [

	table list selecter selectIndex: 1.
	table tracks: { (DJTrackModel on: nil path: '/music/fresh.wav' asFileReference) }.
	self assert: table selectedTrack isNil
]

{ #category : 'tests' }
DJTrackTableElementTest >> testSelectedTrackAfterSelectIndex [

	table list selecter selectIndex: 2.
	self deny: table selectedTrack isNil.
	self assert: table selectedTrack title equals: 'two.wav'
]

{ #category : 'tests' }
DJTrackTableElementTest >> testTracksAreShown [

	self assert: table tracks size equals: 2
]

{ #category : 'tests' }
DJTrackTableElementTest >> testTracksInOrder [

	self assert: table tracks first title equals: 'one.wav'.
	self assert: table tracks last title equals: 'two.wav'
]

{ #category : 'tests' }
DJTrackTableElementTest >> testTracksReplacesPreviousContent [

	table tracks: { (DJTrackModel on: nil path: '/music/only.wav' asFileReference) }.
	self assert: table tracks size equals: 1.
	self assert: table tracks first title equals: 'only.wav'
]
