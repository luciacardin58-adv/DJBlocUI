Class {
	#name : 'DJTrackTableElementTest',
	#superclass : 'TestCase',
	#instVars : [
		'table',
		'tempRoot',
		'space',
		'nav',
		'source'
	],
	#category : 'DjBlocUI-Tests',
	#package : 'DjBlocUI',
	#tag : 'Tests'
}

{ #category : 'running' }
DJTrackTableElementTest >> setUp [

	super setUp.
	table := DJTrackTableElement new.
	table tracks: {
			(DJTrackModel on: nil path: '/music/one.wav' asFileReference).
			(DJTrackModel on: nil path: '/music/two.wav' asFileReference) }
]

{ #category : 'initialization' }
DJTrackTableElementTest >> setUpCrate [
	"A folder with two audio files, one non-audio file and one subfolder."

	tempRoot := FileLocator temp / 'DJTrackTableElementTest' , Time now asMilliSeconds printString.
	tempRoot ensureCreateDirectory.
	(tempRoot / 'alpha.wav') ensureCreateFile.
	(tempRoot / 'zulu.aiff') ensureCreateFile.
	(tempRoot / 'notes.txt') ensureCreateFile.
	(tempRoot / 'Sub') ensureCreateDirectory.
	((tempRoot / 'Sub') / 'buried.wav') ensureCreateFile
]

{ #category : 'initialization' }
DJTrackTableElementTest >> setUpDragSourceOn: aFileReference [

	source := DJTestDragSource new
		          dragPayload: aFileReference;
		          yourself
]

{ #category : 'running' }
DJTrackTableElementTest >> tearDown [

	tempRoot ifNotNil: [ tempRoot ensureDeleteAll ].
	super tearDown
]

{ #category : 'tests' }
DJTrackTableElementTest >> testActionNotEvaluatedWithoutSelection [

	| notified |
	notified := false.
	table trackActivatedAction: [ :aTrack | notified := true ].
	table notifyTrackActivated.
	self deny: notified
]

{ #category : 'tests' }
DJTrackTableElementTest >> testActionReceivesActivatedTrack [

	| notified |
	notified := nil.
	table trackActivatedAction: [ :aTrack | notified := aTrack ].
	table list selecter selectIndex: 1.
	table notifyTrackActivated.
	self deny: notified isNil.
	self assert: notified title equals: 'one.wav'
]

{ #category : 'initialization' }
DJTrackTableElementTest >> testAddTracksForFilesAnswersWhatItAdded [

	| added |
	self setUpCrate.
	added := table addTracksForFiles: {
			         (tempRoot / 'alpha.wav').
			         (tempRoot / 'zulu.aiff') }.
	self assert: added size equals: 2
]

{ #category : 'initialization' }
DJTrackTableElementTest >> testAddTracksForFilesAppends [

	self setUpCrate.
	table addTracksForFiles: { tempRoot / 'alpha.wav' }.
	self assert: table tracks size equals: 3.
	self assert: table tracks last title equals: 'alpha.wav'
]

{ #category : 'initialization' }
DJTrackTableElementTest >> testAddTracksForFilesKeepsExistingTracks [

	self setUpCrate.
	table addTracksForFiles: { tempRoot / 'alpha.wav' }.
	self assert: table tracks first title equals: 'one.wav'
]

{ #category : 'initialization' }
DJTrackTableElementTest >> testAddTracksForFilesSkipsDuplicatesAlreadyListed [

	| added |
	self setUpCrate.
	table addTracksForFiles: { tempRoot / 'alpha.wav' }.
	added := table addTracksForFiles: { tempRoot / 'alpha.wav' }.
	self assert: added isEmpty.
	self assert: table tracks size equals: 3
]

{ #category : 'initialization' }
DJTrackTableElementTest >> testAddTracksForFilesSkipsDuplicatesWithinOneDrop [

	| added |
	self setUpCrate.
	added := table addTracksForFiles: {
			         (tempRoot / 'alpha.wav').
			         (tempRoot / 'alpha.wav') }.
	self assert: added size equals: 1
]

{ #category : 'initialization' }
DJTrackTableElementTest >> testAudioFilesFromForeignSourceIsEmpty [
"Any element that is not one of my drag sources is rejected rather than raising a DNU."

	self assert: (table audioFilesFrom: BlElement new) isEmpty
]

{ #category : 'initialization' }
DJTrackTableElementTest >> testAudioFilesFromNilSourceIsEmpty [

	self assert: (table audioFilesFrom: nil) isEmpty
]

{ #category : 'initialization' }
DJTrackTableElementTest >> testAudioFilesInDirectory [

	| basenames |
	self setUpCrate.
	basenames := (table audioFilesIn: tempRoot) collect: [ :each | each basename ].
	self assert: basenames asArray equals: #( 'alpha.wav' 'zulu.aiff' )
]

{ #category : 'initialization' }
DJTrackTableElementTest >> testAudioFilesInDirectoryDoesNotRecurse [

	| basenames |
	self setUpCrate.
	basenames := (table audioFilesIn: tempRoot) collect: [ :each | each basename ].
	self deny: (basenames includes: 'buried.wav')
]

{ #category : 'initialization' }
DJTrackTableElementTest >> testAudioFilesInNonAudioFileIsEmpty [

	self setUpCrate.
	self assert: (table audioFilesIn: tempRoot / 'notes.txt') isEmpty
]

{ #category : 'initialization' }
DJTrackTableElementTest >> testAudioFilesInSingleFile [

	self setUpCrate.
	self
		assert: ((table audioFilesIn: tempRoot / 'alpha.wav') collect: [ :each | each basename ]) asArray
		equals: #( 'alpha.wav' )
]

{ #category : 'tests' }
DJTrackTableElementTest >> testColumnDataIndexes [

	| indexes |
	indexes := table columns collect: [ :each | each dataIndex ].
	self assert: indexes asArray equals: #( 'title' 'artist' 'bpm' 'genre' )
]

{ #category : 'tests' }
DJTrackTableElementTest >> testColumnTitles [

	| titles |
	titles := table columns collect: [ :each | each title ].
	self assert: titles asArray equals: #( 'Title' 'Artist' 'BPM' 'Genre' )
]

{ #category : 'initialization' }
DJTrackTableElementTest >> testDropAddsTracks [

	self setUpCrate.
	self setUpDragSourceOn: tempRoot.
	table dispatchEvent: (BlDropEvent new
			 position: 50 @ 50;
			 gestureSource: source;
			 yourself).
	self assert: table tracks size equals: 4
]

{ #category : 'initialization' }
DJTrackTableElementTest >> testDropDoesNotNotifyWhenNothingNew [

	| notified |
	self setUpCrate.
	self setUpDragSourceOn: tempRoot.
	table addTracksForFiles: (table audioFilesIn: tempRoot).
	notified := false.
	table tracksDroppedAction: [ :aCollection | notified := true ].
	table dispatchEvent: (BlDropEvent new
			 position: 50 @ 50;
			 gestureSource: source;
			 yourself).
	self deny: notified
]

{ #category : 'initialization' }
DJTrackTableElementTest >> testDropIsConsumed [

	| event |
	self setUpCrate.
	self setUpDragSourceOn: tempRoot.
	event := BlDropEvent new
		         position: 50 @ 50;
		         gestureSource: source;
		         yourself.
	table dispatchEvent: event.
	self assert: event isConsumed
]

{ #category : 'initialization' }
DJTrackTableElementTest >> testDropNotifiesWithAddedTracks [

	| notified |
	self setUpCrate.
	self setUpDragSourceOn: tempRoot.
	notified := nil.
	table tracksDroppedAction: [ :aCollection | notified := aCollection ].
	table dispatchEvent: (BlDropEvent new
			 position: 50 @ 50;
			 gestureSource: source;
			 yourself).
	self assert: notified size equals: 2
]

{ #category : 'tests' }
DJTrackTableElementTest >> testDropOfNonAudioIsRejected [

	| event |
	self setUpCrate.
	event := BlDropEvent new
		         position: 50 @ 50;
		         gestureSource: BlElement new;
		         yourself.
	table dispatchEvent: event.
	self deny: event isConsumed.
	self assert: table tracks size equals: 2
]

{ #category : 'tests' }
DJTrackTableElementTest >> testFourColumns [

	self assert: table columns size equals: 4
]

{ #category : 'initialization' }
DJTrackTableElementTest >> testIsAudioFileAcceptsWavAndAiff [

	self assert: (table isAudioFile: '/music/one.wav' asFileReference).
	self assert: (table isAudioFile: '/music/one.aiff' asFileReference).
	self assert: (table isAudioFile: '/music/one.aif' asFileReference)
]

{ #category : 'initialization' }
DJTrackTableElementTest >> testIsAudioFileIsCaseInsensitive [

	self assert: (table isAudioFile: '/music/ONE.WAV' asFileReference)
]

{ #category : 'initialization' }
DJTrackTableElementTest >> testIsAudioFileRejectsOthers [

	self deny: (table isAudioFile: '/music/notes.txt' asFileReference).
	self deny: (table isAudioFile: '/music/one.mp3' asFileReference)
]

{ #category : 'tests' }
DJTrackTableElementTest >> testNothingSelectedInitially [

	self assert: table selectedTrack isNil
]

{ #category : 'tests' }
DJTrackTableElementTest >> testReplacingTracksClearsSelection [

	table list selecter selectIndex: 1.
	table tracks: { (DJTrackModel on: nil path: '/music/fresh.wav' asFileReference) }.
	self assert: table selectedTrack isNil
]

{ #category : 'tests' }
DJTrackTableElementTest >> testSelectedTrackAfterSelectIndex [

	table list selecter selectIndex: 2.
	self deny: table selectedTrack isNil.
	self assert: table selectedTrack title equals: 'two.wav'
]

{ #category : 'tests' }
DJTrackTableElementTest >> testTracksAreShown [

	self assert: table tracks size equals: 2
]

{ #category : 'tests' }
DJTrackTableElementTest >> testTracksInOrder [

	self assert: table tracks first title equals: 'one.wav'.
	self assert: table tracks last title equals: 'two.wav'
]

{ #category : 'tests' }
DJTrackTableElementTest >> testTracksReplacesPreviousContent [

	table tracks: { (DJTrackModel on: nil path: '/music/only.wav' asFileReference) }.
	self assert: table tracks size equals: 1.
	self assert: table tracks first title equals: 'only.wav'
]
