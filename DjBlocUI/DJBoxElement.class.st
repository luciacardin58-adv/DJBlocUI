"
I am an invisible container. I lay children out in a line with the theme's gap between them and draw nothing of my own.

**DJPanelElement** is my visible counterpart: it draws a panel and every grouping element in the tree had to undo that chrome before using it.
Reach for me when the element exists only to position its children, and for **DJPanelElement** when it should be seen.

Direction and sizing are separate: beRow or beColumn, then matchWidth,
matchHeight, exactWidth: or exactHeight: as needed.
"
Class {
	#name : 'DJBoxElement',
	#superclass : 'BlElement',
	#category : 'DjBlocUI-SimpleWidgets',
	#package : 'DjBlocUI',
	#tag : 'SimpleWidgets'
}

{ #category : 'accessing' }
DJBoxElement class >> column [
	"A vertical box filling its parent."

	^ self new beColumn; beMatchingParent; yourself
]

{ #category : 'examples' }
DJBoxElement class >> example [
	<script>
	| box |
	box := DJBoxElement row.
	3 timesRepeat: [
		box addChild: (BlElement new
				 background: DJTheme accent;
				 constraintsDo: [ :c |
					 c horizontal exact: 40.
					 c vertical exact: 60 ];
				 yourself) ].
	box openInSpace
		extent: 300 @ 120;
		title: 'DJBoxElement'
]

{ #category : 'accessing' }
DJBoxElement class >> row [
	"A horizontal box filling its parent."

	^ self new beRow; beMatchingParent; yourself
]

{ #category : 'api - layout' }
DJBoxElement >> beColumn [

	self layout: (BlLinearLayout vertical cellSpacing: DJTheme gap)
]

{ #category : 'api - layout' }
DJBoxElement >> beMatchingParent [

	self matchWidth.
	self matchHeight
]

{ #category : 'api - layout' }
DJBoxElement >> beRow [

	self layout: (BlLinearLayout horizontal cellSpacing: DJTheme gap)
]

{ #category : 'api - layout' }
DJBoxElement >> beTightColumn [

	self layout: (BlLinearLayout vertical cellSpacing: 0)
]

{ #category : 'api - layout' }
DJBoxElement >> exactHeight: aNumber [

	self constraintsDo: [ :c | c vertical exact: aNumber ]
]

{ #category : 'api - layout' }
DJBoxElement >> exactWidth: aNumber [

	self constraintsDo: [ :c | c horizontal exact: aNumber ]
]

{ #category : 'initialization' }
DJBoxElement >> initialize [

"Vertical by default, matching DJPanelElement so the two are interchangeable without surprise."

	super initialize.
	self beColumn.
	self initializeParts
]

{ #category : 'initialization' }
DJBoxElement >> initializeParts [
	"Subclasses add their children here."

	^ self
]

{ #category : 'api - layout' }
DJBoxElement >> matchHeight [

	self constraintsDo: [ :c | c vertical matchParent ]
]

{ #category : 'api - layout' }
DJBoxElement >> matchWidth [

	self constraintsDo: [ :c | c horizontal matchParent ]
]
