"
I am the base fader for this app, an ICMixerFader that can be moved without
speaking. setValueSilently: repositions my handle while my callBack stays quiet,
so sync and playhead updates do not echo back into the deck that sent them.
"
Class {
	#name : 'DJFaderElement',
	#superclass : 'ICMixerFader',
	#traits : 'TDJSilentSettable',
	#classTraits : 'TDJSilentSettable classTrait',
	#category : 'DjBlocUI-SimpleWidgets',
	#package : 'DjBlocUI',
	#tag : 'SimpleWidgets'
}

{ #category : 'example' }
DJFaderElement class >> example [
	<script>
	| container |
	container := BlElement new
		             background: DJTheme panel;
		             layout: BlFrameLayout new;
		             constraintsDo: [ :c |
			             c horizontal matchParent.
			             c vertical matchParent ];
		             yourself.
	container addChild: ((self label: 'TEMPO')
			 constraintsDo: [ :c |
				 c frame horizontal alignCenter.
				 c frame vertical alignCenter ];
			 yourself).
	(container openInSpace)
		extent: 200 @ 320;
		title: 'DJFaderElement'
]

{ #category : 'defaults' }
DJFaderElement >> barDefaultColor [

	^ DJTheme text
]

{ #category : 'defaults' }
DJFaderElement >> coloredBarDefaultColor [
	"Same as the untravelled part, so the trace reads as one line and the cap is the only thing that moves."

	^ DJTheme text
]

{ #category : 'api - bounds' }
DJFaderElement >> defaultColor [ 

^ Color transparent 
]

{ #category : 'defaults' }
DJFaderElement >> defaultHandle [
"A plain dark thumb with an accent line down its centre. ICMixerFader's shadowed pale block is a console cap, not a DJ one."

	^ BlElement new
		  background: self handleDefaultColor;
		  geometry: (BlRoundedRectangleGeometry cornerRadius: 2);
		  border: (BlBorder paint: DJTheme dimText width: 1);
		  layout: BlFrameLayout new;
		  addChild: self defaultHandleMarker;
		  constraintsDo: [ :c | c ignoreByLayout ];
		  yourself
]

{ #category : 'size' }
DJFaderElement >> defaultHandleMarker [

	^ BlElement new
		  background: self markerColor;
		  constraintsDo: [ :c |
			  c frame horizontal alignCenter.
			  c frame vertical alignCenter.
			  self
				  ifHorizontal: [
					  c horizontal exact: 6.
					  c vertical matchParent ]
				  ifVertical: [
					  c horizontal matchParent.
					  c vertical exact: 6 ] ];
		  yourself
]

{ #category : 'defaults' }
DJFaderElement >> defaultTickColor [

	^ Color transparent
]

{ #category : 'defaults' }
DJFaderElement >> defaultTickCount [
	"No scale behind the cap. One tick still gets built, so it goes
	 transparent rather than to zero - applyTicks divides by count - 1."

	^ 2
]

{ #category : 'defaults' }
DJFaderElement >> handleDefaultColor [

	^ DJTheme panel lighter
]

{ #category : 'size' }
DJFaderElement >> handleThickness [
	"Along travel. ICMixerFader gives barThickness * 6/7, a console block. Half that reads as a DJ blade."

	^ self barThickness * 3 / 7
]

{ #category : 'initialization' }
DJFaderElement >> initialize [

	super initialize.
	self clipChildren: true.
	self
		barLength: (self defaultBarLength * self sizeScale) rounded
		thickness: (self defaultBarThickness * self sizeScale) rounded.
	self constraintsDo: [ :c |
		c horizontal exact: self widgetSize x.
		c vertical exact: self widgetSize y ]
]

{ #category : 'initialization' }
DJFaderElement >> markerColor [

	^ Color orange
]

{ #category : 'accessing' }
DJFaderElement >> sizeScale [
"Multiplier applied to ICMixerFader's widgetSize. Subclasses that must fit a tighter strip answer less than 1."
	^ 1
]

{ #category : 'defaults' }
DJFaderElement >> slotThickness [
	"ICMixerFader gives barThickness / 7. Half that is a trace rather than
	 a channel."

	^ self barThickness / 14
]

{ #category : 'size' }
DJFaderElement >> valueColor [

	^ Color transparent
]
