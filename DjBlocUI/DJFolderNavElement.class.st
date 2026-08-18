Class {
	#name : 'DJFolderNavElement',
	#superclass : 'ToTreeElement',
	#instVars : [
		'rootFolder',
		'folderSelectedAction',
		'scrollbar'
	],
	#category : 'DjBlocUI-Browser',
	#package : 'DjBlocUI',
	#tag : 'Browser'
}

{ #category : 'accessing' }
DJFolderNavElement >> folderSelectedAction [

	^ folderSelectedAction
]

{ #category : 'accessing' }
DJFolderNavElement >> folderSelectedAction: aOneArgBlock [
	"aOneArgBlock is evaluated with the newly selected FileReference."

	folderSelectedAction := aOneArgBlock
]

{ #category : 'accessing' }
DJFolderNavElement >> rootFolder: aFileReference [

"Replace the tree's contents with a single root node for aFileReference.
Clearing the selection first avoids a stale selectedFolder pointing at a node that no longer exists once the old data is removed."
	rootFolder := aFileReference.
	self selecter deselectAll.
	self dataAccessor removeAll.
	self dataAccessor addAll: { rootFolder }.
	self expandRoots
]
