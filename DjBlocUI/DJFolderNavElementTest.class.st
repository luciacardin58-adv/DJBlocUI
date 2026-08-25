Class {
	#name : 'DJFolderNavElementTest',
	#superclass : 'TestCase',
	#instVars : [
		'nav',
		'tempRoot',
		'space'
	],
	#category : 'DjBlocUI-Tests',
	#package : 'DjBlocUI',
	#tag : 'Tests'
}

{ #category : 'as yet unclassified' }
DJFolderNavElementTest >> attachToSpace [
	"Drag needs a scene graph: startDrag: sends self space root.
	 BlSpace new builds a root without opening a window."

	space := BlSpace new.
	space root addChild: nav
]

{ #category : 'running' }
DJFolderNavElementTest >> setUp [

	super setUp.
	tempRoot := FileLocator temp / 'DJFolderNavElementTest' , Time now asMilliSeconds printString.
	tempRoot ensureCreateDirectory.
	(tempRoot / 'House') ensureCreateDirectory.
	(tempRoot / 'Techno') ensureCreateDirectory.
	(tempRoot / 'alpha.wav') ensureCreateFile.
	(tempRoot / 'zulu.aiff') ensureCreateFile.
	(tempRoot / 'notes.txt') ensureCreateFile.
	nav := DJFolderNavElement new.
	nav rootFolder: tempRoot
]

{ #category : 'running' }
DJFolderNavElementTest >> tearDown [

	tempRoot ensureDeleteAll.
	super tearDown
]

{ #category : 'tests' }
DJFolderNavElementTest >> testActionNotEvaluatedWithoutSelection [

	| notified |
	notified := false.
	nav folderSelectedAction: [ :aFolder | notified := true ].
	nav notifyFolderSelected.
	self deny: notified
]

{ #category : 'tests' }
DJFolderNavElementTest >> testActionReceivesSelectedFolder [

	| notified |
	notified := nil.
	nav folderSelectedAction: [ :aFolder | notified := aFolder ].
	nav selecter selectIndex: 1.
	nav notifyFolderSelected.
	self assert: notified equals: tempRoot
]

{ #category : 'tests' }
DJFolderNavElementTest >> testChangingRootFolderClearsSelection [

	nav selecter selectIndex: 1.
	nav rootFolder: tempRoot / 'House'.
	self assert: nav selectedFolder isNil
]

{ #category : 'tests' }
DJFolderNavElementTest >> testChangingRootFolderReplacesTopLevelItem [

	nav rootFolder: tempRoot / 'House'.
	self assert: nav dataAccessor asOrderedCollection size equals: 1.
	self assert: nav dataAccessor asOrderedCollection first equals: tempRoot / 'House'
]

{ #category : 'tests' }
DJFolderNavElementTest >> testChildrenAcceptADirectoryEntry [
	"Children of the root arrive as FileSystemDirectoryEntry, not FileReference —
	 this is what the asFileReference guard in initializeChildrenGetter is for."

	| entry |
	entry := tempRoot entries detect: [ :each | each basename = 'House' ].
	self assert: (nav nodeManager childrenFromDataItem: entry) isEmpty
]

{ #category : 'tests' }
DJFolderNavElementTest >> testChildrenAreSortedByBasename [
	"Compared with the same block the getter uses, so this stays true whatever
	 String >> < does with case."

	| basenames |
	basenames := (nav nodeManager childrenFromDataItem: tempRoot) collect: [ :each | each basename ].
	self
		assert: basenames asArray
		equals: (basenames asSortedCollection: [ :a :b | a < b ]) asArray
]

{ #category : 'tests' }
DJFolderNavElementTest >> testChildrenCount [

	self assert: (nav nodeManager childrenFromDataItem: tempRoot) size equals: 4
]

{ #category : 'tests' }
DJFolderNavElementTest >> testChildrenExcludeNonAudioFiles [

	| basenames |
	basenames := (nav nodeManager childrenFromDataItem: tempRoot) collect: [ :each | each basename ].
	self deny: (basenames includes: 'notes.txt')
]

{ #category : 'tests' }
DJFolderNavElementTest >> testChildrenIncludeAudioFiles [

	| basenames |
	basenames := (nav nodeManager childrenFromDataItem: tempRoot) collect: [ :each | each basename ].
	self assert: (basenames includes: 'alpha.wav').
	self assert: (basenames includes: 'zulu.aiff')
]

{ #category : 'tests' }
DJFolderNavElementTest >> testChildrenIncludeSubdirectories [

	| basenames |
	basenames := (nav nodeManager childrenFromDataItem: tempRoot) collect: [ :each | each basename ].
	self assert: (basenames includes: 'House').
	self assert: (basenames includes: 'Techno')
]

{ #category : 'tests' }
DJFolderNavElementTest >> testChildrenOfAFileAreEmpty [

	self assert: (nav nodeManager childrenFromDataItem: tempRoot / 'alpha.wav') isEmpty
]

{ #category : 'tests' }
DJFolderNavElementTest >> testDefaultActionIsHarmless [

	nav selecter selectIndex: 1.
	nav notifyFolderSelected.
	self assert: nav selectedFolder equals: tempRoot
]

{ #category : 'tests' }
DJFolderNavElementTest >> testDeselectAllClearsSelectedFolder [

	nav selecter selectIndex: 1.
	nav selecter deselectAll.
	self assert: nav selectedFolder isNil
]

{ #category : 'tests' }
DJFolderNavElementTest >> testDragEndClearsPayload [

	self attachToSpace.
	nav selecter selectIndex: 1.
	nav dispatchEvent: (BlDragStartEvent new position: 10 @ 10; yourself).
	nav dispatchEvent: (BlDragEndEvent new position: 100 @ 60; yourself).
	self assert: nav dragPayload isNil
]

{ #category : 'tests' }
DJFolderNavElementTest >> testDragEndRemovesGhost [

	self attachToSpace.
	nav selecter selectIndex: 1.
	nav dispatchEvent: (BlDragStartEvent new position: 10 @ 10; yourself).
	nav dispatchEvent: (BlDragEndEvent new position: 100 @ 60; yourself).
	self assert: nav dragGhost isNil.
	self deny: (space root children anySatisfy: [ :each | each isKindOf: ToLabel ])
]

{ #category : 'tests' }
DJFolderNavElementTest >> testDragMoveFollowsCursor [
	"Positions come back through Bloc's transformation, so compare with closeTo:."

	self attachToSpace.
	nav selecter selectIndex: 1.
	nav dispatchEvent: (BlDragStartEvent new position: 10 @ 10; yourself).
	nav dispatchEvent: (BlDragEvent new position: 100 @ 60; yourself).
	self assert: (nav dragGhost position x closeTo: 108).
	self assert: (nav dragGhost position y closeTo: 68)
]

{ #category : 'tests' }
DJFolderNavElementTest >> testDragMoveWithoutDragStartIsIgnored [

	self attachToSpace.
	nav dispatchEvent: (BlDragEvent new position: 100 @ 60; yourself).
	self assert: nav dragGhost isNil
]

{ #category : 'tests' }
DJFolderNavElementTest >> testDragPayloadIsAFileReference [
	"selectedFolder can answer a FileSystemDirectoryEntry; the drop target
	 must always receive a FileReference."

	self attachToSpace.
	nav selecter selectIndex: 1.
	nav dispatchEvent: (BlDragStartEvent new position: 10 @ 10; yourself).
	self assert: nav dragPayload isFileReference
]

{ #category : 'tests' }
DJFolderNavElementTest >> testDragStartAddsGhostToSpaceRoot [

	self attachToSpace.
	nav selecter selectIndex: 1.
	nav dispatchEvent: (BlDragStartEvent new position: 10 @ 10; yourself).
	self deny: nav dragGhost isNil.
	self assert: nav dragGhost parent == space root
]

{ #category : 'tests' }
DJFolderNavElementTest >> testDragStartConsumesAndSetsPayload [

	| event |
	self attachToSpace.
	nav selecter selectIndex: 1.
	event := BlDragStartEvent new position: 10 @ 10; yourself.
	nav dispatchEvent: event.
	self assert: event isConsumed.
	self assert: nav dragPayload equals: tempRoot
]

{ #category : 'tests' }
DJFolderNavElementTest >> testDragStartWithoutSelectionIsNotConsumed [
	"BlMouseProcessor abandons the gesture unless BlDragStartEvent comes back
	 consumed, so an unselected tree must leave it alone."

	| event |
	self attachToSpace.
	event := BlDragStartEvent new position: 10 @ 10; yourself.
	nav dispatchEvent: event.
	self deny: event isConsumed.
	self assert: nav dragPayload isNil.
	self assert: nav dragGhost isNil
]

{ #category : 'tests' }
DJFolderNavElementTest >> testGhostIgnoresMouseEvents [
	"If the ghost took mouse events it would be the element picked under the
	 cursor, and the drop target would never receive BlDropEvent."

	| ghost |
	ghost := nav newGhostFor: tempRoot.
	self deny: ghost shouldHandleMouseEvents
]

{ #category : 'tests' }
DJFolderNavElementTest >> testGhostLabelsTheFile [

	| ghost |
	ghost := nav newGhostFor: tempRoot / 'alpha.wav'.
	self assert: ghost text asString equals: 'alpha.wav'
]

{ #category : 'tests' }
DJFolderNavElementTest >> testNothingSelectedInitially [

	self assert: nav selectedFolder isNil
]

{ #category : 'tests' }
DJFolderNavElementTest >> testRootAddedAsSingleTopLevelItem [

	self assert: nav dataAccessor asOrderedCollection size equals: 1.
	self assert: nav dataAccessor asOrderedCollection first equals: tempRoot
]

{ #category : 'tests' }
DJFolderNavElementTest >> testRootFolderStored [

	self assert: nav rootFolder equals: tempRoot
]

{ #category : 'tests' }
DJFolderNavElementTest >> testSelectedFolderAfterSelectIndex [

	nav selecter selectIndex: 1.
	self assert: nav selectedFolder equals: tempRoot
]

{ #category : 'tests' }
DJFolderNavElementTest >> testSingleSelectionMode [

	self deny: nav isMultipleSelection
]
