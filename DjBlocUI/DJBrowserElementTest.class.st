Class {
	#name : 'DJBrowserElementTest',
	#superclass : 'TestCase',
	#instVars : [
		'browser'
	],
	#category : 'DjBlocUI-Tests',
	#package : 'DjBlocUI',
	#tag : 'Tests'
}

{ #category : 'running' }
DJBrowserElementTest >> setUp [

	super setUp.
	browser := DJBrowserElement new
]

{ #category : 'tests' }
DJBrowserElementTest >> testActivatingTrackEvaluatesLoadAction [

	| playlist notified |
	notified := nil.
	playlist := DJPlaylist named: 'House'.
	playlist addTrack: (DJTrackModel on: nil path: '/music/one.wav' asFileReference).
	browser playlistNav playlists: { playlist }.
	browser playlistNav selecter selectIndex: 1.
	browser playlistNav notifyPlaylistSelected.
	browser trackLoadAction: [ :aTrack | notified := aTrack ].
	browser trackTable list selecter selectIndex: 1.
	browser trackTable notifyTrackActivated.
	self deny: notified isNil.
	self assert: notified title equals: 'one.wav'
]

{ #category : 'tests' }
DJBrowserElementTest >> testBothPartsAreChildren [

	self assert: (browser children includes: browser sidebar).
	self assert: (browser children includes: browser trackTable)
]

{ #category : 'tests' }
DJBrowserElementTest >> testFolderSelectionDoesNotTouchTable [
	"Folder selection is intentionally inert until drag-and-drop lands."

	browser rootFolder: FileLocator imageDirectory.
	browser folderNav selecter selectIndex: 1.
	browser folderNav notifyFolderSelected.
	self assert: browser trackTable tracks isEmpty
]

{ #category : 'tests' }
DJBrowserElementTest >> testForwardsFolderNav [

	self assert: browser folderNav equals: browser sidebar folderNav
]

{ #category : 'tests' }
DJBrowserElementTest >> testForwardsPlaylistNav [

	self assert: browser playlistNav equals: browser sidebar playlistNav
]

{ #category : 'tests' }
DJBrowserElementTest >> testHasSidebar [

	self assert: browser sidebar class equals: DJBrowserSidebarElement
]

{ #category : 'tests' }
DJBrowserElementTest >> testHasTrackTable [

	self assert: browser trackTable class equals: DJTrackTableElement
]

{ #category : 'tests' }
DJBrowserElementTest >> testLoadActionNotEvaluatedWithoutSelection [

	| notified |
	notified := false.
	browser trackLoadAction: [ :aTrack | notified := true ].
	browser trackTable notifyTrackActivated.
	self deny: notified
]

{ #category : 'tests' }
DJBrowserElementTest >> testSelectingAnotherPlaylistReplacesTable [

	| first second |
	first := DJPlaylist named: 'House'.
	first addTrack: (DJTrackModel on: nil path: '/music/one.wav' asFileReference).
	second := DJPlaylist named: 'Techno'.
	second addTrack: (DJTrackModel on: nil path: '/music/two.wav' asFileReference).
	second addTrack: (DJTrackModel on: nil path: '/music/three.wav' asFileReference).
	browser playlistNav playlists: {
			first.
			second }.
	browser playlistNav selecter selectIndex: 1.
	browser playlistNav notifyPlaylistSelected.
	browser playlistNav selecter selectIndex: 2.
	browser playlistNav notifyPlaylistSelected.
	self assert: browser trackTable tracks size equals: 2.
	self assert: browser trackTable tracks first title equals: 'two.wav'
]

{ #category : 'tests' }
DJBrowserElementTest >> testSelectingPlaylistFillsTable [

	| playlist |
	playlist := DJPlaylist named: 'House'.
	playlist addTrack: (DJTrackModel on: nil path: '/music/one.wav' asFileReference).
	playlist addTrack: (DJTrackModel on: nil path: '/music/two.wav' asFileReference).
	browser playlistNav playlists: { playlist }.
	browser playlistNav selecter selectIndex: 1.
	browser playlistNav notifyPlaylistSelected.
	self assert: browser trackTable tracks size equals: 2
]

{ #category : 'tests' }
DJBrowserElementTest >> testTableStartsEmpty [

	self assert: browser trackTable tracks isEmpty
]
