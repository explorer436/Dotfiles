-- xmonad config file.
--
-- A template showing all available configuration hooks,
-- and how to override the defaults in your own xmonad.hs conf file.
--
-- Normally, you'd only override those defaults you care about.

-- IMPORTS

-- import XMonad (XConfig (..) ,startupHook, logHook, handleEventHook, manageHook, layoutHook, mouseBindings, keys, focusedBorderColor, normalBorderColor, workspaces, modMask, borderWidth, clickJustFocuses, focusFollowsMouse, terminal, def, xmonad, spawn, doIgnore, resource, doFloat, className)

import XMonad
import Data.Monoid
import System.Exit

-- https://hackage.haskell.org/package/xmonad-0.15/docs/XMonad-StackSet.html#g:2
import qualified XMonad.StackSet as W
import qualified Data.Map        as M

import XMonad.Util.SpawnOnce (spawnOnce)
import XMonad.Util.Run (spawnPipe)

-- https://hackage.haskell.org/package/xmonad-contrib-0.13/docs/XMonad-Hooks-ManageDocks.html
-- This module provides tools to automatically manage dock type programs, such as gnome-panel, kicker, dzen, and xmobar. 
import XMonad.Hooks.ManageDocks (docks, avoidStruts)

-- https://hackage.haskell.org/package/xmonad-contrib-0.16/docs/XMonad-Hooks-DynamicLog.html
import XMonad.Hooks.DynamicLog (statusBar, dynamicLogWithPP, wrap, xmobarPP, xmobarColor, shorten, PP(..))

import System.IO (hPutStrLn)
import XMonad.Hooks.WorkspaceHistory (workspaceHistoryHook)

import MyKeysConfig (myKeys)

-- https://hackage.haskell.org/package/xmonad-contrib-0.16/docs/XMonad-Hooks-EwmhDesktops.html
-- import XMonad.Hooks.EwmhDesktops (ewmh)

-- The preferred terminal program, which is used in a binding below and by
-- certain contrib modules.
--
myTerminal      = "xfce4-terminal"

-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

-- Whether clicking on a window to focus also passes the click to the window
myClickJustFocuses :: Bool
myClickJustFocuses = False

-- Width of the window border in pixels.
--
myBorderWidth   = 2

-- modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "windows key" is usually mod4Mask.
--
-- myModMask       = mod1Mask
-- change the modkey from "left alt" to "super key" which is also called the windows key
myModMask       = mod4Mask 

-- The default number of workspaces (virtual screens) and their names.
-- By default we use numeric strings, but any string may be used as a
-- workspace name. The number of workspaces is determined by the length
-- of this list.
--
-- A tagging example:
--
-- > workspaces = ["web", "irc", "code" ] ++ map show [4..9]
--
myWorkspaces    = ["1","2","3","4","5","6","7","8","9"]

myClickableWorkspaces :: [String]
myClickableWorkspaces = clickable . (map xmobarEscape)
               $ [" 1 ", " 2 ", " 3 ", " 4 ", " 5 ", " 6 ", " 7 ", " 8 ", " 9 "]
               -- $ [" dev ", " www ", " sys ", " doc ", " vbox ", " chat ", " mus ", " vid ", " gfx "]
  where
        clickable l = [ "<action=xdotool key super+" ++ show (n) ++ ">" ++ ws ++ "</action>" |
                      (i,ws) <- zip [1..9] l,
                      let n = i ]

xmobarEscape :: String -> String
xmobarEscape = concatMap doubleLts
  where
        doubleLts '<' = "<<"
        doubleLts x   = [x]


-- Border colors for unfocused and focused windows, respectively.
--
myNormalBorderColor  = "#dddddd"
myFocusedBorderColor = "#ff0000"

------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $

    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))

    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))

    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]

------------------------------------------------------------------------
-- Layouts:

-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.
--
myLayout = avoidStruts (tiled ||| Mirror tiled ||| Full)
  where
     -- default tiling algorithm partitions the screen into two panes
     tiled   = Tall nmaster delta ratio

     -- The default number of windows in the master pane
     nmaster = 1

     -- Default proportion of screen occupied by master pane
     ratio   = 1/2

     -- Percent of screen to increment by when resizing panes
     delta   = 3/100

------------------------------------------------------------------------
-- Window rules:

-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--
myManageHook = composeAll
    [ className =? "MPlayer"        --> doFloat
    , className =? "Gimp"           --> doFloat
    , resource  =? "desktop_window" --> doIgnore
    , resource  =? "kdesktop"       --> doIgnore ]

------------------------------------------------------------------------
-- Event handling

-- * EwmhDesktops users should change this to ewmhDesktopsEventHook
--
-- Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.
--
myEventHook = mempty

------------------------------------------------------------------------
-- Status bars and logging

-- Perform an arbitrary action on each internal state change or X event.
-- See the 'XMonad.Hooks.DynamicLog' extension for examples.

-- myLogHook h = return ()
myLogHook h = dynamicLogWithPP $ def { ppOutput = hPutStrLn h }

{- |
myLogHook :: X ()
myLogHook = fadeInactiveLogHook fadeAmount
            where fadeAmount = 1.0

windowCount :: X (Maybe String)
windowCount = gets $ Just . show . length . W.integrate' . W.stack . W.workspace . W.current . windowset
-}

------------------------------------------------------------------------
-- Startup hook

-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
-- By default, do nothing.
myStartupHook = do
    spawn "/home/.xmonad/scripts/autostart.sh"
    spawnOnce "variety &"
    -- spawnOnce "picom &"

------------------------------------------------------------------------
-- Command to launch the bar.
myBar = "xmobar"

-- Custom PP, configure it as you like. It determines what is being written to the bar.
myPP = xmobarPP { ppCurrent = xmobarColor "#429942" "" . wrap "|" "|" }

-- Key binding to toggle the gap for the bar.
toggleStrutsKey XConfig {XMonad.modMask = modMask} = (modMask, xK_b)

------------------------------------------------------------------------
-- A structure containing your configuration settings, overriding
-- fields in the default config. Any you don't override, will
-- use the defaults defined in xmonad/XMonad/Config.hs

-- Run xmonad with the settings that we specify.

main :: IO ()
-- main = xmonad =<< statusBar myBar myPP toggleStrutsKey defaults
main = do
  -- 0 stands for monitor 1
  xmproc <- spawnPipe "xmobar -x 0 /home/explorer436/.config/xmobar/xmobarrc"
  xmonad $ docks (defaults xmproc)
--  xmonad $ ewmh defaults

defaults h = def {
      -- simple stuff
        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        clickJustFocuses   = myClickJustFocuses,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        workspaces         = myWorkspaces,
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,

      -- key bindings
        keys               = myKeys,
        mouseBindings      = myMouseBindings,

      -- hooks, layouts
        layoutHook         = myLayout,
        manageHook         = myManageHook,
        handleEventHook    = myEventHook,
        logHook            = myLogHook h,
        startupHook        = myStartupHook
}


