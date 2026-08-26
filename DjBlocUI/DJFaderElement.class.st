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

{ #category : 'api - bounds' }
DJFaderElement >> defaultColor [ 

^ Color transparent 
]

{ #category : 'initialization' }
DJFaderElement >> initialize [
"ICMixerFader derives handle, slot, ticks and font from barLength and barThickness, and barLength:thickness: recomputes them through applySize. widgetSize: only moves the box, which is why scaling it clipped the fader instead of shrinking it."
	super initialize.
	self
		barLength: (self defaultBarLength * self sizeScale) rounded
		thickness: (self defaultBarThickness * self sizeScale) rounded.
	self constraintsDo: [ :c |
		c horizontal exact: self widgetSize x.
		c vertical exact: self widgetSize y ]
]

{ #category : 'accessing' }
DJFaderElement >> sizeScale [
"Multiplier applied to ICMixerFader's widgetSize. Subclasses that must fit a tighter strip answer less than 1."
	^ 1
]
