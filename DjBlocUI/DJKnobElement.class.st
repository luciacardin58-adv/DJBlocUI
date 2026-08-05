"
I am the base rotary control, an ICDarkKnob2 with the same vow of silence
as DJFaderElement. Restyle me by overriding knobColor, markerColor,
outerRingColor and valueColor - ICDarkKnob2 holds nothing else.
"
Class {
	#name : 'DJKnobElement',
	#superclass : 'ICDarkKnob2',
	#traits : 'TDJSilentSettable',
	#classTraits : 'TDJSilentSettable classTrait',
	#category : 'DjBlocUI-SimpleWidgets',
	#package : 'DjBlocUI',
	#tag : 'SimpleWidgets'
}

{ #category : 'examples' }
DJKnobElement class >> example [

    <script>
    | container |
    container := BlElement new
                     background: DJTheme console;
                     padding: (BlInsets all: 20);
                     layout: BlFlowLayout horizontal;
                     clipChildren: false;
                     yourself.
    container addChild: self new.
    (container openInSpace)
        extent: 240 @ 240;
        title: 'DJKnobElement'
]
