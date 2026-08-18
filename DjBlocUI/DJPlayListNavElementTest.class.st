Class {
	#name : 'DJPlayListNavElementTest',
	#superclass : 'TestCase',
	#instVars : [
		'nav',
		'tempRoot'
	],
	#category : 'DjBlocUI-Tests',
	#package : 'DjBlocUI',
	#tag : 'Tests'
}

{ #category : 'running' }
DJPlayListNavElementTest >> setUp [

	super setUp.
	nav := DJPlaylistNavElement new.
	nav playlists: {
			(DJPlaylist named: 'House').
			(DJPlaylist named: 'Techno') }
]

{ #category : 'tests' }
DJPlayListNavElementTest >> testActionNotEvaluatedWithoutSelection [

	| notified |
	notified := false.
	nav playlistSelectedAction: [ :aPlaylist | notified := true ].
	nav notifyPlaylistSelected.
	self deny: notified
]

{ #category : 'tests' }
DJPlayListNavElementTest >> testActionReceivesSelectedPlaylist [

	| notified |
	notified := nil.
	nav playlistSelectedAction: [ :aPlaylist | notified := aPlaylist ].
	nav selecter selectIndex: 1.
	nav notifyPlaylistSelected.
	self deny: notified isNil.
	self assert: notified name equals: 'House'
]

{ #category : 'tests' }
DJPlayListNavElementTest >> testNothingSelectedInitially [

	self assert: nav selectedPlaylist isNil
]

{ #category : 'tests' }
DJPlayListNavElementTest >> testPlaylistsAreShown [

	self assert: nav playlists size equals: 2
]

{ #category : 'tests' }
DJPlayListNavElementTest >> testPlaylistsInOrder [

	self assert: nav playlists first name equals: 'House'.
	self assert: nav playlists last name equals: 'Techno'
]

{ #category : 'tests' }
DJPlayListNavElementTest >> testPlaylistsReplacesPreviousContent [

	nav playlists: { (DJPlaylist named: 'Only one') }.
	self assert: nav playlists size equals: 1.
	self assert: nav playlists first name equals: 'Only one'
]

{ #category : 'tests' }
DJPlayListNavElementTest >> testReplacingPlaylistsClearsSelection [

	nav selecter selectIndex: 1.
	nav playlists: { (DJPlaylist named: 'Fresh') }.
	self assert: nav selectedPlaylist isNil
]

{ #category : 'tests' }
DJPlayListNavElementTest >> testSelectedPlaylistAfterSelectIndex [

	nav selecter selectIndex: 2.
	self deny: nav selectedPlaylist isNil.
	self assert: nav selectedPlaylist name equals: 'Techno'
]
