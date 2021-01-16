void drawCrosshairString(float width, float height)
{
	local string text = getstats(STAT_LG_LOOK_NAME);
	float x = (width - stringwidth(text, 1, '12 12 0')) / 2;
	float y = 0.6 * height;

	drawstring([x, y], text, '12 12 0', '1 1 1', 1.0, 1);
}

void drawPrint(string str)
{
	drawstring('0 0 0', str, '8 8 0', '1 1 1', 1.0, 1);
}
