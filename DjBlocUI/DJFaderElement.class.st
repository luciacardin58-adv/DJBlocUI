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

{ #category : 'initialization' }
DJFaderElement >> initialize [
	"widgetSize: sends size:, which a parent layout can override the
	 same way it collapsed the knob. Declare the size so the fader
	 keeps its 74 x 244 wherever it is placed."
	super initialize.
	self constraintsDo: [ :c |
		c horizontal exact: self widgetSize x.
		c vertical exact: self widgetSize y ]
]
