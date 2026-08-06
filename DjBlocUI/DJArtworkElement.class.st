"
I display a track's cover image, or a placeholder glyph when there is none.
"
Class {
	#name : 'DJArtworkElement',
	#superclass : 'DJStubElement',
	#category : 'DjBlocUI-DeckHeader',
	#package : 'DjBlocUI',
	#tag : 'DeckHeader'
}

{ #category : 'initialization' }
DJArtworkElement >> initialize [
	super initialize.
	self constraintsDo: [ :c |
		c horizontal exact: 64.
		c vertical exact: 64 ]
]

{ #category : 'updating' }
DJArtworkElement >> track: aDJAudioFileInfo [
	^ self
]
