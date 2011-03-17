{- xmonad.hs
 - Author: Jelle van der Waa ( jelly12gen )
 - http://www.haskell.org/haskellwiki/Xmonad/Config_archive/jelly(12gen)%27s_xmonad.hs
 - Changed: Bailiang (bailiangcn@gmail.com)
 -}
 
-- Import stuff
import XMonad
import qualified XMonad.StackSet as W 
import qualified Data.Map as M
import XMonad.Util.EZConfig(additionalKeys)
import System.Exit
import Graphics.X11.Xlib
import System.IO 

 
 
-- actions
import XMonad.Actions.CycleWS
import XMonad.Actions.WindowGo
import qualified XMonad.Actions.Search as S
import XMonad.Actions.Search
import qualified XMonad.Actions.Submap as SM
import XMonad.Actions.GridSelect
 
-- utils
import XMonad.Util.Scratchpad (scratchpadSpawnAction, scratchpadManageHook, scratchpadFilterOutWorkspace)
import XMonad.Util.Run(spawnPipe)
import qualified XMonad.Prompt      as P
import XMonad.Prompt.Shell
import XMonad.Prompt
import XMonad.Prompt.Input
 
 
-- hooks
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.UrgencyHook
import XMonad.Hooks.ManageHelpers
 
-- layouts
import XMonad.Layout.NoBorders
import XMonad.Layout.ResizableTile
import XMonad.Layout.Reflect
import XMonad.Layout.IM
import XMonad.Layout.Tabbed
import XMonad.Layout.PerWorkspace (onWorkspace)
import XMonad.Layout.Grid
import XMonad.Layout.LayoutHints
 
-- Data.Ratio for IM layout
import Data.Ratio ((%))
 
 
-- Main --
-- 主框架,不需要调整
main = do
        xmproc <- spawnPipe "xmobar"  -- start xmobar
        xmonad  $ withUrgencyHook NoUrgencyHook $ defaultConfig
            { manageHook = myManageHook
            , layoutHook = myLayoutHook  
            , borderWidth = myBorderWidth
            , normalBorderColor = myNormalBorderColor
            , focusedBorderColor = myFocusedBorderColor
            , keys = myKeys
            , logHook = myLogHook xmproc
            , modMask = myModMask  
            , terminal = myTerminal
            , workspaces = myWorkspaces
            , focusFollowsMouse = False
            }
 
 
 
-- 下面为自定义部分,根据实际情况进行调整
--
--
-- hooks
-- 自动切换应用程序到各工作区
-- automaticly switching app to workspace 
myManageHook :: ManageHook
myManageHook = scratchpadManageHook (W.RationalRect 0.25 0.375 0.5 0.35) <+> ( composeAll . concat $
                [[isFullscreen                  --> doFullFloat
        , className =?  "Xmessage"              --> doCenterFloat 
        , className =?  "Zenity"                --> doCenterFloat 
        , className =? "feh"                    --> doCenterFloat 
        , className =? "Gnote"                  --> doCenterFloat 
        , (className =? "Minefield" <&&> appName =? "Download" )  --> doCenterFloat
        , className =? "Firefox"                --> doShift "1:web"  
        , className =? "Gvim"                   --> doShift "3:gvim"
        , className =? "Evince"                 --> doShift "4:pdf"
        , className =? "OpenOffice.org 3.2"     --> doShift "5:doc" 
        , className =? "Pidgin"                 --> doShift "7:chat"
        , className =? "Skype"                  --> doShift "7:chat"
        , className =? "MPlayer"                --> doShift "8:media"
        , className =? "Linux1g1g"              --> doShift "8:media"
        , className =? "Gimp"                   --> doShift "9:gimp"
        , title =? "new of Windows XP office - VMware Workstation" --> doShift "6:virtual"
        , title =? "new of Windows XP office - VMware Player"      --> doShift "6:virtual"
        ] ]
                        )  <+> manageDocks 
 
--logHook
myLogHook :: Handle -> X ()
myLogHook h = dynamicLogWithPP $ customPP { ppOutput = hPutStrLn h }
 
 
 
---- Looks --
---- bar
customPP :: PP
customPP = defaultPP { 
                    ppHidden = xmobarColor "#00FF00" ""
              , ppCurrent = xmobarColor "#FF0000" "" . wrap "[" "]"
              , ppUrgent = xmobarColor "#FF0000" "" . wrap "*" "*"
                          , ppLayout = xmobarColor "#FF0000" ""
                          , ppTitle = xmobarColor "#00FF00" "" . shorten 80
                          , ppSep = "<fc=#0033FF> | </fc>"
                     }
 
-- some nice colors for the prompt windows to match the xmobar status bar.
myXPConfig = defaultXPConfig                                    
    { 
    font  = "xft:DejaVu Sans Mono-12" 
    ,fgColor = "black"
    , bgColor = "Aquamarine3"
    , bgHLight    = "darkslategray4"
    , fgHLight    = "black"
    , position = Top
    , borderColor = "black"
    , promptBorderWidth = 1
    , height     = 24
    }
 
--- My Theme For Tabbed layout
myTheme = defaultTheme { decoHeight = 16
                        , activeColor = "#a6c292"
                        , activeBorderColor = "#a6c292"
                        , activeTextColor = "#000000"
                        , inactiveBorderColor = "#000000"
                        }
 
--LayoutHook
myLayoutHook  =  onWorkspace "1:web" webL $ onWorkspace "2:code" codeL $ onWorkspace "3:gvim" gvimL $ onWorkspace "9:gimp" gimpL $ onWorkspace "6:virtual" fullL $ onWorkspace "7:chat" imLayout $ onWorkspace "8:media" fullL $ standardLayouts 
   where
    standardLayouts =   avoidStruts  $ (tiled |||  reflectTiled ||| Mirror tiled ||| Grid ||| Full) 
 
    --Layouts
    tiled     = smartBorders (ResizableTall 1 (2/100) (1/2) [])
    reflectTiled = (reflectHoriz tiled)
    tabLayout = (tabbed shrinkText myTheme)
    full      = noBorders Full
    hited = Tall 1 (3/100) (1/2) 
 
    --Im Layout
    imLayout = avoidStruts $ smartBorders $ withIM ratio pidginRoster $ reflectHoriz $ withIM skypeRatio skypeRoster (tiled ||| reflectTiled ||| Grid) where
    chatLayout = Grid
    ratio = (1%9)
    skypeRatio = (1%8)
    pidginRoster    = And (ClassName "Pidgin") (Role "buddy_list")
    skypeRoster     = (ClassName "Skype") `And` (Not (Title "Options")) `And` (Not (Role "Chats")) `And` (Not (Role "CallWindowForm"))
 
    --Gimp Layout
    gimpL = avoidStruts $ smartBorders $ withIM (0.11) (Role "gimp-toolbox") $ reflectHoriz $ withIM (0.15) (Role "gimp-dock") Full 

    --Web Layout
    webL      = avoidStruts $  tabLayout  ||| tiled ||| reflectHoriz tiled ||| full

    --VirtualLayout
    fullL = avoidStruts $ full

    --CodeLayout
    codeL  = avoidStruts $  tabLayout  ||| tiled ||| reflectHoriz tiled    

    --GvimLayout
    gvimL = avoidStruts $ layoutHints ( hited ||| tabLayout  ||| reflectHoriz hited )


-------------------------------------------------------------------------------
---- Terminal --
myTerminal :: String
myTerminal = "urxvt"

-------------------------------------------------------------------------------
-- Keys/Button bindings --
-- modmask
myModMask :: KeyMask
myModMask = mod4Mask

-- 配置 mod+g 的字体
--mygsconfig :: HasColorizer
mygsconfig = defaultGSConfig  { gs_font ="文泉驿等宽正黑"}


-- borders
myBorderWidth :: Dimension
myBorderWidth = 4
--  
myNormalBorderColor, myFocusedBorderColor :: String
myNormalBorderColor = "#333333"
myFocusedBorderColor = "#FF0000"
--
 
 
--Workspaces
myWorkspaces :: [WorkspaceId]
myWorkspaces = ["1:web", "2:code", "3:gvim", "4:pdf", "5:doc", "6:virtual" ,"7:chat", "8:media", "9:gimp"] 
--
 
-- Switch to the "web" workspace
-- viewWeb = windows (W.greedyView "1:web")                           -- (0,0a)
--
 
--搜索引擎的配置
--Search engines to be selected :  [google (g), Baidu (b), Dict (d)  ]
--快捷键
searchEngineMap method = M.fromList $
       [ ((0, xK_g), method S.google )
       , ((0, xK_b), method $ S.searchEngine "Baidu" "http://www.baidu.com/s?wd=")
       , ((0, xK_d), method $ S.searchEngine "Dict" "http://translate.google.com/#en|zh-CN|")
       ]
 
nextmusic = "echo next > /tmp/linux1g1g "

-- keys
myKeys :: XConfig Layout -> M.Map (KeyMask, KeySym) (X ())
myKeys conf@(XConfig {XMonad.modMask = modMask}) = M.fromList $
    -- killing programs
    -- mod+shift+return  开一个新的终端窗口
    -- mod+shift+c  关闭当前窗口
    [ ((modMask .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf)
    , ((modMask .|. shiftMask, xK_c ), kill)
 
    -- opening program launcher / search engine
    -- mod + s + <searchengine> 打开一个提示窗口用于输入搜索内容
    -- mod+p  打开dmenu命令条
    , ((modMask , xK_s ), SM.submap $ searchEngineMap $ S.promptSearchBrowser myXPConfig  "firefox")
    ,((modMask , xK_p), shellPrompt myXPConfig)
    -- mod+shift+p 管理员权限打开dmenu
    ,((modMask .|. shiftMask, xK_p), spawn "gksudo   /home/bl/bin/sudodmenu")

    -- mod+F2 打开编辑文件菜单
    ,((modMask,     xK_F2    ), spawn  (myTerminal ++ " -e sh -c '/home/bl/bin/editconfig'"))

    -- GridSelect
    -- mod+g  表格选择的方式选择工作区(不能显示中文)
    --, ((modMask, xK_g), spawnSelected defaultGSConfig ["xterm","gvim"])
    , ((modMask, xK_g), goToSelected mygsconfig)
 
    -- layouts
    -- mod+b 如果看不到xmobar，可以toggle
    , ((modMask, xK_space ), sendMessage NextLayout)
    , ((modMask .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)
    , ((modMask, xK_b ), sendMessage ToggleStruts)
 
    -- floating layer stuff
    -- 取消浮动窗口
    , ((modMask, xK_t ), withFocused $ windows . W.sink)
 
    -- refresh
    -- 页面刷新
    , ((modMask, xK_n ), refresh)
    --
    -- 去掉gvim的讨厌白边
    , ((modMask,  xK_v ), spawn "gvim; xdotool key Super+n")
    -- focus
    -- 取得焦点
    , ((modMask, xK_Tab ), windows W.focusDown)
    , ((modMask, xK_j ), windows W.focusDown)
    , ((modMask, xK_k ), windows W.focusUp)
    , ((modMask, xK_m ), windows W.focusMaster)
 
 
    -- swapping
    -- 移动交换分区
    , ((modMask , xK_Return), windows W.swapMaster)
    , ((modMask .|. shiftMask, xK_j ), windows W.swapDown )
    , ((modMask .|. shiftMask, xK_k ), windows W.swapUp )
 
    -- increase or decrease number of windows in the master area
    -- 增加主分区的尺寸
    , ((modMask , xK_comma ), sendMessage (IncMasterN 1))
    , ((modMask , xK_period), sendMessage (IncMasterN (-1)))
 
    -- resizing
    -- 改变当前分区的尺寸
    , ((modMask, xK_h ), sendMessage Shrink)
    , ((modMask, xK_l ), sendMessage Expand)
    , ((modMask .|. shiftMask, xK_h ), sendMessage MirrorShrink)
    , ((modMask .|. shiftMask, xK_l ), sendMessage MirrorExpand)
 
    -- 控制linux1g1g
    -- mod+ctrl+m  开始播放 linux1g1g
    -- 快捷键 mod+ctrl+n  播放下一首歌
    , ((modMask .|. controlMask, xK_n  ), spawn (nextmusic))
    , ((modMask .|. controlMask, xK_m  ), spawn "/home/bl/bin/music1g" )
    
    -- scratchpad
    -- mod+` 调出一个控制台,再次按键会取消
    , ((modMask , xK_grave), scratchpadSpawnAction defaultConfig  {terminal = myTerminal}) 
 
    --Programs
    --mod+shif+b 打开firfox窗口
    , ((modMask .|.  shiftMask, xK_b ), spawn "firefox")
    , ((modMask , xK_c ), spawn "/home/bl/bin/editconfig")
 
    -- volume control
    , ((0 , 0x1008ff13 ), spawn "amixer -q set Master 2dB+")
    , ((0 , 0x1008ff11 ), spawn "amixer -q set Master 2dB-")
    , ((0 , 0x1008ff12 ), spawn "amixer -q set Master toggle")
 
 
    -- quit, or restart
    , ((modMask .|. shiftMask, xK_q ), io (exitWith ExitSuccess))
    , ((modMask , xK_q ), restart "xmonad" True)
    ]
    ++
  -- mod-[1..9] %! Switch to workspace N
  -- mod-shift-[1..9] %! Move client to workspace N
    [((m .|. modMask, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++
    -- mod-[w,e] %! switch to twinview screen 1/2
    -- mod-shift-[w,e] %! move window to screen 1/2
    [((m .|. modMask, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_w, xK_e] [1,0]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]

