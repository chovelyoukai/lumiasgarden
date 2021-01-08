#define BOX_W 192 
#define BOX_H 48 
#define BOX_A 0.8

void drawMenu(float width, float height)
{
	local float inMenu = getstatf(STAT_LG_IN_MENU);
	local float openMenu = getstatf(STAT_LG_OPEN_MENU);
	local vector boxPos, textPos;
	if (inMenu)
	{
		boxPos_x = 0.01 * width;
		boxPos_y = (height - BOX_H) / 2;
		drawfill(boxPos, [BOX_W, BOX_H], '0.1 0.1 0.1', BOX_A); 
		//drawprint(ftos(openMenu));
		if (openMenu == MENU_PRIM)
		{
			textPos_x = boxPos_x + 2;
			textPos_y = boxPos_y + 2;
			drawstring(textPos, "Choose Primary Weapon",
				'12 12 0', '1 1 1', 1.0, 1);
			textPos_y += 12;
			drawstring(textPos, "1. Rocket launcher",
				'12 12 0', '1 1 1', 1.0, 1);
			textPos_y += 12;
			drawstring(textPos, "2. Implosion Cannon",
				'12 12 0', '1 1 1', 1.0, 1);
			textPos_y += 12;
			drawstring(textPos, "3. The Overloader",
				'12 12 0', '1 1 1', 1.0, 1);
		}
		else if (openMenu == MENU_SEC)
		{
			textPos_x = boxPos_x + 2;
			textPos_y = boxPos_y + 2;
			drawstring(textPos, "Choose Secondary Weapon",
				'12 12 0', '1 1 1', 1.0, 1);
			textPos_y += 12;
			drawstring(textPos, "1. Sticky Jumper",
				'12 12 0', '1 1 1', 1.0, 1);
			textPos_y += 12;
			drawstring(textPos, "2. Grappling Hook",
				'12 12 0', '1 1 1', 1.0, 1);
			textPos_y += 12;
			drawstring(textPos, "3. Concussion Grenade",
				'12 12 0', '1 1 1', 1.0, 1);
		}
	}
};
