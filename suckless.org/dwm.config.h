/* See LICENSE file for copyright and license details. */

/* appearance */
static const unsigned int borderpx  = 1;        /* border pixel of windows */
static const unsigned int snap      = 32;       /* snap pixel */
static const int showbar            = 1;        /* 0 means no bar */
static const int topbar             = 1;        /* 0 means bottom bar */
static const char *fonts[]          = { "Inconsolas:size=10" };
static const char dmenufont[]       = "Inconsolas:size=10";
static const char *colors[][3]      = {
	/*               fg         bg         border   */
	[SchemeNorm] = { "#bababa", "#121212", "#121212" },
	[SchemeSel]  = { "#bababa", "#000000", "#bababa" },
};

/* tagging */
static const char *tags[] = { "1", "2", "3", "4", "5", "6", "7", "8", "9" };

static const Rule rules[] = {
	/* xprop(1):
	 *	WM_CLASS(STRING) = instance, class
	 *	WM_NAME(STRING) = title
	 */
	/* class      instance    title       tags mask     isfloating   monitor */
	{ "Gimp",     NULL,       NULL,       1 << 8,       1,           -1 },
	{ "firefox",  NULL,       NULL,       1 << 1,       0,           -1 },
	{ "Chromium", NULL,       NULL,       1 << 1,       0,           -1 },
};

/* layout(s) */
static const float mfact     = 0.62; /* factor of master area size [0.05..0.95] */
static const int nmaster     = 1;    /* number of clients in master area */
static const int resizehints = 0;    /* 1 means respect size hints in tiled resizals */
static const int lockfullscreen = 1; /* 1 will force focus on the fullscreen window */

static const Layout layouts[] = {
	/* symbol     arrange function */
	{ "Tfm",      tile },    /* first entry is default */
	{ "tFm",      NULL },    /* no layout function means floating behavior */
	{ "tfM",     monocle },
};

/* key definitions */
#define MODKEY Mod4Mask /* xmodmap */
#define TAGKEYS(KEY,TAG) \
	{ MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
	{ MODKEY|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

/* commands */
static char dmenumon[2] = "0"; /* component of dmenucmd, manipulated in spawn() */
static const char *dmenucmd[] = { "dmenu_run", "-m", dmenumon, "-fn", dmenufont, \
  "-nb","#000000","-nf","#bababa","-sb", "#bababa","-sf","#000000", NULL };
static const char *termcmd[]              = { "xfce4-terminal", NULL };
static const char *appfinder_cmd[]        = { "xfce4-appfinder", NULL };
static const char *filesearch_cmd[]       = { "catfish", NULL };
static const char *lock_cmd[]             = { "light-locker-command", "-l", NULL }; /* run `light-locker` first */
static const char *clipmenu_cmd[]         = { "clipmenu", NULL }; /* run `clipmenud` first */
static const char *firefox_cmd[]          = { "firefox", NULL };
static const char *firefox_private_cmd[]  = { "firefox", "--private-window", NULL};
static const char *xmice_cmd[]            = { "zsh", "-c", "~/bin/xmice.sh", NULL};
static const char *thunar_cmd[]           = { "thunar", NULL };
static const char *chromium_cmd[]         = { "chromium", NULL};

static Key keys[] = {
	/* modifier                     key        function        argument */
	{ MODKEY|Mod1Mask,              XK_w,      spawn,          {.v = chromium_cmd } },
	{ MODKEY,                       XK_e,      spawn,          {.v = thunar_cmd } },
	{ MODKEY,                       XK_semicolon, spawn,       {.v = xmice_cmd } },
	{ MODKEY,                       XK_v,      spawn,          {.v = clipmenu_cmd } },
	{ MODKEY,                       XK_Delete, spawn,          {.v = lock_cmd } },
	{ MODKEY,                       XK_w,      spawn,          {.v = firefox_cmd } },
	{ MODKEY|ShiftMask,             XK_w,      spawn,          {.v = firefox_private_cmd } },
	{ MODKEY,                       XK_a,      spawn,          {.v = appfinder_cmd } },
	{ MODKEY,                       XK_s,      spawn,          {.v = filesearch_cmd } },
	{ MODKEY,                       XK_p,      spawn,          {.v = dmenucmd } },
	{ MODKEY|ShiftMask,             XK_Return, spawn,          {.v = termcmd } },
	{ MODKEY,                       XK_b,      togglebar,      {0} },
	{ MODKEY,                       XK_j,      focusstack,     {.i = +1 } },
	{ MODKEY,                       XK_k,      focusstack,     {.i = -1 } },
	{ MODKEY,                       XK_i,      incnmaster,     {.i = +1 } },
	{ MODKEY,                       XK_d,      incnmaster,     {.i = -1 } },
	{ MODKEY,                       XK_h,      setmfact,       {.f = -0.05} },
	{ MODKEY,                       XK_l,      setmfact,       {.f = +0.05} },
	{ MODKEY,                       XK_Return, zoom,           {0} },
	{ MODKEY,                       XK_Tab,    view,           {0} },
	{ MODKEY|ShiftMask,             XK_c,      killclient,     {0} },
	{ MODKEY,                       XK_t,      setlayout,      {.v = &layouts[0]} },
	{ MODKEY,                       XK_f,      setlayout,      {.v = &layouts[1]} },
	{ MODKEY,                       XK_m,      setlayout,      {.v = &layouts[2]} },
	{ MODKEY,                       XK_space,  setlayout,      {0} },
	{ MODKEY|ShiftMask,             XK_space,  togglefloating, {0} },
	{ MODKEY,                       XK_0,      view,           {.ui = ~0 } },
	{ MODKEY|ShiftMask,             XK_0,      tag,            {.ui = ~0 } },
	{ MODKEY,                       XK_comma,  focusmon,       {.i = -1 } },
	{ MODKEY,                       XK_period, focusmon,       {.i = +1 } },
	{ MODKEY|ShiftMask,             XK_comma,  tagmon,         {.i = -1 } },
	{ MODKEY|ShiftMask,             XK_period, tagmon,         {.i = +1 } },
	TAGKEYS(                        XK_1,                      0)
	TAGKEYS(                        XK_2,                      1)
	TAGKEYS(                        XK_3,                      2)
	TAGKEYS(                        XK_4,                      3)
	TAGKEYS(                        XK_5,                      4)
	TAGKEYS(                        XK_6,                      5)
	TAGKEYS(                        XK_7,                      6)
	TAGKEYS(                        XK_8,                      7)
	TAGKEYS(                        XK_9,                      8)
	{ MODKEY|ShiftMask,             XK_q,      quit,           {0} },
};

/* button definitions */
/* click can be ClkTagBar, ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static Button buttons[] = {
	/* click                event mask      button          function        argument */
	{ ClkLtSymbol,          0,              Button1,        setlayout,      {0} },
	{ ClkLtSymbol,          0,              Button3,        setlayout,      {.v = &layouts[2]} },
	{ ClkWinTitle,          0,              Button2,        zoom,           {0} },
	{ ClkStatusText,        0,              Button2,        spawn,          {.v = termcmd } },
	{ ClkClientWin,         MODKEY,         Button1,        movemouse,      {0} },
	{ ClkClientWin,         MODKEY,         Button2,        togglefloating, {0} },
	{ ClkClientWin,         MODKEY,         Button3,        resizemouse,    {0} },
	{ ClkTagBar,            0,              Button1,        view,           {0} },
	{ ClkTagBar,            0,              Button3,        toggleview,     {0} },
	{ ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
	{ ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
};

/* patch: uselessgap */
static const unsigned int gappx = 0;
/* patch: cool-autostart */
static const char *const autostart[] = {
	"xfce4-terminal", NULL,
	// "bash", "-c", "", NULL,
	NULL /* terminate */
};
