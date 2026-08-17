"
I am the upper pane of the browser sidebar. I show the available DJPlaylists
as a flat, single-selection list.

I do not know about decks or about the track table. When my selection changes
I evaluate playlistSelectedAction with the newly selected DJPlaylist; my owner
decides what that means.

My playlistManager is lazy — creating me does not touch the filesystem. Only
#refresh reads ~/Documents/PharoDJCrate/Playlists/.

```languague=Pharo
    | nav |
    nav := DJPlaylistNavElement new.
    nav refresh.
    nav playlistSelectedAction: [ :aPlaylist | table tracks: aPlaylist tracks ].
```
I inherit matchParent from ToBasicListElement >> initialize; my owning pane is
responsible for constraining me.
"
Class {
	#name : 'DJPlaylistNavElement',
	#superclass : 'ToListElement',
	#instVars : [
		'playlistManager',
		'playlistSelectedAction'
	],
	#category : 'DjBlocUI-Browser',
	#package : 'DjBlocUI',
	#tag : 'Browser'
}

{ #category : 'examples' }
DJPlaylistNavElement class >> example [
	<script>

	| nav |
	nav := self new.
	nav playlists: {
			(DJPlaylist named: 'House').
			(DJPlaylist named: 'Techno').
			(DJPlaylist named: 'Warm up') }.
	nav playlistSelectedAction: [ :aPlaylist | aPlaylist name traceCr ].
	nav inSpace
		extent: 220 @ 320;
		title: 'DJPlaylistNavElement';
		show
]

{ #category : 'initialization' }
DJPlaylistNavElement >> initialize [

	super initialize.
	playlistSelectedAction := [ :aPlaylist | ].
	self useScrollbar: true.
	self primarySelectionMode beSingleSelection.
	self initializeNodeBuilder.
	self initializePlaceholder.
	self initializeSelectionHandling
]

{ #category : 'initialization' }
DJPlaylistNavElement >> initializeNodeBuilder [

	self nodeBuilder: [ :node :dataItem :holder |
		node addChild: (ToLabel new
				 text: dataItem name;
				 hMatchParent;
				 yourself) ]
]

{ #category : 'initialization' }
DJPlaylistNavElement >> initializePlaceholder [

	self placeholderBuilder: [ :placeholder :element |
		placeholder empty labelText: 'No playlists' ]
]

{ #category : 'initialization' }
DJPlaylistNavElement >> initializeSelectionHandling [

	self
		addEventHandlerOn: ToListPrimarySelectionChangedEvent
		do: [ :event | self notifyPlaylistSelected ]
]

{ #category : 'notifying' }
DJPlaylistNavElement >> notifyPlaylistSelected [

	| selected |
	selected := self selectedPlaylist.
	selected ifNil: [ ^ self ].
	playlistSelectedAction value: selected
]

{ #category : 'accessing' }
DJPlaylistNavElement >> playlistManager [

	^ playlistManager ifNil: [ playlistManager := DJPlaylistManager default ]
]

{ #category : 'accessing' }
DJPlaylistNavElement >> playlistManager: aDJPlaylistManager [

	playlistManager := aDJPlaylistManager
]

{ #category : 'accessing' }
DJPlaylistNavElement >> playlistSelectedAction [

	^ playlistSelectedAction
]

{ #category : 'accessing' }
DJPlaylistNavElement >> playlistSelectedAction: aOneArgBlock [
	"aOneArgBlock is evaluated with the newly selected DJPlaylist."

	playlistSelectedAction := aOneArgBlock
]

{ #category : 'accessing' }
DJPlaylistNavElement >> playlists [

	^ self dataAccessor asOrderedCollection
]

{ #category : 'accessing' }
DJPlaylistNavElement >> playlists: aCollectionOfPlaylists [

	self selecter deselectAll.
	self dataAccessor removeAll.
	self dataAccessor addAll: aCollectionOfPlaylists
]

{ #category : 'accessing' }
DJPlaylistNavElement >> refresh [

	self playlists: self playlistManager availablePlaylists
]

{ #category : 'accessing' }
DJPlaylistNavElement >> selectedPlaylist [
	"Answer the selected DJPlaylist, or nil when nothing is selected.
	 Guarded because BlCompositeSelection >> firstIndex answers 0, not nil,
	 on an empty selection."

	self selectionModel isEmpty ifTrue: [ ^ nil ].
	^ self dataAccessor at: self selectionModel firstIndex
]
