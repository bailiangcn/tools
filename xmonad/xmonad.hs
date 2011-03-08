import XMonad
import XMonad.Config.Gnome
import XMonad.ManageHook
import qualified XMonad.StackSet as W
import XMonad.Hooks.SetWMName

import XMonad.Config.Desktop

import XMonad.Layout.IM
import XMonad.Layout.PerWorkspace
import XMonad.Layout.Reflect

import XMonad.Util.EZConfig

myWorkspaces = ["1:main","2:web","3:gvim","4:media","5:graph","6:browse","7:dev","8:office","9:other"]

myManageHook = composeAll [ (className =? "Firefox" <&&> resource=? "Download") --> doFloat
        , (className =? "Firefox" <&&> resource =? "DTA") --> doFloat
        , (className =? "Vmplayer" <&&> title=? "new of Windows XP office - VMware Player") --> doF (W.shift "8:office")
        , (className =? "Rhythmbox" ) --> doF (W.shift "4:media")
        , className =? "Gimp-2.6"     --> doShift "5:graph"
        , className =? "MyPaint"     --> doShift "9:other"
        ]
myKeys =
    [
    -- other additional keys
    ]
    ++
    [ (mask ++ "M-" ++ [key], screenWorkspace scr >>= flip whenJust (windows . action))
         | (key, scr)  <- zip "wer" [1,0,2] -- was [0..] *** change to match your screen order ***
         , (action, mask) <- [ (W.view, "") , (W.shift, "S-")]
    ]
main = do
xmonad $ gnomeConfig
    {
        modMask = mod4Mask
        -- set the mod key to the windows key
        , XMonad.focusFollowsMouse = False
        --不设置鼠标跟随
        , borderWidth = 3
        ,layoutHook = desktopLayoutModifiers $ gimp 
        , workspaces = myWorkspaces
        , manageHook = myManageHook <+> manageHook gnomeConfig
        , startupHook = setWMName "LG3D"
    } `additionalKeysP` myKeys
    where
      gimp = withIM (0.11) (Role "gimp-toolbox") $ reflectHoriz $
             withIM (0.15) (Role "gimp-dock") $ reflectHoriz $
             layoutHook gnomeConfig 


