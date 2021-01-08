void drawSelector()
{
	float i;

	alignCoords(ALIGN_LEFT, ALIGN_TOP);
	addCoords('-2 0 0');

	drawTextInc("", '24 24 0', '0 0 0', 0);

	for (i = 0; i < selected; i++)
		drawTextInc("", '16 16 0', '1 1 1', 0);
	
	drawTextInc(">", '16 16 0', '1 1 1', 1);
}

void switchMenu(float newMenu)
{
	currMenu = newMenu;
	selected = 0;
}

void menu_root()
{
	maxSelect = 3;

	// make all the things we draw centered locally
	setAlign(ALIGN_LEFT, ALIGN_TOP);

	// draw menu BG
	drawFillFullScreen(MENU_BG_COLOR, MENU_BG_ALPHA);

	// draw menu text
	alignCoords(ALIGN_LEFT, ALIGN_TOP);
	drawTextInc("Lumia's Garden", '24 24 0', '1 1 1', 1);
	drawTextInc("Servers", '16 16 0', '1 1 1', 1);
	drawTextInc("Disconnect", '16 16 0', '1 1 1', 1);
	drawTextInc("Settings", '16 16 0', '1 1 1', 1);
	drawTextInc("Quit", '16 16 0', '1 1 1', 1);

	//reset and draw selector
	drawSelector();
}

void menuSelect_root()
{
	// open server browser
	if (selected == 0)
	{
		clearscene();
		localcmd("menu_servers\n");
	}
	// disconnect 
	else if (selected == 1)
		localcmd("disconnect\n");
	else if (selected == 2)
	{
		switchMenu(MENU_SETTINGS);
	}
	// quit
	else if (selected == 3)
		localcmd("quit\n");
}

void menu_settings()
{
	maxSelect = 1;

	// make all the things we draw centered locally
	setAlign(ALIGN_LEFT, ALIGN_TOP);

	// draw menu BG
	drawFillFullScreen(MENU_BG_COLOR, MENU_BG_ALPHA);

	// draw menu text
	alignCoords(ALIGN_LEFT, ALIGN_TOP);
	drawTextInc("Settings", '24 24 0', '1 1 1', 1);
	drawTextInc("Nothing Here!!", '16 16 0', '1 1 1', 1);
	drawTextInc("Back", '16 16 0', '1 1 1', 1);

	//reset and draw selector
	drawSelector();
}

void menuSelect_settings()
{
	if (selected == 1)
		switchMenu(MENU_ROOT);
}

void handleKeys(float scanx)
{
	switch (scanx)
	{
		case K_DOWNARROW:
		case 's':
			if (selected >= maxSelect)
				break;
			else
				selected++;
			break;
		case K_UPARROW:
		case 'w':
			if (selected <= 0)
				break;
			else
				selected--;
			break;
		case K_ENTER:
		case K_SPACE:
			if (currMenu == MENU_ROOT)
				menuSelect_root();
			else if (currMenu == MENU_SETTINGS)
				menuSelect_settings();
			break;
	}
}
