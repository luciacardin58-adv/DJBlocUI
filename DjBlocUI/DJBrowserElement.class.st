"
I am the crate browser: the sidebar on the left, the track table on the right.
I am the only class in the browser that knows how the pieces connect.

I wire playlist selection to the track table. Folder selection is deliberately
left unconsumed — the Spec app it replaces used the folder tree only as a drag
source, and drag-and-drop is not implemented yet. My folderNav still emits its
action; nothing listens.

I never reference a deck. When a track is double-clicked I evaluate
trackLoadAction with that DJTrackModel and let DJConsoleElement decide where
it goes.
```language=pharo
    | browser |
    browser := DJBrowserElement new.
    browser refresh.
    browser trackLoadAction: [ :aTrack | console loadTrack: aTrack onDeck: #a ].
```
**DJConsoleElement** lays me out below the console row in a vertical layout.
"
Class {
	#name : 'DJBrowserElement',
	#superclass : 'DJPanelElement',
	#instVars : [
		'trackLoadAction',
		'sidebar',
		'trackTable'
	],
	#category : 'DjBlocUI-Browser',
	#package : 'DjBlocUI',
	#tag : 'Browser'
}

{ #category : 'examples' }
DJBrowserElement class >> example [
	<script>

	| browser |
	browser := self new.
	browser playlistNav playlists: {
			(DJPlaylist named: 'House').
			(DJPlaylist named: 'Techno') }.
	browser rootFolder: FileLocator imageDirectory.
	browser trackLoadAction: [ :aTrack | aTrack title traceCr ].
	browser inSpace
		extent: 900 @ 320;
		title: 'DJBrowserElement';
		show
]

{ #category : 'accessing' }
DJBrowserElement >> folderNav [

	^ sidebar folderNav
]

{ #category : 'initialization' }
DJBrowserElement >> initialize [

	super initialize.
	trackLoadAction := [ :aTrack | ].
	self beRow.
	self constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical exact: 200 ]
]

{ #category : 'initialization' }
DJBrowserElement >> initializeParts [

	super initializeParts.
	sidebar := DJBrowserSidebarElement new.
	sidebar constraintsDo: [ :c |
		c horizontal exact: 240.
		c vertical matchParent ].
	trackTable := DJTrackTableElement new.
	trackTable matchParent.
	self addChildren: {
			sidebar.
			trackTable }.
	self initializeWiring
]

{ #category : 'initialization' }
DJBrowserElement >> initializeWiring [
	"Playlist selection fills the table. Folder selection is intentionally
	 not wired — see the class comment."

	self playlistNav playlistSelectedAction: [ :aPlaylist |
		trackTable tracks: aPlaylist tracks ].
	trackTable trackActivatedAction: [ :aTrack |
		self notifyTrackLoad: aTrack ]
]

{ #category : 'notifying' }
DJBrowserElement >> notifyTrackLoad: aTrackModel [

	aTrackModel ifNil: [ ^ self ].
	trackLoadAction value: aTrackModel
]

{ #category : 'accessing' }
DJBrowserElement >> playlistNav [

	^ sidebar playlistNav
]

{ #category : 'updating' }
DJBrowserElement >> refresh [

self playlistNav refresh
]

{ #category : 'updating' }
DJBrowserElement >> rootFolder: aFileReference [

self folderNav rootFolder: aFileReference 
]

{ #category : 'accessing' }
DJBrowserElement >> selectedTrack [

	^ trackTable selectedTrack
]

{ #category : 'accessing' }
DJBrowserElement >> sidebar [ 
^ sidebar
]

{ #category : 'accessing' }
DJBrowserElement >> trackLoadAction [

	^ trackLoadAction
]

{ #category : 'accessing' }
DJBrowserElement >> trackLoadAction: aOneArgBlock [
	"aOneArgBlock is evaluated with the DJTrackModel to load."

	trackLoadAction := aOneArgBlock
]

{ #category : 'accessing' }
DJBrowserElement >> trackTable [

^ trackTable
]
