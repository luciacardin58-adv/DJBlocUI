Class {
	#name : 'DJBrowserSidebarElementTest',
	#superclass : 'TestCase',
	#instVars : [
		'sidebar'
	],
	#category : 'DjBlocUI-Tests',
	#package : 'DjBlocUI',
	#tag : 'Tests'
}

{ #category : 'running' }
DJBrowserSidebarElementTest >> setUp [

	super setUp.
	sidebar := DJBrowserSidebarElement new
]

{ #category : 'running' }
DJBrowserSidebarElementTest >> testBothNavsAreChildren [

	self assert: (sidebar children includes: sidebar playlistNav).
	self assert: (sidebar children includes: sidebar folderNav)
]

{ #category : 'running' }
DJBrowserSidebarElementTest >> testFolderNavStartsWithoutRoot [

	self assert: sidebar folderNav rootFolder isNil
]

{ #category : 'running' }
DJBrowserSidebarElementTest >> testHasFolderNav [

	self assert: sidebar folderNav class equals: DJFolderNavElement
]

{ #category : 'running' }
DJBrowserSidebarElementTest >> testHasOneDivider [

	self assert: sidebar dividers size equals: 1
]

{ #category : 'running' }
DJBrowserSidebarElementTest >> testHasPlaylistNav [

	self assert: sidebar playlistNav class equals: DJPlaylistNavElement
]

{ #category : 'running' }
DJBrowserSidebarElementTest >> testIsVertical [

	self assert: sidebar isVertical
]

{ #category : 'running' }
DJBrowserSidebarElementTest >> testPlaylistNavComesFirst [

	| navChildren |
	navChildren := sidebar children reject: [ :each | each isKindOf: ToPaneDivider ].
	self assert: navChildren first equals: sidebar playlistNav.
	self assert: navChildren second equals: sidebar folderNav
]

{ #category : 'running' }
DJBrowserSidebarElementTest >> testPlaylistNavStartsEmpty [

	self assert: sidebar playlistNav playlists isEmpty
]
