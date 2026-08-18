Class {
	#name : 'DJFolderNavElementTest',
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
DJFolderNavElementTest >> setUp [

	super setUp.
	tempRoot := FileLocator temp / 'DJFolderNavElementTest' , Time now asMilliSeconds printString.
	tempRoot ensureCreateDirectory.
	(tempRoot / 'House') ensureCreateDirectory.
	(tempRoot / 'Techno') ensureCreateDirectory.
	nav := DJFolderNavElement new.
	nav rootFolder: tempRoot
]

{ #category : 'running' }
DJFolderNavElementTest >> tearDown [

	tempRoot ensureDelete.
	super tearDown
]

{ #category : 'running' }
DJFolderNavElementTest >> testActionNotEvaluatedWithoutSelection [

	| notified |
	notified := false.
	nav folderSelectedAction: [ :aFolder | notified := true ].
	nav notifyFolderSelected.
	self deny: notified
]

{ #category : 'running' }
DJFolderNavElementTest >> testActionReceivesSelectedFolder [

	| notified |
	notified := nil.
	nav folderSelectedAction: [ :aFolder | notified := aFolder ].
	nav selecter selectIndex: 1.
	nav notifyFolderSelected.
	self assert: notified equals: tempRoot
]

{ #category : 'running' }
DJFolderNavElementTest >> testChangingRootFolderClearsSelection [

	nav selecter selectIndex: 1.
	nav rootFolder: tempRoot / 'House'.
	self assert: nav selectedFolder isNil
]

{ #category : 'running' }
DJFolderNavElementTest >> testChildrenGetterFindsSubdirectories [

	| children |
	children := nav nodeManager childrenFromDataItem: tempRoot.
	self assert: children size equals: 2
]

{ #category : 'running' }
DJFolderNavElementTest >> testNothingSelectedInitially [

	self assert: nav selectedFolder isNil
]

{ #category : 'running' }
DJFolderNavElementTest >> testRootAddedAsSingleTopLevelItem [

	self assert: nav dataAccessor asOrderedCollection size equals: 1.
	self assert: nav dataAccessor asOrderedCollection first equals: tempRoot
]

{ #category : 'running' }
DJFolderNavElementTest >> testRootFolderStored [

	self assert: nav rootFolder equals: tempRoot
]

{ #category : 'running' }
DJFolderNavElementTest >> testSelectedFolderAfterSelectIndex [

	nav selecter selectIndex: 1.
	self assert: nav selectedFolder equals: tempRoot
]
