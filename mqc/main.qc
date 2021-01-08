void m_close()
{
	menuActive = FALSE;
	setcursormode(FALSE);
	setkeydest(0);
}

void m_open()
{
	menuActive = TRUE;
	currMenu = MENU_ROOT;
	selected = 0;
	setcursormode(TRUE);
	setkeydest(2);
}

void m_init()
{
	currMenu = MENU_ROOT;
	precache_sound("twentytwelvehoax.wav");
	menuActive = FALSE;
	splashTime = time - 4;
	drawfont = loadfont("", autocvar(menu_font, "LiberationMono-Regular.ttf"), "16", -1, 0, 0);
//	localsound("twentytwelvehoax.wav");
	setwindowcaption("Lumia's Garden");
	selected = 0;
}

void m_shutdown()
{

}

void m_draw(vector screensize)
{
	local vector center, size;
	local float splashAlpha, diff;

	// get proper realSize each draw frame
	realSize = getproperty(VF_SCREENPSIZE);
	realSize /= cvar("vid_conautoscale");

	if (menuActive)
	{
		if (currMenu == MENU_ROOT)
			menu_root();
		else if (currMenu == MENU_SETTINGS)
			menu_settings();
	}

	if (time < splashTime)
	{
		diff = splashTime - time;
		if (diff < 1)
			splashAlpha = diff;
		else splashAlpha = 1;

		size = '256 256 256';
		center = screensize / 2;
		center -= size / 2;
		drawfill('0 0 0', screensize, '0 0 0', splashAlpha);

		if (diff - 2 < 2 && diff - 2 > 0)
			splashAlpha = (2 - (diff - 2)) * 0.5;
			
		drawpic(center, "gfx/splash.png", size, '1 1 1', splashAlpha);
	}
}

void m_drawloading(vector screensize, float opaque)
{

}

void m_toggle(float wantmode)
{
	if (menuActive)
		m_close();
	else
		m_open();
}

void Menu_RendererRestarted()
{

}

float Menu_InputEvent(float evtype, float scanx, float chary, float devid)
{
	switch (evtype)
	{
		case IE_KEYDOWN:
			if (scanx == K_ESCAPE)
				m_toggle(1);
			else
				handleKeys(scanx);
	}

	return 0;
}
