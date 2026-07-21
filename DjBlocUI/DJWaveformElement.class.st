"
I am a Bloc element that draws an audio waveform.

I render the min/max peak envelope held by a DJAudioThumbnail,
mirroring the split JUCE uses: the thumbnail owns the peak data
, and I own the drawing (UI layer).


See DJAudioThumbnail for the peak model.
"
Class {
	#name : 'DJWaveformElement',
	#superclass : 'BlElement',
	#instVars : [
		'thumbnail'
	],
	#category : 'DjBlocUI',
	#package : 'DjBlocUI'
}
