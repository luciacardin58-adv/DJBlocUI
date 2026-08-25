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
