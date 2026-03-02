/* NilWM config.h — OXWM-compatible configuration for DWM
 * Color scheme: Tokyo Night (matching OXWM defaults)
 * Keybindings: matched to OXWM defaults where possible
 */

/* appearance */
static const unsigned int borderpx  = 2;        /* border pixel of windows (OXWM default) */
static const unsigned int snap      = 32;       /* snap pixel */
static const int showbar            = 1;        /* 0 means no bar */
static const int topbar             = 1;        /* 0 means bottom bar */
static const char *fonts[]          = { "monospace:style=Bold:size=10" };
static const char dmenufont[]       = "monospace:style=Bold:size=10";

/* gaps (OXWM defaults: inner 5/5, outer 5/5, smartgaps on) */
static const int gappih             = 5;        /* horiz inner gap between windows */
static const int gappiv             = 5;        /* vert inner gap between windows */
static const int gappoh             = 5;        /* horiz outer gap between windows and screen edge */
static const int gappov             = 5;        /* vert outer gap between windows and screen edge */
static const int smartgaps          = 1;        /* 1 means no gaps with only one window */

/* Tokyo Night color palette (matching OXWM) */
static const char col_bg[]          = "#1a1b26";
static const char col_fg[]          = "#bbbbbb";
static const char col_gray[]        = "#444444";
static const char col_cyan[]        = "#0db9d7";
static const char col_blue[]        = "#6dade3";
static const char col_purple[]      = "#ad8ee6";
static const char *colors[][3]      = {
	/*                fg        bg        border   */
	[SchemeNorm]  = { col_fg,   col_bg,   col_fg },    /* unfocused: border=#bbbbbb */
	[SchemeSel]   = { col_cyan, col_bg,   col_blue },  /* focused:   border=#6dade3 */
};

/* tagging — 9 tags (OXWM default) */
static const char *tags[] = { "1", "2", "3", "4", "5", "6", "7", "8", "9" };

/* window rules (OXWM-style: class/instance/title matching) */
static const Rule rules[] = {
	/* xprop(1):
	 *	WM_CLASS(STRING) = instance, class
	 *	WM_NAME(STRING) = title
	 */
	/* class      instance    title       tags mask     isfloating   monitor */
	{ "Gimp",     NULL,       NULL,       0,            1,           -1 },
	{ "mpv",      NULL,       NULL,       0,            1,           -1 },
	{ "Spotify",  NULL,       NULL,       1 << 8,       0,           -1 },
	{ "discord",  NULL,       NULL,       1 << 7,       0,           -1 },
};

/* layout(s) — matching OXWM layout set */
static const float mfact     = 0.55; /* factor of master area size [0.05..0.95] */
static const int nmaster     = 1;    /* number of clients in master area */
static const int resizehints = 0;    /* 0 = disable size hints (cleaner tiling) */
static const int lockfullscreen = 1; /* 1 will force focus on the fullscreen window */

static const Layout layouts[] = {
	/* symbol     arrange function */
	{ "[T]",      tile },      /* tiling (master/stack) — OXWM default */
	{ "[F]",      NULL },      /* normie (floating) */
	{ "[M]",      monocle },   /* monocle (fullscreen stacking) */
	{ "[G]",      grid },      /* grid (equal-sized grid) */
	{ NULL,       NULL },      /* terminator for cyclelayout */
};

/* key definitions — Mod4 = Super key (OXWM default) */
#define MODKEY Mod4Mask
#define TAGKEYS(KEY,TAG) \
	{ MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
	{ MODKEY|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },

/* helper for spawning shell commands */
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

/* commands */
static char dmenumon[2] = "0"; /* component of dmenucmd, manipulated in spawn() */
static const char *dmenucmd[] = { "dmenu_run", "-m", dmenumon, "-fn", dmenufont, "-nb", col_bg, "-nf", col_fg, "-sb", col_bg, "-sf", col_cyan, NULL };
static const char *termcmd[]  = { "st", NULL };

static const Key keys[] = {
	/* modifier                     key        function        argument */

	/* === Window Management (OXWM-matching) === */
	{ MODKEY,                       XK_Return, spawn,          {.v = termcmd } },     /* Super+Return: spawn terminal */
	{ MODKEY,                       XK_d,      spawn,          {.v = dmenucmd } },    /* Super+D: launcher (dmenu) */
	{ MODKEY,                       XK_q,      killclient,     {0} },                 /* Super+Q: kill window */
	{ MODKEY|ShiftMask,             XK_q,      quit,           {0} },                 /* Super+Shift+Q: quit WM */
	{ MODKEY|ShiftMask,             XK_r,      self_restart,   {0} },                 /* Super+Shift+R: restart WM */

	/* === Focus & Stack (OXWM-matching) === */
	{ MODKEY,                       XK_j,      focusstack,     {.i = +1 } },          /* Super+J: focus next */
	{ MODKEY,                       XK_k,      focusstack,     {.i = -1 } },          /* Super+K: focus prev */
	{ MODKEY|ShiftMask,             XK_j,      movestack,      {.i = +1 } },          /* Super+Shift+J: move down */
	{ MODKEY|ShiftMask,             XK_k,      movestack,      {.i = -1 } },          /* Super+Shift+K: move up */
	{ MODKEY,                       XK_Tab,    view,           {0} },                 /* Super+Tab: toggle last tag */
	{ MODKEY,                       XK_Return, zoom,           {0} },                 /* Super+Return: swap master (when window focused) */

	/* === Fullscreen & Floating (OXWM-matching) === */
	{ MODKEY|ShiftMask,             XK_f,      togglefullscr,  {0} },                 /* Super+Shift+F: toggle fullscreen */
	{ MODKEY|ShiftMask,             XK_space,  togglefloating, {0} },                 /* Super+Shift+Space: toggle floating */

	/* === Layouts (OXWM-matching) === */
	{ MODKEY,                       XK_c,      setlayout,      {.v = &layouts[0]} },  /* Super+C: tiling */
	{ MODKEY,                       XK_f,      setlayout,      {.v = &layouts[1]} },  /* Super+F: normie (float) */
	{ MODKEY,                       XK_m,      setlayout,      {.v = &layouts[2]} },  /* Super+M: monocle */
	{ MODKEY,                       XK_g,      setlayout,      {.v = &layouts[3]} },  /* Super+G: grid */
	{ MODKEY,                       XK_n,      cyclelayout,    {.i = +1 } },          /* Super+N: cycle layout */

	/* === Master Area (OXWM-matching) === */
	{ MODKEY,                       XK_h,      setmfact,       {.f = -0.05} },        /* Super+H: shrink master */
	{ MODKEY,                       XK_l,      setmfact,       {.f = +0.05} },        /* Super+L: grow master */
	{ MODKEY,                       XK_i,      incnmaster,     {.i = +1 } },          /* Super+I: inc nmaster */
	{ MODKEY,                       XK_p,      incnmaster,     {.i = -1 } },          /* Super+P: dec nmaster */

	/* === Gaps (OXWM-matching: Super+A to toggle) === */
	{ MODKEY,                       XK_a,      togglegaps,     {0} },                 /* Super+A: toggle gaps */
	{ MODKEY|ShiftMask,             XK_a,      defaultgaps,    {0} },                 /* Super+Shift+A: reset gaps */

	/* === Bar === */
	{ MODKEY,                       XK_b,      togglebar,      {0} },                 /* Super+B: toggle bar */

	/* === Keybind overlay (OXWM: Super+Shift+/) === */
	{ MODKEY|ShiftMask,             XK_slash,  spawn,          SHCMD("nilwm-keybinds.sh") },

	/* === Tags 1-9 (OXWM-matching) === */
	TAGKEYS(                        XK_1,                      0)
	TAGKEYS(                        XK_2,                      1)
	TAGKEYS(                        XK_3,                      2)
	TAGKEYS(                        XK_4,                      3)
	TAGKEYS(                        XK_5,                      4)
	TAGKEYS(                        XK_6,                      5)
	TAGKEYS(                        XK_7,                      6)
	TAGKEYS(                        XK_8,                      7)
	TAGKEYS(                        XK_9,                      8)

	/* === View all tags === */
	{ MODKEY,                       XK_0,      view,           {.ui = ~0 } },
	{ MODKEY|ShiftMask,             XK_0,      tag,            {.ui = ~0 } },

	/* === Multi-Monitor (OXWM-matching) === */
	{ MODKEY,                       XK_comma,  focusmon,       {.i = -1 } },          /* Super+Comma: focus prev monitor */
	{ MODKEY,                       XK_period, focusmon,       {.i = +1 } },          /* Super+Period: focus next monitor */
	{ MODKEY|ShiftMask,             XK_comma,  tagmon,         {.i = -1 } },          /* Super+Shift+Comma: send to prev monitor */
	{ MODKEY|ShiftMask,             XK_period, tagmon,         {.i = +1 } },          /* Super+Shift+Period: send to next monitor */
};

/* button definitions */
/* click can be ClkTagBar, ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static const Button buttons[] = {
	/* click                event mask      button          function        argument */
	{ ClkLtSymbol,          0,              Button1,        setlayout,      {0} },
	{ ClkLtSymbol,          0,              Button3,        setlayout,      {.v = &layouts[2]} },
	{ ClkWinTitle,          0,              Button2,        zoom,           {0} },
	{ ClkStatusText,        0,              Button2,        spawn,          {.v = termcmd } },
	{ ClkClientWin,         MODKEY,         Button1,        movemouse,      {0} },       /* Super+Button1: move window */
	{ ClkClientWin,         MODKEY,         Button2,        togglefloating, {0} },
	{ ClkClientWin,         MODKEY,         Button3,        resizemouse,    {0} },       /* Super+Button3: resize window */
	{ ClkTagBar,            0,              Button1,        view,           {0} },       /* click tag: switch */
	{ ClkTagBar,            0,              Button3,        toggleview,     {0} },
	{ ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
	{ ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
};
