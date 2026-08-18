"
I am the right panel of the browser. I show a playlist's tracks in a sortable
four-column table: Title, Artist, BPM, Genre.

I do not know about decks, playlists, or folders. When a row is double-clicked
I evaluate trackActivatedAction with that DJTrackModel; my owner decides what
that means (typically: hand it to DJBrowserElement's trackLoadAction).
```language=pharo
    | table |
    table := DJTrackTableElement new.
    table tracks: aPlaylist tracks.
    table trackActivatedAction: [ :aTrack | aTrack title traceCr ].
```
The BPM column is a placeholder:
```language=pharo
DJTrackModel >> bpm 
```
always answers '--' until **DJBeatDetector** is wired up.

I build my own cell and header labels with DJTheme rather than ToLabel,
because ToLabel's skin overwrites foreground from theme tokens.

Unlike the nav panes I do not build a scrollbar: 
```language=pharo
ToTableListElement >> initializeScrollBar 
```
already does it.

I inherit matchParent from ToTableElement >> initialize.
"
Class {
	#name : 'DJTrackTableElement',
	#superclass : 'ToTableElement',
	#instVars : [
		'trackActivatedAction'
	],
	#category : 'DjBlocUI-Browser',
	#package : 'DjBlocUI',
	#tag : 'Browser'
}

{ #category : 'examples' }
DJTrackTableElement class >> example [
	<script>

	| table |
	table := self new.
	table tracks: {
			(DJTrackModel on: nil path: '/music/House/track one.wav' asFileReference).
			(DJTrackModel on: nil path: '/music/House/track two.wav' asFileReference).
			(DJTrackModel on: nil path: '/music/Techno/track three.wav' asFileReference) }.
	table trackActivatedAction: [ :aTrack | aTrack title traceCr ].
	table inSpace
		extent: 520 @ 320;
		title: 'DJTrackTableElement';
		show
]

{ #category : 'initialization' }
DJTrackTableElement >> cellBuilderBlock [
	"The cell builder receives the already-fetched cell data, not the track."

	^ [ :element :cellData :holder |
	  | label |
	  label := DJTheme
		           textElement: cellData asString
		           color: DJTheme browserText
		           size: 12.
	  label constraintsDo: [ :c |
		  c horizontal matchParent.
		  c vertical exact: 20 ].
	  element addChild: label ]
]

{ #category : 'initialization' }
DJTrackTableElement >> headerCellBuilderBlock [

	^ [ :element :column :table |
	  | label |
	  label := DJTheme
		           textElement: column title asString
		           color: DJTheme browserText
		           size: 12.
	  label constraintsDo: [ :c |
		  c horizontal matchParent.
		  c vertical exact: 20 ].
	  element addChild: label ]
]

{ #category : 'initialization' }
DJTrackTableElement >> initialize [

	super initialize.
	trackActivatedAction := [ :aTrack | ].
	self addStamp: #background withValue: DJTheme browserBackground.
	self list addStamp: #background withValue: DJTheme browserBackground.
	self columns: self newColumns.
	self showHeader: true.
	self list selecter beSingleSelection.
	self initializeActivationHandling
]

{ #category : 'initialization' }
DJTrackTableElement >> initializeActivationHandling [

	self list
		addEventHandlerOn: ToListStrongSelectionEvent
		do: [ :event | self notifyTrackActivated ]
]

{ #category : 'initialization' }
DJTrackTableElement >> newArtistColumn [

	^ ToTableColumn new
		  title: 'Artist';
		  key: 'artist';
		  dataIndex: 'artist';
		  sorterBlock: #artist ascending;
		  cellBuilder: self cellBuilderBlock;
		  headerCellBuilder: self headerCellBuilderBlock;
		  yourself
]

{ #category : 'initialization' }
DJTrackTableElement >> newBpmColumn [

	^ ToTableColumn new
		  title: 'BPM';
		  key: 'bpm';
		  dataIndex: 'bpm';
		  width: 70;
		  cellBuilder: self cellBuilderBlock;
		  headerCellBuilder: self headerCellBuilderBlock;
		  yourself
]

{ #category : 'initialization' }
DJTrackTableElement >> newColumns [

	^ {
		  self newTitleColumn.
		  self newArtistColumn.
		  self newBpmColumn.
		  self newGenreColumn }
]

{ #category : 'initialization' }
DJTrackTableElement >> newGenreColumn [

	^ ToTableColumn new
		  title: 'Genre';
		  key: 'genre';
		  dataIndex: 'genre';
		  sorterBlock: #genre ascending;
		  width: 120;
		  cellBuilder: self cellBuilderBlock;
		  headerCellBuilder: self headerCellBuilderBlock;
		  yourself
]

{ #category : 'initialization' }
DJTrackTableElement >> newTitleColumn [

	^ ToTableColumn new
		  title: 'Title';
		  key: 'title';
		  dataIndex: 'title';
		  sorterBlock: #title ascending;
		  cellBuilder: self cellBuilderBlock;
		  headerCellBuilder: self headerCellBuilderBlock;
		  yourself
]

{ #category : 'notifying' }
DJTrackTableElement >> notifyTrackActivated [

	| activated |
	activated := self selectedTrack.
	activated ifNil: [ ^ self ].
	trackActivatedAction value: activated
]

{ #category : 'accessing' }
DJTrackTableElement >> selectedTrack [
	"Answer the selected DJTrackModel, or nil when nothing is selected.
	 Guarded because ToListSelecter >> selectedIndex answers 0, not nil,
	 on an empty selection."

	self list selecter hasSelection ifFalse: [ ^ nil ].
	^ self dataAccessor at: self list selecter selectedIndex
]

{ #category : 'accessing' }
DJTrackTableElement >> trackActivatedAction: aOneArgBlock [
	"aOneArgBlock is evaluated with the double-clicked DJTrackModel."

	trackActivatedAction := aOneArgBlock
]

{ #category : 'accessing' }
DJTrackTableElement >> tracks [

	^ self dataAccessor asOrderedCollection
]

{ #category : 'accessing' }
DJTrackTableElement >> tracks: aCollectionOfTracks [

	self list selecter deselectAll.
	self dataAccessor removeAll.
	self dataAccessor addAll: aCollectionOfTracks
]
