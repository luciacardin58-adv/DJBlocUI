"
I am a downsampled min/max peak representation of an audio file, used to draw waveforms cheaply at any zoom without re-reading raw samples.

I mirror JUCE's AudioThumbnail: I store one min/max pair per block of `samplesPerThumbSample` source samples (via #computeFrom:), then aggregate ranges of those pairs down to pixel resolution on demand (via #minMaxFrom:to: and #peaksForColumns:). This is what makes zoom cheap — peaks are stored once at a fine resolution and re-aggregated per view, never recomputed from the source.

I am Bloc-free and live in the audio layer, so I am testable headless and reusable by both the waveform element and the browser.

Peaks are Points: x = min, y = max, both normalized -1.0..1.0.

Simplifications vs JUCE: synchronous (no async LevelDataSource / ChangeBroadcaster), no int8 quantization or cache serialization, mono only. Add those back if large-file loading blocks the UI.

See DJWaveformElement for the consumer.
"
Class {
	#name : 'DJAudioThummbnail',
	#superclass : 'BlElement',
	#instVars : [
		'samplesPerThumbSample',
		'peaks',
		'sampleRate',
		'totalSamples'
	],
	#category : 'DjBlocUI',
	#package : 'DjBlocUI'
}

{ #category : 'instance creation' }
DJAudioThummbnail class >> fromFile: aPath [
	^ self new loadFromFile: aPath; yourself
]

{ #category : 'compute' }
DJAudioThummbnail >> computeFrom: samples [
	"samples: mono Float32Array in -1.0..1.0"
	| numThumbs result |
	totalSamples := samples size.
	numThumbs := (totalSamples / samplesPerThumbSample) ceiling.
	result := Array new: numThumbs.
	1 to: numThumbs do: [ :i |
		| start stop |
		start := (i - 1) * samplesPerThumbSample + 1.
		stop := (start + samplesPerThumbSample - 1) min: totalSamples.
		result at: i put: (self minMaxOf: samples from: start to: stop) ].
	peaks := result
]

{ #category : 'initialization' }
DJAudioThummbnail >> initialize [
	super initialize.
	samplesPerThumbSample := 512.
	peaks := Array new.
	totalSamples := 0.
	sampleRate := 0
]

{ #category : 'loading' }
DJAudioThummbnail >> loadFromFile: aPath [
	| reference format info samples |
	reference := aPath asFileReference.
	format := DJAudioFormat new formatForFile: reference.  "<- your manager selector"
	format ifNil: [ ^ self error: 'Unsupported: ', reference basename ].
	reference binaryReadStreamDo: [ :aStream |
		info := format readInfoFrom: aStream.                     "<- your header-parse selector"
		aStream position: 0.
		samples := format readSamplesFrom: aStream info: info ].
	sampleRate := info sampleRate.
	self computeFrom: samples
]

{ #category : 'compute' }
DJAudioThummbnail >> minMaxOf: samples from: startIndex to: stopIndex [
	| mn mx v |
	mn := samples at: startIndex.
	mx := mn.
	startIndex + 1 to: stopIndex do: [ :j |
		v := samples at: j.
		mn := mn min: v.
		mx := mx max: v ].
	^ mn @ mx
]

{ #category : 'accessing' }
DJAudioThummbnail >> peaksForColumns: nColumns [
	| result perColumn |
	(nColumns <= 0 or: [ peaks isEmpty ]) ifTrue: [ ^ Array new ].
	nColumns >= peaks size ifTrue: [ ^ peaks ].
	result := Array new: nColumns.
	perColumn := peaks size / nColumns.
	1 to: nColumns do: [ :c |
		| start stop |
		start := ((c - 1) * perColumn) floor + 1.
		stop := (c * perColumn) floor max: start.
		result at: c put: (self minMaxFrom: start to: stop) ].
	^ result
]
