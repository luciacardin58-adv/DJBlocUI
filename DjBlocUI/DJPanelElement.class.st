"
I am the shared container
"
Class {
	#name : 'DJPanelElement',
	#superclass : 'BlElement',
	#category : 'DjBlocUI-SimpleWidgets',
	#package : 'DjBlocUI',
	#tag : 'SimpleWidgets'
}

{ #category : 'examples' }
DJPanelElement class >> example [
	"Two markers make the chrome legible: the gap between them is
	 cellSpacing, the gap to the edge is padding, and stacked rather
	 than side by side means the default layout is vertical."
	<script>
	| panel |
	panel := self new beMatchingParent; yourself.
	2 timesRepeat: [
		panel addChild: (BlElement new
				 background: DJTheme accent;
				 constraintsDo: [ :c |
					 c horizontal exact: 60.
					 c vertical exact: 40 ];
				 yourself) ].
	(panel openInSpace)
		extent: 300 @ 200;
		title: 'DJPanelElement'
]

{ #category : 'instance creation' }
DJPanelElement class >> row [
	"An invisible horizontal row that fills its parent."
	^ self new beBare; beRow; beMatchingParent; yourself
]

{ #category : 'api - layout' }
DJPanelElement >> beBare [
	"Undo my chrome. For invisible layout rows that only group children."
	self background: Color transparent.
	self border: BlBorder empty.
	self padding: BlInsets empty
]

{ #category : 'api - layout' }
DJPanelElement >> beMatchingParent [
	self constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical matchParent ]
]

{ #category : 'api - layout' }
DJPanelElement >> beRow [
 
    self layout: (BlLinearLayout horizontal cellSpacing: DJTheme gap)
]

{ #category : 'initialization' }
DJPanelElement >> initialize [
 
    super initialize.
    self background: DJTheme panel.
    self border: (BlBorder paint: DJTheme hairline width: 1).
    self geometry: (BlRoundedRectangleGeometry cornerRadius: 8).
    self padding: (BlInsets all: DJTheme gap).
    self layout: (BlLinearLayout vertical cellSpacing: DJTheme gap).
    self initializeParts
]

{ #category : 'initialization' }
DJPanelElement >> initializeParts [
    "Subclasses add their children here."
 
    ^ self
]

{ #category : 't - layout resizeable' }
DJPanelElement >> matchParent [
 
    self constraintsDo: [ :c |
        c horizontal matchParent.
        c vertical matchParent ]
]
