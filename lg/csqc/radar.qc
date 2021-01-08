#define RAD_SIZE 128
#define RAD_RADIUS 256
#define RAD_ALPHA 0.3 
#define RAD_DIST 512

vector getPlayerPosition()
{
	local vector p;

	p_x = getstatf(STAT_LG_PX);
	p_y = getstatf(STAT_LG_PY);
	p_z = getstatf(STAT_LG_PZ);

	return p;
}

void drawRadar(float width, float height)
{
	local entity e;
	local float x = (0.85 * width) - RAD_SIZE;
	local float y = (0.95 * height) - RAD_SIZE;
	local float xCenter = x + (RAD_SIZE / 2);
	local float yCenter = y + (RAD_SIZE / 2);
	local float ex, ey, ez, exrot, eyrot;
	local vector playerOrg;
	local float v_angle = TWOPI360 * (getstatf(STAT_LG_PP) + 180 + 90);
	local vector color = '0 0 0';
	local vector twoDist;

	drawpic([x, y], "gfx/radar.lmp", [RAD_SIZE, RAD_SIZE], '1 1 1', RAD_ALPHA, 1);

	playerOrg = getPlayerPosition();

	e = find(world, tdone, "0"); 

	while(e)
	{
		twoDist = [playerOrg_x - e.origin_x, playerOrg_y - e.origin_y];
		if (e.classname == "tracker" && vlen(twoDist) <= RAD_DIST)
		{
			// get the 2D offset from the player
			ex = e.origin_x - playerOrg_x;
			ey = playerOrg_y - e.origin_y;
			// get the Z offset for color calculation
			ez = e.origin_z - playerOrg_z;
			
			// scale the offset to +/-64
			ex = ex / (RAD_DIST / 64);
			ey = ey / (RAD_DIST / 64);

			// rotate it according to the players view yaw
			exrot = (ex * cos(v_angle)) - (ey * sin(v_angle));
			eyrot = (ey * cos(v_angle)) + (ex * sin(v_angle));

			ex = exrot;
			ey = eyrot;
	
			// offset it to the center of the radar, and by the size of the box
			ex += xCenter - 2;
			ey += yCenter - 2;

			// at most, e is above us by 256 units
			// at least, e is below us by 256 units
			// if it is above, make it red.
			if (ez > 0)
			{
				if (ez < 256)
					color_x = ez / 256;
				else
					color_x = 1.0;
				color_y = 0;
				color_z = 1.0 - ez;
			}
			else
			{
				color_x = 0;
				if (ez > -256)
					color_y = -1 * ez / 256;
				else
					color_y = 1.0;
				color_z = 1.0 + ez;
			}
	
			if (color_z < 0)
				color_z = 0;
			
			// draw a box at that location over the radar display
			drawfill([ex, ey], [4, 4], color, 1.0, 1);
			drawfill([ex, ey], [4, 4], color, 1.0, 1);
		}
		e.tdone = "1";
		e = find(world, tdone, "0");
	}

	// reset all the tdone values to 0
	e = find(world, tdone, "1");
	while (e)
	{
		e.tdone = "0";
		e = find(world, tdone, "1");
	}

	// draw the player
	drawfill([xCenter - 2, yCenter - 2], [4, 4], '0 0 255', 1.0, 1);
	drawfill([xCenter - 2, yCenter - 2], [4, 4], '0 0 255', 1.0, 1);
}
