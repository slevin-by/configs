import XMonad
import qualified XMonad.StackSet as W
import qualified Data.Map as M
import System.Exit
import Graphics.X11.Xlib
import Graphics.X11.ExtraTypes.XF86
--import IO (Handle, hPutStrLn)
import qualified System.IO
import XMonad.Actions.CycleWS (nextScreen,prevScreen)
import Data.List
-- Prompts
import XMonad.Prompt
import XMonad.Prompt.Shell
-- Actions
import XMonad.Actions.MouseGestures
import XMonad.Actions.UpdatePointer
import XMonad.Actions.GridSelect
-- Utils
import XMonad.Util.Run (spawnPipe)
import XMonad.Util.Loggers
import XMonad.Util.EZConfig
import XMonad.Util.Scratchpad
-- Hooks
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.UrgencyHook
import XMonad.Hooks.Place
import XMonad.Hooks.EwmhDesktops
-- Layouts
import XMonad.Layout.NoBorders
import XMonad.Layout.ResizableTile
import XMonad.Layout.Tabbed
import XMonad.Layout.DragPane
import XMonad.Layout.LayoutCombinators hiding ((|||))
import XMonad.Layout.DecorationMadness
import XMonad.Layout.TabBarDecoration
import XMonad.Layout.IM
import XMonad.Layout.Grid
import XMonad.Layout.Spiral
import XMonad.Layout.Mosaic
import XMonad.Layout.LayoutHints
import Data.Ratio ((%))
import XMonad.Layout.ToggleLayouts
import XMonad.Layout.Spacing
import XMonad.Hooks.ManageHelpers
import XMonad.Layout.Gaps
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.SetWMName

defaults = defaultConfig
	{
			terminal			= "evilvte" -- "lxterminal"
		,	workspaces			= myWorkspaces
		,	modMask 			= mod4Mask
		,	layoutHook			= myLayoutHook
		,	handleEventHook		= fullscreenEventHook
		,	startupHook			= setWMName "LG3D"
		,	borderWidth			= 2
		,	manageHook			= myManageHook
		,	normalBorderColor	= "black"
		,	focusedBorderColor	= "blue"	-- "orange"
	}

myWorkspaces :: [String]
myWorkspaces = ["1:term", "2:dev", "3:web", "4:fs", "5:office"] ++ map show [6..9]

myTabConfig = defaultTheme
	{
			activeColor 			= "#6666cc"
		, 	activeBorderColor 		= "#000000"
		, 	inactiveColor 			= "#666666"
		, 	inactiveBorderColor 	= "#000000"
		, 	decoHeight 				= 10
	}

xmobarTitleColor = "#FFB6B0"
xmobarCurrentWorkspaceColor = "green"

-- myLayoutHook = tiled ||| Mirror tiled ||| Full

myLayoutHook = spacing 6 $ gaps [(U,15)] $ toggleLayouts (noBorders Full) $
    smartBorders $ tiled ||| Mirror tiled -- ||| mosaic 2 [3,2] ||| tabbed shrinkText myTabConfig	-- tiled was added
      where 
        tiled = Tall nmaster delta ratio
        nmaster = 1
        delta   = 3/100
        ratio   = 3/5

myManageHook :: ManageHook
myManageHook = composeAll . concat $
    [ 
    		[className =? c --> doF (W.shift "3:web")		| c <- myWeb]
    	, 	[className =? c --> doF (W.shift "2:dev")		| c <- myDev]
    	, 	[className =? c --> doF (W.shift "1:term")	    | c <- myTerm]
    	, 	[className =? c --> doF (W.shift "4:fs")		| c <- myFs]
    	,	[className =? c --> doF (W.shift "5:office")	| c <- myOffice]
    	, 	[manageDocks]
    ]
    where
	    myWeb = ["firefox", "ktorrent"]
	    myDev = ["emacs","sublime_text", "qtcreator", "geany", "ddd", "kdbg", "edb", "netbeans"]
	    myTerm = ["xterm", "lxterminal", "evilvte"]
	    myFs = ["krusader", "thunar"]
	    myOffice = ["okular"]

main = do
		xmproc <- spawnPipe "/usr/bin/xmobar ~/.xmonad/xmobar.hs"
		xmonad $ defaults {
		    	logHook =  dynamicLogWithPP $ defaultPP
		    		{
		            		ppOutput = System.IO.hPutStrLn xmproc
		          		, 	ppTitle = xmobarColor xmobarTitleColor "" . shorten 100
		          		, 	ppCurrent = xmobarColor xmobarCurrentWorkspaceColor "" . wrap "[" "]"
		          		, 	ppSep = "   "
		          		, 	ppWsSep = " "
		          		, 	ppLayout  = (\ x -> case x of
				              "Spacing 6 Mosaic"                      -> "[:]"
				              "Spacing 6 Mirror Tall"                 -> "[M]"
				              "Spacing 6 Tall"		                  -> "[M]"	-- added with tiled in myLayoutHook
				              "Spacing 6 Hinted Tabbed Simplest"      -> "[T]"
				              "Spacing 6 Full"                        -> "[ ]"
				              _										  -> x )
		          		, 	ppHiddenNoWindows = showNamedWorkspaces
		      		} 
			}
			where showNamedWorkspaces wsId = if any (`elem` wsId) ['a'..'z']
                                       		 then pad wsId
                                       		 else ""
