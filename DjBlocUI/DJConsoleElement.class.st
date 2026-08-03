"
I am the root element of the DJ application.
I lay out two decks, two channel strips, the transport bars and the crossfader.
"
Class {
	#name : 'DJConsoleElement',
	#superclass : 'DJPanelElement',
	#instVars : [
		'leftDeck',
		'rightDeck',
		'mixer',
		'browser'
	],
	#category : 'DjBlocUI-Root',
	#package : 'DjBlocUI',
	#tag : 'Root'
}

{ #category : 'accessing' }
DJConsoleElement >> browser [ 
^ browser
]

{ #category : 'building' }
DJConsoleElement >> buildConsoleRow [

	
    | row |
    leftDeck := DJDeckElement new.
    mixer := DJMixerElement new.
    rightDeck := DJDeckElement new beMirrored.
 
    row := DJPanelElement new
               beRow;
               background: Color transparent;
               border: BlBorder empty;
               padding: BlInsets empty;
               yourself.
    row constraintsDo: [ :c |
        c horizontal matchParent.
        c vertical matchParent ].
    row addChildren: { leftDeck. mixer. rightDeck }.
    ^ row
]

{ #category : 'initialization' }
DJConsoleElement >> initialize [
 
    super initialize.
    self background: DJTheme console.
    self size: 1280 @ 900
]

{ #category : 'initialization' }
DJConsoleElement >> initializeParts [
 
    self addChild: self buildConsoleRow.
    browser := DJBrowserElement new.
    self addChild: browser
]

{ #category : 'accessing' }
DJConsoleElement >> leftDeck [
^ leftDeck
]

{ #category : 'accessing' }
DJConsoleElement >> mixer [ 
^ mixer
]

{ #category : 'accessing' }
DJConsoleElement >> rightDeck [ 

	^ rightDeck
]
