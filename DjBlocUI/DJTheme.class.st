"
I store colors for the UI
"
Class {
	#name : 'DJTheme',
	#superclass : 'Object',
	#category : 'DjBlocUI-Root',
	#package : 'DjBlocUI',
	#tag : 'Root'
}

{ #category : 'colors' }
DJTheme class >> accent [ 
 ^ Color cyan 
]

{ #category : 'colors' }
DJTheme class >> browserBackground [

	^ Color black
]

{ #category : 'colors' }
DJTheme class >> browserBorder [

^ Color cyan
]

{ #category : 'colors' }
DJTheme class >> browserText [ 

^ Color white
]

{ #category : 'colors' }
DJTheme class >> console [
    ^ Color r: 14 g: 14 b: 14 range: 255
]

{ #category : 'colors' }
DJTheme class >> dimText [ 
^ Color gray
]

{ #category : 'colors' }
DJTheme class >> gap [ 
^ 8
]

{ #category : 'colors' }
DJTheme class >> hairline [

	
		^ Color
			  r: 36
			  g: 36
			  b: 36
			  range: 255 
]

{ #category : 'colors' }
DJTheme class >> panel [

	
		^ Color
			  r: 20
			  g: 20
			  b: 20
			  range: 255 
]

{ #category : 'building' }
DJTheme class >> rope: aString color: aColor size: anInteger [
	^ aString asRopedText attributes: {
			  (BlTextForegroundAttribute paint: aColor).
			  (BlFontSizeAttribute size: anInteger) }
]

{ #category : 'building' }
DJTheme class >> stubLabel: aString [
	^ self textElement: aString color: self dimText size: 12
 
]

{ #category : 'colors' }
DJTheme class >> text [ 
^ Color veryLightGray
]

{ #category : 'building' }
DJTheme class >> textElement: aString color: aColor size: anInteger [
	^ BlTextElement new
		  text: (self rope: aString color: aColor size: anInteger);
		  yourself
]

{ #category : 'colors' }
DJTheme >> accent [
	^ self class accent
]

{ #category : 'colors' }
DJTheme >> console [
	^ self class console
]

{ #category : 'colors' }
DJTheme >> dimText [
	^ self class dimText
]

{ #category : 'colors' }
DJTheme >> gap [
	^ self class gap
]

{ #category : 'colors' }
DJTheme >> hairline [
	^ self class hairline
]

{ #category : 'colors' }
DJTheme >> panel [
	^ self class panel
]

{ #category : 'colors' }
DJTheme >> text [
	^ self class text
]
