"
I am the left column of the browser. I stack two nav panes vertically with a
draggable divider between them: DJPlaylistNavElement above,
DJFolderNavElement below.

I own neither pane's behaviour — I expose them so DJBrowserElement can wire
their actions. I only handle layout and chrome.
```language=pharo
    | sidebar |
    sidebar := DJBrowserSidebarElement new.
    sidebar playlistNav refresh.
    sidebar folderNav rootFolder: '~/Music' asFileReference.
```
I override installRawStyle because ToPane >> installRawStyle sets background from the #'background-color' token with no stamp escape hatch, which would paint over 
```language=pharo
DJTheme browserBackground.
```
Dividers must be added after the children are in place: 
```language=pharo
ToPane >> addDividers
```
walks self children pairwise.
"
Class {
	#name : 'DJBrowserSidebarElement',
	#superclass : 'ToPane',
	#instVars : [
		'playlistNav',
		'folderNav'
	],
	#category : 'DjBlocUI-Browser',
	#package : 'DjBlocUI',
	#tag : 'Browser'
}

{ #category : 'examples' }
DJBrowserSidebarElement class >> example [
	<script>

	| sidebar |
	sidebar := self new.
	sidebar playlistNav playlists: {
			(DJPlaylist named: 'House').
			(DJPlaylist named: 'Techno') }.
	sidebar folderNav rootFolder: FileLocator imageDirectory.
	sidebar inSpace
		extent: 240 @ 480;
		title: 'DJBrowserSidebarElement';
		show
]

{ #category : 'accessing' }
DJBrowserSidebarElement >> folderNav [ 
^ folderNav 
]

{ #category : 'initialization' }
DJBrowserSidebarElement >> initialize [

	super initialize.
	self beVertical.
	self matchParent.
	self initializeParts
]

{ #category : 'initialization' }
DJBrowserSidebarElement >> initializeParts [

	playlistNav := DJPlaylistNavElement new.
	playlistNav matchParent.
	folderNav := DJFolderNavElement new.
	folderNav matchParent.
	self addChildren: {
			playlistNav.
			folderNav }.
	self addDividers
]

{ #category : 'skin' }
DJBrowserSidebarElement >> installRawStyle [
	"ToPane >> installRawStyle paints the token background with no stamp
	 escape hatch, so the browser colours are applied after the super send."

	super installRawStyle.
	self background: DJTheme browserBackground.
	self border: (BlBorder paint: DJTheme browserBorder width: 1)
]

{ #category : 'accessing' }
DJBrowserSidebarElement >> playlistNav [

	^ playlistNav
]
