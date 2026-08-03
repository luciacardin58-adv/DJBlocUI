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
