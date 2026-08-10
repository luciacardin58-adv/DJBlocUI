"
I toggle a deck between playing and paused and reflect its state.

My deck sets me with setValueSilently: when it stops itself, end of track, or a load, hence I show stopped without asking the deck to stop a second time.
"
Class {
	#name : 'DJPlayButtonElement',
	#superclass : 'DJButtonElement',
	#category : 'DjBlocUI-Transport',
	#package : 'DjBlocUI',
	#tag : 'Transport'
}

{ #category : 'initialization' }
DJPlayButtonElement >> initialize [

	super initialize.
	inputText := 'play'.

	self isToggleable: true
]

{ #category : 'testing' }
DJPlayButtonElement >> isPlaying [ 
^ self isOn
]

{ #category : 'helper' }
DJPlayButtonElement >> showStopped [
	"The deck stopped itself. Silent, or it hears its own news back."
	self setValueSilently: false
]
