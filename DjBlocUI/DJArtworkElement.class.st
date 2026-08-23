"
I display a track''s cover image, or a placeholder glyph when there is none.

No format we read carries embedded artwork yet - WAV and AIFF do not, and MP3 support is ID3 only - so the placeholder is my normal state.'
"
Class {
	#name : 'DJArtworkElement',
	#superclass : 'DJPanelElement',
	#instVars : [
		'glyph'
	],
	#category : 'DjBlocUI-DeckHeader',
	#package : 'DjBlocUI',
	#tag : 'DeckHeader'
}

{ #category : 'api - bounds' }
DJArtworkElement class >> defaultSize [ 
^ 64
]

{ #category : 'helper' }
DJArtworkElement >> clear [
	glyph text: (DJTheme rope: '♪' color: DJTheme dimText size: 24)
]

{ #category : 'api - bounds' }
DJArtworkElement >> defaultSize [
	^ self class defaultSize
]

{ #category : 'initialization' }
DJArtworkElement >> initialize [

super initialize.
	self constraintsDo: [ :c |
		c horizontal exact: self  defaultSize.
		c vertical exact: self  defaultSize ]
]

{ #category : 'initialization' }
DJArtworkElement >> initializeParts [
	glyph := DJTheme textElement: '♪' color: DJTheme dimText size: 24.
	self addChild: glyph
]

{ #category : 'updating' }
DJArtworkElement >> track: aDJAudioFileInfo [
	^ self
]
