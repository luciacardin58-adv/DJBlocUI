"
I am a placeholder for a leaf element that has not been written yet.

I draw myself as a labelled panel carrying my own class name, so that
DJConsoleElement can be opened and its layout judged before any of the
real content exists. What I am useful for is proving that constraints,
spacing and ordering are right; I say nothing about whether the element
that replaces me will fit.

My subclasses override initialize only to declare their size, and answer
whatever accessors their parent expects - track: on the header parts, for
instance - as no-ops. Replacing one of them means writing the real class
against the same superclass its parent expects, then deleting the stub.

I am temporary. Nothing should come to depend on me.
"
Class {
	#name : 'DJStubElement',
	#superclass : 'DJPanelElement',
	#instVars : [
		'label'
	],
	#category : 'DjBlocUI-SimpleWidgets',
	#package : 'DjBlocUI',
	#tag : 'SimpleWidgets'
}

{ #category : 'initialization' }
DJStubElement >> initializeParts [
	label := DJTheme stubLabel: self stubText.
	self addChild: label
]

{ #category : 'accessing' }
DJStubElement >> label [
	^ label
]

{ #category : 'as yet unclassified' }
DJStubElement >> stubText [
	"Subclasses name themselves so the opened console is readable."
	^ self class name allButFirst: 2
]

{ #category : 'accessing' }
DJStubElement >> text: aString [
	label text: (DJTheme textElement: aString color: DJTheme text size: 12) text
]
