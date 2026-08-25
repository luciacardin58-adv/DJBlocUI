"
I stand in for DJFolderNavElement in drop tests: answering dragPayload is the whole protocol a drop target requires of a drag source. Using me keeps the table's tests free of tree selection and scene-graph setup.
"
Class {
	#name : 'DJTestDragSource',
	#superclass : 'Object',
	#instVars : [
		'dragPayloaf',
		'dragPayload'
	],
	#category : 'DjBlocUI-Tests',
	#package : 'DjBlocUI',
	#tag : 'Tests'
}

{ #category : 'accessing' }
DJTestDragSource >> dragPayload [

	^ dragPayload
]

{ #category : 'accessing' }
DJTestDragSource >> dragPayload: aFileReference [

	dragPayload := aFileReference
]
