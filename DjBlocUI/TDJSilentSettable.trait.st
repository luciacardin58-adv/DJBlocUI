"
I let a control be moved from code without announcing it.

My users route setValue: through a callBack self-send. During setValueSilently:
I answer nil to that send, so the callback is skipped while the handle, marker
and label all still update.

Without me, code that moves a control triggers the same handler as a human
dragging it - and if that handler writes back, the two echo each other forever
"
Trait {
	#name : 'TDJSilentSettable',
	#instVars : [
		'suppressCallback'
	],
	#category : 'DjBlocUI-Traits',
	#package : 'DjBlocUI',
	#tag : 'Traits'
}

{ #category : 'accessing' }
TDJSilentSettable >> callBack [
    ^ suppressCallback == true ifTrue: [ nil ] ifFalse: [ super callBack ]
]

{ #category : 'initialization' }
TDJSilentSettable >> setValueSilently: aNumber [
    suppressCallback := true.
    [ self setValue: aNumber ] ensure: [ suppressCallback := false ]
]
