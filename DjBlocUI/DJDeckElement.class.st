"
I am one complete deck: header, scrolling waveform, jog wheel, tempo
fader, sync and transport.

I am instantiated twice and hold no left or right knowledge. Ask me for
mirrored rather than sending a message after new - my parts are built in
initializeParts, which reads the flag, so it has to be set on basicNew
first. Only my controls row reverses; the header and transport bar keep
reading order, because mirrored text and a right-to-left transport read
badly.

I own no DSP state. I forward what I am told to my parts.
"
Class {
	#name : 'DJDeckElement',
	#superclass : 'DJPanelElement',
	#instVars : [
		'isMirrored',
		'header',
		'scrollingWaveform',
		'jogWheel',
		'tempoFader',
		'syncButton',
		'transportBar'
	],
	#category : 'DjBlocUI-DeckBody',
	#package : 'DjBlocUI',
	#tag : 'DeckBody'
}

{ #category : 'examples' }
DJDeckElement class >> example [
	<script>
	| space |
	space := self new inSpace.
	space extent: 430 @ 620.
	space title: 'Deck'.
	space show
]

{ #category : 'accessing' }
DJDeckElement class >> mirrored [
	"The right-hand deck."
	^ self basicNew
		  setMirrored: true;
		  initialize;
		  yourself
]

{ #category : 'instance creation' }
DJDeckElement class >> new [
	^ self basicNew
		  setMirrored: false;
		  initialize;
		  yourself
]

{ #category : 'accessing' }
DJDeckElement >> bpm: aNumber [
	jogWheel bpm: aNumber
]

{ #category : 'building' }
DJDeckElement >> buildControlsRow [
	| row parts |
	jogWheel := DJJogWheelElement new.
	tempoFader := DJTempoFaderElement new.
	syncButton := DJSyncButtonElement new.
	self wireSyncRelease.
	parts := { jogWheel. tempoFader. syncButton }.
	isMirrored ifTrue: [ parts := parts reversed ].
	row := DJPanelElement new beBare; beRow; yourself.
	row constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical exact: 250 ].
	row addChildren: parts.
	^ row
]

{ #category : 'accessing' }
DJDeckElement >> elapsed: aString [
	jogWheel elapsed: aString
]

{ #category : 'initialization' }
DJDeckElement >> initialize [
	super initialize.
	self beMatchingParent
]

{ #category : 'initialization' }
DJDeckElement >> initializeParts [
	header := DJDeckHeaderElement new.
	scrollingWaveform := DJScrollingWFElement new.
	transportBar := DJTransportBarElement new.
	self addChildren: {
		header.
		scrollingWaveform.
		self buildControlsRow.
		transportBar }
]

{ #category : 'actions' }
DJDeckElement >> loadTrack: aDJTrackModel [
	"Accept a browser track. DJTrackModel answers '--' for bpm until beat
	 detection is wired, so only the title is forwarded for now."

	header title: aDJTrackModel title
]

{ #category : 'helper' }
DJDeckElement >> rateMultiplier [
	^ tempoFader rateMultiplier
]

{ #category : 'helper' }
DJDeckElement >> setMirrored: aBoolean [
	isMirrored := aBoolean
]

{ #category : 'accessing' }
DJDeckElement >> track: aDJAudioFileInfo [
	header track: aDJAudioFileInfo
]

{ #category : 'building' }
DJDeckElement >> wireSyncRelease [
	"A hand on the tempo fader drops the sync latch. Sync itself moves
	 the fader with setValueSilently:, which does not fire callBack -
	 so only manual drags reach here and sync does not unlatch itself."
	tempoFader callBack: [ :each | syncButton release ]
]
