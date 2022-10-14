--
-- Built with,
--
--        ,gggg,
--       d8" "8I                         ,dPYb,
--       88  ,dP                         IP'`Yb
--    8888888P"                          I8  8I
--       88                              I8  8'
--       88        gg      gg    ,g,     I8 dPgg,
--  ,aa,_88        I8      8I   ,8'8,    I8dP" "8I
-- dP" "88P        I8,    ,8I  ,8'  Yb   I8P    I8
-- Yb,_,d88b,,_   ,d8b,  ,d8b,,8'_   8) ,d8     I8,
--  "Y8P"  "Y888888P'"Y88P"`Y8P' "YY8P8P88P     `Y8
--

---@diagnostic disable
local lush = require "lush"
local hsl = lush.hsl
local awesome = require "awesome.theme"

function fg_offset(colour, amount)
  if awesome.is_dark() then
    return colour.darken(amount)
  else
    return colour.lighten(amount)
  end
end

function bg_offset(colour, amount)
  if awesome.is_dark() then
    return colour.lighten(amount)
  else
    return colour.darken(amount)
  end
end

local fg_offset = fg_offset
local bg_offset = bg_offset

function good(colour)
  return colour.hue(115).saturate(30)
end

function bad(colour)
  return colour.hue(0).saturate(30)
end

function bad_soft(colour)
  return colour.hue(0).saturate(10)
end

function warn(colour)
  return colour.hue(30).saturate(30)
end

function neutral(colour)
  return colour.hue(59).saturate(30)
end

local get_hour = get_hour
local bg_colour = bg_colour
local fg_colour = fg_colour
local good = good
local bad = bad
local bad_soft = bad_soft
local warn = warn
local neutral = neutral
local base = base

local theme = lush(function()
  return {
    Black { fg = hsl(0, 0, 0) },
    White { fg = hsl(0, 0, 100) },
    Green { fg = hsl "#00ff00" },
    Blue { fg = hsl "#0000ff" },
    Red { fg = hsl "#ff0000" },

    Fore1 { fg = hsl(awesome.fg()) },
    Fore2 { fg = fg_offset(Fore1.fg, 10) },
    Fore3 { fg = fg_offset(Fore2.fg, 10) },
    Fore4 { fg = fg_offset(Fore3.fg, 10) },
    Fore5 { fg = fg_offset(Fore4.fg, 10) },
    Fore10 { fg = fg_offset(Fore4.fg, 50) },

    Back1 { bg = hsl(awesome.bg()) },
    Back2 { bg = bg_offset(Back1.bg, 3) },
    Back3 { bg = bg_offset(Back2.bg, 3) },
    Back4 { bg = bg_offset(Back3.bg, 3) },
    Back5 { bg = bg_offset(Back4.bg, 3) },

    Good { bg = good(Back3.bg), fg = good(Fore3.fg) },
    Error { bg = bad(Back3.bg), fg = bad(Fore3.fg) },
    Neutral { bg = neutral(Back3.bg), fg = neutral(Fore3.fg) },
    Warn { bg = warn(Back3.bg), fg = warn(Fore3.fg) },

    Palette1 { fg = hsl(awesome.palette()) },
    Palette2 { fg = hsl(awesome.palette(function(x)
      return awesome.rotate(x, -45)
    end)) },
    Palette3 { fg = hsl(awesome.palette(function(x)
      return awesome.rotate(x, 30)
    end)) },
    Palette4 { fg = hsl(awesome.palette(function(x)
      return awesome.rotate(x, -75)
    end)) },
    Palette5 { fg = hsl(awesome.palette(function(x)
      return awesome.rotate(x, 150)
    end)) },
    Palette6 { fg = hsl(awesome.palette(function(x)
      return awesome.rotate(x, 190)
    end)) },

    -- Highlighter { fg = hsl(awesome.fg()), bg = bg_offset(Palette3.fg, -50) },
    -- HighlighterSecondary { fg = hsl(awesome.fg()), bg = bg_offset(Palette5.fg, -50) },

    Bold { gui = "bold" },
    Italic { gui = "italic" },
    Strikethrough { gui = "strikethrough" },
    Undercurl { gui = "undercurl" },
    Underlined { gui = "underline" }, -- (preferred) text that stands out, HTML links

    Normal { fg = Fore1.fg, bg = Back1.bg }, -- normal text
    NormalFloat { fg = Normal.fg }, -- Normal text in floating windows.
    NormalNC { fg = Normal.fg }, -- normal text in non-current windows
    Comment { fg = Fore4.fg },
    ColorColumn { fg = Fore1.fg, bg = Back1.bg.hue(0).saturation(20).lighten(10) }, -- TODO used for the columns set with 'colorcolumn'
    -- Conceal      { }, -- placeholder characters substituted for concealed text (see 'conceallevel')
    -- Cursor       { }, -- character under the cursor
    -- lCursor      { }, -- the character under the cursor when |language-mapping| is used (see 'guicursor')
    -- CursorIM     { }, -- like Cursor, but used when in IME mode |CursorIM|
    CursorColumn { bg = Back2.bg }, -- Screen-column at the cursor, when 'cursorcolumn' is set.
    CursorLine { bg = Back4.bg }, -- Screen-line at the cursor, when 'cursorline' is set.  Low-priority if foreground (ctermfg OR guifg) is not set.
    Directory { fg = Palette5.fg }, -- directory names (and other special names in listings)
    DiffAdd { fg = Good.fg, bg = Good.bg }, -- diff mode: Added line |diff.txt|
    DiffChange { fg = Neutral.fg, bg = Neutral.bg }, -- diff mode: Changed line |diff.txt|
    DiffDelete { fg = Error.fg, bg = Error.bg }, -- diff mode: Deleted line |diff.txt|
    DiffText { fg = Warn.fg, bg = Warn.bg }, -- diff mode: Changed text within a changed line |diff.txt|
    EndOfBuffer { fg = Back1.bg, bg = Back1.bg }, -- filler lines (~) after the end of the buffer.   By default, this is highlighted like |hl-NonText|.
    -- TermCursor   { }, -- cursor in a focused terminal
    -- TermCursorNC { }, -- cursor in an unfocused terminal
    -- ErrorMsg     { }, -- error messages on the command line
    VertSplit { fg = Back5.bg, bg = Back1.bg }, -- the column separating vertically split windows
    Folded { fg = Fore2.fg, bg = Back2.bg }, -- line used for closed folds
    FoldColumn { fg = Fore4.fg, bg = Back2.bg }, -- 'foldcolumn'
    SignColumn { fg = Fore4.fg, bg = Back2.bg }, -- column where |signs| are displayed
    Substitute { fg = DiffAdd.fg, bg = DiffAdd.bg }, -- |:substitute| replacement text highlighting
    LineNr { fg = Fore4.fg, bg = Back2.bg }, -- Line number for ":number" and ":#" commands, and when 'number' or 'relativenumber' option is set.
    CursorLineNr { fg = Palette1.fg, bg = Back3.bg }, -- Like LineNr when 'cursorline' or 'relativenumber' is set for the cursor line.
    -- MatchParen   { fg = Palette2.fg }, -- The character under the cursor or just before it, if it is a paired bracket, and its match. |pi_paren.txt|
    -- ModeMsg      { }, -- 'showmode' message (e.g., "-- INSERT -- ")
    -- MsgArea      { }, -- Area for messages and cmdline
    -- MsgSeparator { }, -- Separator for scrolled messages, `msgsep` flag of 'display'
    -- MoreMsg      { }, -- |more-prompt|
    NonText {}, -- '@' at the end of the window, characters from 'showbreak' and other characters that do not really exist in the text (e.g., ">" displayed when a double-wide character doesn't fit at the end of the line). See also |hl-EndOfBuffer|.
    Pmenu { fg = Fore1.fg, bg = Back3.bg }, -- TODO blend Popup menu: normal item.
    PmenuSel { fg = Fore1.fg, bg = Back4.bg }, -- TODO blend Popup menu: selected item.
    PmenuSbar { fg = Pmenu.fg, bg = Pmenu.bg }, -- TODO blend Popup menu: scrollbar.
    PmenuThumb { fg = Pmenu.fg, bg = Pmenu.bg }, -- TODO blend Popup menu: Thumb of the scrollbar.
    -- Question     { }, -- |hit-enter| prompt and yes/no questions
    QuickFixLine { bg = CursorLine.bg }, -- Current |quickfix| item in the quickfix window. Combined with |hl-CursorLine| when the cursor is there.
    Search { bg = bg_offset(DiffChange.bg, 10) }, -- Last search pattern highlighting (see 'hlsearch').  Also used for similar items that need to stand out.
    IncSearch { Search }, -- 'incsearch' highlighting; also used for the text replaced with ":s///c"
    -- SpecialKey   { }, -- Unprintable characters: text displayed differently from what it really is.  But not 'listchars' whitespace. |hl-Whitespace| SpellBad  Word that is not recognized by the spellchecker. |spell| Combined with the highlighting used otherwise.  SpellCap  Word that should start with a capital. |spell| Combined with the highlighting used otherwise.  SpellLocal  Word that is recognized by the spellchecker as one that is used in another region. |spell| Combined with the highlighting used otherwise.
    -- SpellRare    { }, -- Word that is recognized by the spellchecker as one that is hardly ever used.  |spell| Combined with the highlighting used otherwise.
    -- StatusLine   { }, -- status line of current window
    -- StatusLineNC { }, -- status lines of not-current windows Note: if this is equal to "StatusLine" Vim will use "^^^" in the status line of the current window.
    TabLine { bg = Back3.bg }, -- tab pages line, not active tab page label
    TabLineFill { fg = Back4.bg }, -- tab pages line, where there are no labels
    TabLineSel { fg = Back1.bg, bg = Palette1.fg }, -- tab pages line, active tab page label
    Title { gui = "bold" }, -- titles for output from ":set all", ":autocmd" etc.
    Visual { bg = Back4.bg }, -- Visual mode selection
    -- VisualNOS    { }, -- Visual mode selection when vim is "Not Owning the Selection".
    WarningMsg { fg = Warn.fg, bg = Warn.bg }, -- warning messages
    Whitespace { bg = Back4.bg }, -- "nbsp", "space", "tab" and "trail" in 'listchars'
    -- WildMenu     { }, -- current match in 'wildmenu' completion

    -- These groups are not listed as default vim groups,
    -- but they are defacto standard group names for syntax highlighting.
    -- commented out groups should chain up to their "preferred" group by
    -- default,
    -- Uncomment and edit if you want more specific syntax highlighting.

    Constant { fg = Palette2.fg, gui = Bold.gui }, -- (preferred) any constant
    -- Character      { }, --  a character constant: 'c', '\n'
    -- Number         { }, --   a number constant: 234, 0xff
    -- Boolean        { }, --  a boolean constant: TRUE, false
    -- Float          { }, --    a floating point constant: 2.3e10

    Keyword { fg = Palette2.fg, gui = Bold.gui }, --  any other keyword

    Identifier { fg = Fore2.fg }, -- (preferred) any variable name

    -- Function { fg = Palette1.fg }, -- function name (also: methods for classes)

    Operator { fg = Palette5.fg }, -- "sizeof", "+", "*", etc.

    PreProc { fg = Palette4.fg }, -- (preferred) generic Preprocessor
    -- Include        { }, --  preprocessor #include
    -- Define         { }, --   preprocessor #define
    -- Macro          { }, --    same as Define
    -- PreCondit      { }, --  preprocessor #if, #else, #endif, etc.

    Statement { fg = Palette2.fg }, -- (preferred) any statement
    -- Conditional    { }, --  if, then, else, endif, switch, etc.
    -- Repeat         { }, --   for, do, while, etc.
    -- Label          { }, --    case, default, etc.
    -- Exception      { }, --  try, catch, throw

    String { fg = Palette3.fg }, --   a string constant: "this is a string"

    Type {}, -- (preferred) int, long, char, etc.
    -- StorageClass   { }, -- static, register, volatile, etc.
    -- Structure      { }, --  struct, union, enum, etc.
    -- Typedef        { }, --  A typedef

    Special {}, -- Disabled.
    -- SpecialChar    { }, --  special character in a constant
    -- Tag            { }, --    you can use CTRL-] on this
    -- Debug          { }, --    debugging statements

    Delimiter { fg = Fore2.fg }, --  character that needs attention
    SpecialComment { fg = Fore3.fg }, -- special things inside a comment

    -- These groups are for the native LSP client. Some other LSP clients may use
    -- these groups, or use their own. Consult your LSP client's documentation.
    DiagnosticSignError { fg = Error.fg, bg = Back2.bg },
    DiagnosticSignWarn { fg = Warn.fg, bg = Back2.bg },
    DiagnosticSignInfo { fg = Neutral.fg, bg = Back2.bg },
    DiagnosticSignHint { fg = Neutral.fg, bg = Back2.bg },
    DiagnosticUnderlineError { sp = Error.fg, gui = Undercurl.gui },
    DiagnosticUnderlineWarn { sp = Warn.fg, gui = Undercurl.gui },
    DiagnosticUnderlineInfo { sp = Neutral.fg, gui = Undercurl.gui },
    DiagnosticUnderlineHint { sp = Neutral.fg, gui = Undercurl.gui },
    DiagnosticVirtualTextError { fg = Error.fg },
    DiagnosticVirtualTextWarn { fg = Warn.fg },
    DiagnosticVirtualTextInfo { fg = Neutral.fg },
    DiagnosticVirtualTextHint { fg = Neutral.fg },

    TODO {},

    -- Custom for linehl if you want to customise the LSP sign for that
    -- TODO: Sample.
    TodoBgTODO { fg = Back1.bg, bg = Palette5.fg, gui = Bold.gui },
    TodoFgTODO { fg = Palette5.fg },
    TodoSignTODO { fg = Palette5.fg, bg = Back2.bg },

    -- FIX: Sample.
    TodoBgFIX { fg = Back1.bg, bg = Palette4.fg, gui = Bold.gui },
    TodoFgFIX { fg = Palette4.fg },
    TodoSignFIX { fg = Palette4.fg, bg = Back2.bg },

    -- WARN: Sample.
    TodoBgWARN { fg = Back1.bg, bg = Palette2.fg, gui = Bold.gui },
    TodoFgWARN { fg = Palette2.fg },
    TodoSignWARN { fg = Palette2.fg, bg = Back2.bg },

    -- HACK: Sample.
    TodoBgHACK { fg = Back1.bg, bg = Palette2.fg, gui = Bold.gui },
    TodoFgHACK { fg = Palette2.fg },
    TodoSignHACK { fg = Palette2.fg, bg = Back2.bg },

    -- PERF: Sample.
    TodoBgPERF { fg = Back1.bg, bg = Neutral.fg, gui = Bold.gui },
    TodoFgPERF { fg = Neutral.fg },
    TodoSignPERF { fg = Neutral.fg, bg = Back2.bg },

    -- NOTE: Sample.
    TodoBgNOTE { fg = Back1.bg, bg = Palette6.fg, gui = Bold.gui },
    TodoFgNOTE { fg = Palette6.fg },
    TodoSignNOTE { fg = Palette6.fg, bg = Back2.bg },

    -- Treesitter
    -- TSAnnotation         { }, -- For C++/Dart attributes, annotations that can be attached to the code to denote some kind of meta information.
    -- TSBoolean            { }, -- For booleans.
    -- TSCharacter          { }, -- For characters.
    TSConditional { Keyword },
    -- TSConstBuiltin       { }, -- For constant that are built in the language: `nil` in Lua.
    -- TSConstMacro         { }, -- For constants that are defined by macros: `NULL` in C.
    TSConstant {},
    -- TSConstructor        { }, -- For constructor calls and definitions: `{ }` in Lua, and Java constructors.
    -- TSDanger             { },
    -- TSEmphasis           { }, -- For text to be represented with emphasis.
    -- TSError              { }, -- For syntax/parser errors.
    -- TSException          { }, -- For exception related keywords.
    TSField { fg = Palette6.fg },
    -- TSFloat              { }, -- For floats.
    -- TSFuncBuiltin        { }, -- For builtin functions: `table.insert` in Lua.
    -- TSFuncMacro          { }, -- For macro defined functions (calls and definitions): each `macro_rules` in Rust.
    -- TSFunction           { }, -- For function (calls and definitions).
    -- TSInclude            { }, -- For includes: `#include` in C, `use` or `extern crate` in Rust, or `require` in Lua.
    -- TSKeyword            { }, -- For keywords that don't fall in previous categories.
    -- TSKeywordFunction    { }, -- For keywords used to define a function.
    -- TSLabel              { }, -- For labels: `label:` in C and `:label:` in Lua.
    -- TSLiteral            { }, -- Literal text.
    -- TSMethod             { }, -- For method calls and definitions.
    TSNamespace {},
    -- TSNote               { },
    TSNumber { fg = Palette5.fg },
    -- TSOperator           { }, -- For any operator: `+`, but also `->` and `*` in C.
    -- TSParameter          { }, -- For parameters of a function.
    -- TSParameterReference { }, -- For references to parameters of a function.
    TSPlaygroundFocus { Search },
    TSProperty { TSField },
    -- TSPunctBracket       { }, -- For brackets and parens.
    -- TSPunctDelimiter     { }, -- For delimiters ie: `.`
    -- TSPunctSpecial       { }, -- For special punctutation that does not fall in the categories before.
    TSRepeat { Keyword },
    -- TSString             { }, -- For strings.
    -- TSStringEscape       { }, -- For escape characters within a string.
    -- TSStringRegex        { }, -- For regexes.
    -- TSStrong             { }, -- For text to be represented with strong.
    -- TSText               { }, -- For strings considered text in a markup language.
    -- TSTitle              { }, -- Text that is part of a title.
    -- TSType               { }, -- For types.
    -- TSTypeBuiltin        { }, -- For builtin types (you guessed it, right ?).
    -- TSURI                { }, -- Any URI like a link or email.
    -- TSUnderline          { }, -- For text to be represented with an underline.
    -- TSVariable           { }, -- Any variable name that does not have another highlight.
    -- TSVariableBuiltin    { }, -- Variable names that are defined by the languages, like `this` or `self`.
    -- TSWarning            { },

    -- Gitsigns
    GitSignsAdd { fg = DiffAdd.fg, bg = Back2.bg, sp = "none" },
    GitSignsChange { fg = DiffChange.fg, bg = Back2.bg, sp = "none" },
    GitSignsChangeDelete { fg = DiffChange.fg, bg = Back2.bg, sp = "none" },
    GitSignsDelete { fg = DiffDelete.fg, bg = Back2.bg, sp = "none" },

    -- Indent-blankline
    IndentBlanklineChar { fg = Fore10.fg, gui = "nocombine" },

    -- Leap
    LeapMatch { fg = Search.bg, gui = Underlined.gui },
    LeapLabelPrimary { Search },
    LeapLabelSecondary { fg = bg_offset(LeapMatch.fg, 30) },

    -- Lir
    LirTransparentCursor { blend = 100, gui = Strikethrough.gui },
    LitGitStatusBracket { Comment },
    LirGitStatusIndex { bg = Back1.bg, fg = DiffChange.fg },
    LirGitStatusWorktree { bg = Back1.bg, fg = DiffChange.fg },
    -- LirGitStatusUnmerged { },
    -- LirGitStatusUntracked { },
    -- LirGitStatusIgnored { },

    -- Devicons
    -- TODO: Use the palette for these.
    DevIconAi { fg = "#cbcb41" }, -- DevIconAi      xxx guifg=#cbcb41
    DevIconAwk { fg = "#4d5a5e" }, -- DevIconAwk     xxx guifg=#4d5a5e
    DevIconBabelrc { fg = "#cbcb41" }, -- DevIconBabelrc xxx guifg=#cbcb41
    DevIconBash { fg = "#89e051" }, -- DevIconBash    xxx guifg=#89e051
    DevIconBashProfile { fg = "#89e051" }, -- DevIconBashProfile xxx guifg=#89e051
    DevIconBashrc { fg = "#89e051" }, -- DevIconBashrc  xxx guifg=#89e051
    DevIconBat { fg = "#c1f12e" }, -- DevIconBat     xxx guifg=#C1F12E
    DevIconBinaryGLTF { fg = "#ffb13b" }, -- DevIconBinaryGLTF xxx guifg=#FFB13B
    DevIconBmp { fg = "#a074c4" }, -- DevIconBmp     xxx guifg=#a074c4
    DevIconBrewfile { fg = "#701516" }, -- DevIconBrewfile xxx guifg=#701516
    DevIconC { fg = "#599eff" }, -- DevIconC       xxx guifg=#599eff
    DevIconCMake { fg = "#6d8086" }, -- DevIconCMake   xxx guifg=#6d8086
    DevIconCMakeLists { fg = "#6d8086" }, -- DevIconCMakeLists xxx guifg=#6d8086
    DevIconCPlusPlus { fg = "#f34b7d" }, -- DevIconCPlusPlus xxx guifg=#f34b7d
    DevIconClojure { fg = "#8dc149" }, -- DevIconClojure xxx guifg=#8dc149
    DevIconClojureC { fg = "#8dc149" }, -- DevIconClojureC xxx guifg=#8dc149
    DevIconClojureJS { fg = "#519aba" }, -- DevIconClojureJS xxx guifg=#519aba
    DevIconCobol { fg = "#005ca5" }, -- DevIconCobol   xxx guifg=#005ca5
    DevIconCoffee { fg = "#cbcb41" }, -- DevIconCoffee  xxx guifg=#cbcb41
    DevIconConf { fg = "#6d8086" }, -- DevIconConf    xxx guifg=#6d8086
    DevIconConfigRu { fg = "#701516" }, -- DevIconConfigRu xxx guifg=#701516
    DevIconConfiguration { fg = "#ececec" }, -- DevIconConfiguration xxx guifg=#ECECEC
    DevIconCp { fg = "#519aba" }, -- DevIconCp      xxx guifg=#519aba
    DevIconCpp { fg = hsl "#519aba" },
    DevIconCrystal { fg = "#000000" }, -- DevIconCrystal xxx guifg=#000000
    DevIconCs { fg = "#596706" }, -- DevIconCs      xxx guifg=#596706
    DevIconCsh { fg = "#4d5a5e" }, -- DevIconCsh     xxx guifg=#4d5a5e
    DevIconCson { fg = "#cbcb41" }, -- DevIconCson    xxx guifg=#cbcb41
    DevIconCss { fg = "#563d7c" }, -- DevIconCss     xxx guifg=#563d7c
    DevIconCxx { fg = "#519aba" }, -- DevIconCxx     xxx guifg=#519aba
    DevIconD { fg = "#427819" }, -- DevIconD       xxx guifg=#427819
    DevIconDart { fg = "#03589c" }, -- DevIconDart    xxx guifg=#03589C
    DevIconDb { fg = "#dad8d8" }, -- DevIconDb      xxx guifg=#dad8d8
    DevIconDefault { fg = "#6d8086" }, -- DevIconDefault xxx guifg=#6d8086
    DevIconDesktopEntry { fg = "#563d7c" }, -- DevIconDesktopEntry xxx guifg=#563d7c
    DevIconDiff { fg = "#41535b" }, -- DevIconDiff    xxx guifg=#41535b
    DevIconDoc { fg = "#185abd" }, -- DevIconDoc     xxx guifg=#185abd
    DevIconDockerfile { fg = "#384d54" }, -- DevIconDockerfile xxx guifg=#384d54
    DevIconDropbox { fg = "#0061fe" }, -- DevIconDropbox xxx guifg=#0061FE
    DevIconDsStore { fg = "#41535b" }, -- DevIconDsStore xxx guifg=#41535b
    DevIconDump { fg = "#dad8d8" }, -- DevIconDump    xxx guifg=#dad8d8
    DevIconEdn { fg = "#519aba" }, -- DevIconEdn     xxx guifg=#519aba
    DevIconEex { fg = "#a074c4" }, -- DevIconEex     xxx guifg=#a074c4
    DevIconEjs { fg = "#cbcb41" }, -- DevIconEjs     xxx guifg=#cbcb41
    DevIconElm { fg = "#519aba" }, -- DevIconElm     xxx guifg=#519aba
    DevIconErb { fg = "#701516" }, -- DevIconErb     xxx guifg=#701516
    DevIconErl { fg = "#b83998" }, -- DevIconErl     xxx guifg=#B83998
    DevIconEx { fg = "#a074c4" }, -- DevIconEx      xxx guifg=#a074c4
    DevIconExs { fg = "#a074c4" }, -- DevIconExs     xxx guifg=#a074c4
    DevIconFavicon { fg = "#cbcb41" }, -- DevIconFavicon xxx guifg=#cbcb41
    DevIconFish { fg = "#4d5a5e" }, -- DevIconFish    xxx guifg=#4d5a5e
    DevIconFs { fg = "#519aba" }, -- DevIconFs      xxx guifg=#519aba
    DevIconFsharp { fg = "#519aba" }, -- DevIconFsharp  xxx guifg=#519aba
    DevIconFsi { fg = "#519aba" }, -- DevIconFsi     xxx guifg=#519aba
    DevIconFsscript { fg = "#519aba" }, -- DevIconFsscript xxx guifg=#519aba
    DevIconFsx { fg = "#519aba" }, -- DevIconFsx     xxx guifg=#519aba
    DevIconGDScript { fg = "#6d8086" }, -- DevIconGDScript xxx guifg=#6d8086
    DevIconGemfile { fg = "#701516" }, -- DevIconGemfile xxx guifg=#701516
    DevIconGemspec { fg = "#701516" }, -- DevIconGemspec xxx guifg=#701516
    DevIconGif { fg = "#a074c4" }, -- DevIconGif     xxx guifg=#a074c4
    DevIconGitAttributes { fg = "#41535b" }, -- DevIconGitAttributes xxx guifg=#41535b
    DevIconGitCommit { fg = "#41535b" }, -- DevIconGitCommit xxx guifg=#41535b
    DevIconGitConfig { fg = "#41535b" }, -- DevIconGitConfig xxx guifg=#41535b
    DevIconGitIgnore { fg = "#41535b" }, -- DevIconGitIgnore xxx guifg=#41535b
    DevIconGitLogo { fg = "#f14c28" }, -- DevIconGitLogo xxx guifg=#F14C28
    DevIconGitModules { fg = "#41535b" }, -- DevIconGitModules xxx guifg=#41535b
    DevIconGitlabCI { fg = "#e24329" }, -- DevIconGitlabCI xxx guifg=#e24329
    DevIconGo { fg = "#519aba" }, -- DevIconGo      xxx guifg=#519aba
    DevIconGodotProject { fg = "#6d8086" }, -- DevIconGodotProject xxx guifg=#6d8086
    DevIconGruntfile { fg = "#e37933" }, -- DevIconGruntfile xxx guifg=#e37933
    DevIconGulpfile { fg = "#cc3e44" }, -- DevIconGulpfile xxx guifg=#cc3e44
    DevIconGvimrc { fg = "#019833" }, -- DevIconGvimrc  xxx guifg=#019833
    DevIconH { fg = "#a074c4" }, -- DevIconH       xxx guifg=#a074c4
    DevIconHaml { fg = "#eaeae1" }, -- DevIconHaml    xxx guifg=#eaeae1
    DevIconHbs { fg = "#f0772b" }, -- DevIconHbs     xxx guifg=#f0772b
    DevIconHeex { fg = "#a074c4" }, -- DevIconHeex    xxx guifg=#a074c4
    DevIconHh { fg = "#a074c4" }, -- DevIconHh      xxx guifg=#a074c4
    DevIconHpp { fg = "#a074c4" }, -- DevIconHpp     xxx guifg=#a074c4
    DevIconHrl { fg = "#b83998" }, -- DevIconHrl     xxx guifg=#B83998
    DevIconHs { fg = "#a074c4" }, -- DevIconHs      xxx guifg=#a074c4
    DevIconHtm { fg = "#e34c26" }, -- DevIconHtm     xxx guifg=#e34c26
    DevIconHtml { fg = "#e34c26" }, -- DevIconHtml    xxx guifg=#e34c26
    DevIconHxx { fg = "#a074c4" }, -- DevIconHxx     xxx guifg=#a074c4
    DevIconIco { fg = "#cbcb41" }, -- DevIconIco     xxx guifg=#cbcb41
    DevIconImportConfiguration { fg = "#ececec" }, -- DevIconImportConfiguration xxx guifg=#ECECEC
    DevIconIni { fg = "#6d8086" }, -- DevIconIni     xxx guifg=#6d8086
    DevIconJava { fg = "#cc3e44" }, -- DevIconJava    xxx guifg=#cc3e44
    DevIconJl { fg = "#a270ba" }, -- DevIconJl      xxx guifg=#a270ba
    DevIconJpeg { fg = "#a074c4" }, -- DevIconJpeg    xxx guifg=#a074c4
    DevIconJpg { fg = "#a074c4" }, -- DevIconJpg     xxx guifg=#a074c4
    DevIconJs { fg = "#cbcb41" }, -- DevIconJs      xxx guifg=#cbcb41
    DevIconJson { fg = "#cbcb41" }, -- DevIconJson    xxx guifg=#cbcb41
    DevIconJsx { fg = "#519aba" }, -- DevIconJsx     xxx guifg=#519aba
    DevIconKotlin { fg = "#f88a02" }, -- DevIconKotlin  xxx guifg=#F88A02
    DevIconKsh { fg = "#4d5a5e" }, -- DevIconKsh     xxx guifg=#4d5a5e
    DevIconLeex { fg = "#a074c4" }, -- DevIconLeex    xxx guifg=#a074c4
    DevIconLess { fg = "#563d7c" }, -- DevIconLess    xxx guifg=#563d7c
    DevIconLhs { fg = "#a074c4" }, -- DevIconLhs     xxx guifg=#a074c4
    DevIconLicense { fg = "#cbcb41" }, -- DevIconLicense xxx guifg=#cbcb41
    DevIconLirFolderNode { fg = "#7ebae4" }, -- DevIconLirFolderNode xxx guifg=#7ebae4
    DevIconLua { fg = hsl "#51a0cf" },
    DevIconMakefile { fg = "#6d8086" }, -- DevIconMakefile xxx guifg=#6d8086
    DevIconMarkdown { fg = "#519aba" }, -- DevIconMarkdown xxx guifg=#519aba
    DevIconMaterial { fg = "#b83998" }, -- DevIconMaterial xxx guifg=#B83998
    DevIconMd { fg = "#519aba" }, -- DevIconMd      xxx guifg=#519aba
    DevIconMdx { fg = "#519aba" }, -- DevIconMdx     xxx guifg=#519aba
    DevIconMint { fg = "#87c095" }, -- DevIconMint    xxx guifg=#87c095
    DevIconMixLock { fg = "#a074c4" }, -- DevIconMixLock xxx guifg=#a074c4
    DevIconMjs { fg = "#f1e05a" }, -- DevIconMjs     xxx guifg=#f1e05a
    DevIconMl { fg = "#e37933" }, -- DevIconMl      xxx guifg=#e37933
    DevIconMli { fg = "#e37933" }, -- DevIconMli     xxx guifg=#e37933
    DevIconMustache { fg = "#e37933" }, -- DevIconMustache xxx guifg=#e37933
    DevIconNPMIgnore { fg = "#e8274b" }, -- DevIconNPMIgnore xxx guifg=#E8274B
    DevIconNix { fg = hsl "#7ebae4" },
    DevIconNodeModules { fg = "#e8274b" }, -- DevIconNodeModules xxx guifg=#E8274B
    DevIconOPUS { fg = "#f88a02" }, -- DevIconOPUS    xxx guifg=#F88A02
    DevIconOpenTypeFont { fg = "#ececec" }, -- DevIconOpenTypeFont xxx guifg=#ECECEC
    DevIconPackedResource { fg = "#6d8086" }, -- DevIconPackedResource xxx guifg=#6d8086
    DevIconPdf { fg = "#b30b00" }, -- DevIconPdf     xxx guifg=#b30b00
    DevIconPhp { fg = "#a074c4" }, -- DevIconPhp     xxx guifg=#a074c4
    DevIconPl { fg = "#519aba" }, -- DevIconPl      xxx guifg=#519aba
    DevIconPm { fg = "#519aba" }, -- DevIconPm      xxx guifg=#519aba
    DevIconPng { fg = "#a074c4" }, -- DevIconPng     xxx guifg=#a074c4
    DevIconPp { fg = "#302b6d" }, -- DevIconPp      xxx guifg=#302B6D
    DevIconPpt { fg = "#cb4a32" }, -- DevIconPpt     xxx guifg=#cb4a32
    DevIconProcfile { fg = "#a074c4" }, -- DevIconProcfile xxx guifg=#a074c4
    DevIconProlog { fg = "#e4b854" }, -- DevIconProlog  xxx guifg=#e4b854
    DevIconPromptPs1 { fg = "#4d5a5e" }, -- DevIconPromptPs1 xxx guifg=#4d5a5e
    DevIconPsb { fg = "#519aba" }, -- DevIconPsb     xxx guifg=#519aba
    DevIconPsd { fg = "#519aba" }, -- DevIconPsd     xxx guifg=#519aba
    DevIconPy { fg = "#3572a5" }, -- DevIconPy      xxx guifg=#3572A5
    DevIconPyc { fg = "#519aba" }, -- DevIconPyc     xxx guifg=#519aba
    DevIconPyd { fg = "#519aba" }, -- DevIconPyd     xxx guifg=#519aba
    DevIconPyo { fg = "#519aba" }, -- DevIconPyo     xxx guifg=#519aba
    DevIconR { fg = "#358a5b" }, -- DevIconR       xxx guifg=#358a5b
    DevIconRake { fg = "#701516" }, -- DevIconRake    xxx guifg=#701516
    DevIconRakefile { fg = "#701516" }, -- DevIconRakefile xxx guifg=#701516
    DevIconRb { fg = "#701516" }, -- DevIconRb      xxx guifg=#701516
    DevIconRlib { fg = "#dea584" }, -- DevIconRlib    xxx guifg=#dea584
    DevIconRmd { fg = "#519aba" }, -- DevIconRmd     xxx guifg=#519aba
    DevIconRproj { fg = "#358a5b" }, -- DevIconRproj   xxx guifg=#358a5b
    DevIconRs { fg = "#dea584" }, -- DevIconRs      xxx guifg=#dea584
    DevIconRss { fg = "#fb9d3b" }, -- DevIconRss     xxx guifg=#FB9D3B
    DevIconSass { fg = "#f55385" }, -- DevIconSass    xxx guifg=#f55385
    DevIconScala { fg = "#cc3e44" }, -- DevIconScala   xxx guifg=#cc3e44
    DevIconScss { fg = "#f55385" }, -- DevIconScss    xxx guifg=#f55385
    DevIconSettingsJson { fg = "#854cc7" }, -- DevIconSettingsJson xxx guifg=#854CC7
    DevIconSh { fg = "#4d5a5e" }, -- DevIconSh      xxx guifg=#4d5a5e
    DevIconSig { fg = "#e37933" }, -- DevIconSig     xxx guifg=#e37933
    DevIconSlim { fg = "#e34c26" }, -- DevIconSlim    xxx guifg=#e34c26
    DevIconSln { fg = "#854cc7" }, -- DevIconSln     xxx guifg=#854CC7
    DevIconSml { fg = "#e37933" }, -- DevIconSml     xxx guifg=#e37933
    DevIconSql { fg = "#dad8d8" }, -- DevIconSql     xxx guifg=#dad8d8
    DevIconStyl { fg = "#8dc149" }, -- DevIconStyl    xxx guifg=#8dc149
    DevIconSuo { fg = "#854cc7" }, -- DevIconSuo     xxx guifg=#854CC7
    DevIconSvelte { fg = "#ff3e00" }, -- DevIconSvelte  xxx guifg=#ff3e00
    DevIconSvg { fg = "#ffb13b" }, -- DevIconSvg     xxx guifg=#FFB13B
    DevIconSwift { fg = "#e37933" }, -- DevIconSwift   xxx guifg=#e37933
    DevIconTerminal { fg = "#31b53e" }, -- DevIconTerminal xxx guifg=#31B53E
    DevIconTex { fg = "#3d6117" }, -- DevIconTex     xxx guifg=#3D6117
    DevIconTextResource { fg = "#cbcb41" }, -- DevIconTextResource xxx guifg=#cbcb41
    DevIconTextScene { fg = "#a074c4" }, -- DevIconTextScene xxx guifg=#a074c4
    DevIconToml { fg = "#6d8086" }, -- DevIconToml    xxx guifg=#6d8086
    DevIconTor { fg = "#519aba" }, -- DevIconTor     xxx guifg=#519aba
    DevIconTs { fg = "#519aba" }, -- DevIconTs      xxx guifg=#519aba
    DevIconTsx { fg = "#519aba" }, -- DevIconTsx     xxx guifg=#519aba
    DevIconTwig { fg = "#8dc149" }, -- DevIconTwig    xxx guifg=#8dc149
    DevIconTxt { fg = "#89e051" }, -- DevIconTxt     xxx guifg=#89e051
    DevIconVagrantfile { fg = "#1563ff" }, -- DevIconVagrantfile xxx guifg=#1563FF
    DevIconVim { fg = hsl "#019833" },
    DevIconVimrc { fg = "#019833" }, -- DevIconVimrc   xxx guifg=#019833
    DevIconVue { fg = "#8dc149" }, -- DevIconVue     xxx guifg=#8dc149
    DevIconWebmanifest { fg = "#f1e05a" }, -- DevIconWebmanifest xxx guifg=#f1e05a
    DevIconWebp { fg = "#a074c4" }, -- DevIconWebp    xxx guifg=#a074c4
    DevIconWebpack { fg = "#519aba" }, -- DevIconWebpack xxx guifg=#519aba
    DevIconXcPlayground { fg = "#e37933" }, -- DevIconXcPlayground xxx guifg=#e37933
    DevIconXls { fg = "#207245" }, -- DevIconXls     xxx guifg=#207245
    DevIconXml { fg = "#e37933" }, -- DevIconXml     xxx guifg=#e37933
    DevIconXul { fg = "#e37933" }, -- DevIconXul     xxx guifg=#e37933
    DevIconYaml { fg = "#6d8086" }, -- DevIconYaml    xxx guifg=#6d8086
    DevIconYml { fg = "#6d8086" }, -- DevIconYml     xxx guifg=#6d8086
    DevIconZig { fg = hsl "#f69a1b" },
    DevIconZsh { fg = hsl "#89e051" },
    DevIconZshenv { fg = "#89e051" }, -- DevIconZshenv  xxx guifg=#89e051
    DevIconZshprofile { fg = "#89e051" }, -- DevIconZshprofile xxx guifg=#89e051
    DevIconZshrc { fg = "#89e051" }, -- DevIconZshrc   xxx guifg=#89e051

    -- Xit
    XitHeadline { Underlined },
    XitOpenCheckbox {},
    XitOpenTaskMainLine {},
    XitOpenTaskOtherLine {},
    XitOpenTaskPriority { Palette4 },
    XitOngoingCheckbox { Palette3 },
    XitOngoingTaskMainLine { XitOngoingCheckbox },
    XitOngoingTaskOtherLine { XitOngoingCheckbox },
    XitOngoingTaskPriority { XitOpenTaskPriority },
    XitCheckedCheckbox { Comment },
    XitCheckedTaskMainLine { Comment },
    XitCheckedTaskOtherLine { Comment },
    XitCheckedTaskPriority { Comment },
    XitObsoleteCheckbox { Comment },
    XitObsoleteTaskMainLine { Comment, gui = Strikethrough.gui },
    XitObsoleteTaskOtherLine { Comment, gui = Strikethrough.gui },
    XitObsoleteTaskPriority { Comment, gui = Strikethrough.gui },
  }
end)

return theme
