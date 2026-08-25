"
I am the lower pane of the browser sidebar. I show a folder tree rooted at rootFolder, a FileReference to a directory. Children are lazily computed by my childrenGetter, subdirectories only, no files.

I do not know about decks, playlists, or the track table. When my selection
changes I evaluate folderSelectedAction with the newly selected **FileReference**; my owner decides what that means (typically: list its audio files into **DJTrackTableElement**).

I do not touch the filesystem until rootFolder: is sent.

```language=pharo
    | nav |
    nav := DJFolderNavElement new.
    nav rootFolder: '~/Music' asFileReference.
    nav folderSelectedAction: [ :aFolder | table tracks: (self tracksIn: aFolder) ].
```
Scrollbar is not automatic on this Toplo branch: I build and attach a **BlVerticalScrollbarElement** to my innerElement myself, same as **DJPlaylistNavElement**.

I inherit matchParent from ToElement >> initialize; my owning pane is responsible for constraining me.
"
Class {
	#name : 'DJFolderNavElement',
	#superclass : 'ToTreeElement',
	#instVars : [
		'rootFolder',
		'folderSelectedAction',
		'scrollbar',
		'dragPayload',
		'dragGhost'
	],
	#category : 'DjBlocUI-Browser',
	#package : 'DjBlocUI',
	#tag : 'Browser'
}

{ #category : 'examples' }
DJFolderNavElement class >> example [

	<script>
	| nav |
	nav := self new.
	nav rootFolder: FileLocator imageDirectory.
	nav folderSelectedAction: [ :aFolder | aFolder basename traceCr ].
	nav inSpace
		extent: 220 @ 320;
		title: 'DJFolderNavElement';
		show
]

{ #category : 'event handling' }
DJFolderNavElement >> continueDrag: anEvent [

	dragGhost ifNil: [ ^ self ].
	anEvent consumed: true.
	dragGhost position: anEvent position + (8 @ 8)
]

{ #category : 'accessing' }
DJFolderNavElement >> dragPayload [
	"Answer the FileReference being dragged out of me, or nil. Read by the drop target through event gestureSource."

	^ dragPayload
]

{ #category : 'event handling' }
DJFolderNavElement >> endDrag: anEvent [
"BlDropEvent fires before BlDragEndEvent, so the target has already read dragPayload by the time I clear it."

	anEvent consumed: true.
	dragGhost ifNotNil: [ dragGhost removeFromParent ].
	dragGhost := nil.
	dragPayload := nil
]

{ #category : 'accessing' }
DJFolderNavElement >> folderSelectedAction [ 

^ folderSelectedAction 
]

{ #category : 'accessing' }
DJFolderNavElement >> folderSelectedAction: aOneArgBlock [
	"aOneArgBlock is evaluated with the newly selected FileReference."

	folderSelectedAction := aOneArgBlock
]

{ #category : 'initialization' }
DJFolderNavElement >> initialize [

	super initialize.
	folderSelectedAction := [ :aFolder | ].
	self selecter beSingleSelection.
	self addStamp: #background withValue: DJTheme browserBackground.
	self initializeChildrenGetter.
	self initializeNodeBuilder.
	self initializeScrollbar.
	self placeholderString: 'No folder selected'.
	self initializeSelectionHandling.
	self initializeDragSource
]

{ #category : 'initialization' }
DJFolderNavElement >> initializeChildrenGetter [
"entries raises on directories the process cannot open — macOS guards Desktop, Documents and Downloads, and parts of ~/Library are closed outright. An unreadable folder reads as empty rather than killing the tree."

	self childrenGetter: [ :aFileReference |
		aFileReference isDirectory
			ifTrue: [
				(([ aFileReference asFileReference entries ]
					  on: Error
					  do: [ :each | #(  ) ]) select: [ :each |
					 each isDirectory or: [
						 #( 'wav' 'aiff' 'aif' ) includes: each extension asLowercase ] ])
					asSortedCollection: [ :a :b | a basename < b basename ] ]
			ifFalse: [ #(  ) ] ]
]

{ #category : 'initialization' }
DJFolderNavElement >> initializeDragSource [
	"Handlers sit on me, not on the nodes: drag events bubble up from the node
	 under the cursor, and Toplo recycles nodes."

	self addEventHandlerOn: BlDragStartEvent do: [ :event | self startDrag: event ].
	self addEventHandlerOn: BlDragEvent do: [ :event | self continueDrag: event ].
	self addEventHandlerOn: BlDragEndEvent do: [ :event | self endDrag: event ]
]

{ #category : 'initialization' }
DJFolderNavElement >> initializeNodeBuilder [

	self nodeBuilder: [ :node :dataItem :holder |
		| label |
		label := DJTheme textElement: dataItem basename color: DJTheme browserText size: 12.
		label constraintsDo: [ :c | c horizontal matchParent ].
		node addChild: label ]
]

{ #category : 'initialization' }
DJFolderNavElement >> initializeScrollbar [

	scrollbar := BlVerticalScrollbarElement new.
	scrollbar constraintsDo: [ :c |
		c ignoreByLayout.
		c margin: (BlInsets right: 2).
		c ignored horizontal alignRight.
		c ignored vertical alignBottom ].
	scrollbar attachTo: self innerElement
]

{ #category : 'initialization' }
DJFolderNavElement >> initializeSelectionHandling [

	self
		addEventHandlerOn: ToListPrimarySelectionChangedEvent
		do: [ :event | self notifyFolderSelected ]
]

{ #category : 'helper' }
DJFolderNavElement >> newGhostFor: aFileReference [
	"The ghost must not take mouse events, otherwise it is the element picked
	 under the cursor and the drop target never receives the drop."

	^ ToLabel new
		  text: aFileReference basename;
		  background: DJTheme browserBackground;
		  border: (BlBorder paint: DJTheme browserBorder width: 1);
		  padding: (BlInsets all: 4);
		  constraintsDo: [ :c | c ignoreByLayout ];
		  preventMeAndChildrenMouseEvents;
		  yourself
]

{ #category : 'notifying' }
DJFolderNavElement >> notifyFolderSelected [

	| selected |
	selected := self selectedFolder.
	selected ifNil: [ ^ self ].
	folderSelectedAction value: selected
]

{ #category : 'accessing' }
DJFolderNavElement >> rootFolder [ 
^ rootFolder
]

{ #category : 'updating' }
DJFolderNavElement >> rootFolder: aFileReference [

	rootFolder := aFileReference.
	self selecter deselectAll.
	self dataAccessor removeAll.
	self dataAccessor addAll: { rootFolder }.
	self expandRoots
]

{ #category : 'accessing' }
DJFolderNavElement >> selectedFolder [
	"Answer the selected FileReference, or nil when nothing is selected.
	 Guarded because ToListSelecter >> selectedIndex answers 0, not nil,
	 on an empty selection."

	self selecter hasSelection ifFalse: [ ^ nil ].
	^ self dataAccessor at: self selecter selectedIndex
]

{ #category : 'event handling' }
DJFolderNavElement >> startDrag: anEvent [
"Consuming is mandatory: BlMouseProcessor abandons the gesture if BlDragStartEvent comes back unconsumed."

	| entry |
	entry := self selectedFolder.
	entry ifNil: [ ^ self ].
	anEvent consumed: true.
	dragPayload := entry asFileReference.
	dragGhost := self newGhostFor: dragPayload.
	self space root addChild: dragGhost.
	dragGhost position: anEvent position + (8 @ 8)
]
