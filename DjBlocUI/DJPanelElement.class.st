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
   
    <script>
    | panel |
    panel := self new.
    panel constraintsDo: [ :c |
        c horizontal matchParent.
        c vertical matchParent ].
    (panel openInSpace)
        extent: 300 @ 200;
        title: 'DJPanelElement'
]

{ #category : 'as yet unclassified' }
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
