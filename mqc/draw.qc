// this API uses relative X and Y that range from 0 to 100
// this function sets the absolute coords based on the relative
// coords
void setCoords(vector newCoords)
{
	relCoords = newCoords;
	absCoords_x = newCoords_x * realSize_x / 100;
	absCoords_y = newCoords_y * realSize_y / 100;
}

void addCoords(vector newCoords)
{
	setCoords(relCoords + newCoords);
}

vector relToAbs(vector coords)
{
	coords = coords / 100;
	coords_x = coords_x * realSize_x;
	coords_y = coords_y * realSize_y;
	return coords;
}

// this sets the alignment used for drawing boxes and such
void setAlign(float alignX, float alignY)
{
	drawAlignX = alignX;
	drawAlignY = alignY;
}

// this sets our coordinates to left, right, center, top, bottom, etc
void alignCoords(float alignX, float alignY)
{
	setCoords('0 0 0');

	if (alignX == ALIGN_LEFT)
		addCoords('10 0 0');
	else if (alignX == ALIGN_RIGHT)
		addCoords('90 0 0');
	else if (alignX == ALIGN_CENTER)
		addCoords('50 0 0');

	if (alignY == ALIGN_TOP)
		addCoords('0 10 0');
	else if (alignY == ALIGN_BOTTOM)
		addCoords('0 90 0');
	else if (alignY == ALIGN_CENTER)
		addCoords('0 50 0');
}

// this function takes a relative size and returns an absolute
// coordinate spot based on the current alignment
vector getAbsAlignCoords(vector size)
{
	local vector coords = absCoords;
	size = relToAbs(size);

	if (drawAlignX == ALIGN_LEFT)
		coords_x = absCoords_x;
	else if (drawAlignX == ALIGN_RIGHT)
		coords_x = absCoords_x - size_x;
	else if (drawAlignX == ALIGN_CENTER)
		coords_x = absCoords_x - (size_x / 2);

	if (drawAlignY == ALIGN_TOP)
		coords_y = absCoords_y;
	else if (drawAlignY == ALIGN_BOTTOM)
		coords_y = absCoords_y - size_y;
	else if (drawAlignY == ALIGN_CENTER)
		coords_y = absCoords_y - (size_y / 2);

	return coords;
}

void drawBox(vector size, vector color, float alpha)
{
	// get absolute draw coordinates
	local vector pos = getAbsAlignCoords(size);
	// get absolute size
	size = relToAbs(size);
	drawfill(pos, size, color, alpha); 
}

// draws text then increments the coords down
void drawTextInc(string text, vector scale, vector color, float alpha)
{
	local vector size;
	size_x = strlen(text);
	size_y = scale_y / 3;
	local vector pos = getAbsAlignCoords(size);

	drawstring(pos, text, scale, color, alpha, 0);

	size_x = 0;
	addCoords(size);
}

void drawFillFullScreen(vector color, float alpha)
{
	drawfill('0 0 0', realSize, color, alpha);
}
