float oldStatHurt;
float indicatorTime1, indicatorTime2;
float damage1, damage2;

void() checkDamage =
{
	local float newStat;

	newStat = getstatf(STAT_LG_HURT);
	
	if (newStat == oldStatHurt)
		return;
	
	// is the first indicator still being drawn?
	if (indicatorTime1 > time)
	{
		// if the second indicator is also being drawn,
		// overwrite the first.
		if (indicatorTime2 > time)
		{
			damage1 = getstatf(STAT_LG_DAMAGE);
			indicatorTime1 = time + 0.5;
		}
		else
		{
			damage2 = getstatf(STAT_LG_DAMAGE);
			indicatorTime2 = time + 0.5;
		}
	}
	else
	{
		damage1 = getstatf(STAT_LG_DAMAGE);
		indicatorTime1 = time + 0.5;
	}

	oldStatHurt = newStat;
};

void(float width, float height) drawDamageIndicator =
{
	local float size1 = floor(damage1 * 0.6);
	local float size2 = floor(damage2 * 0.6);
	local float alpha1 = (indicatorTime1 - time) * 2;
	local float alpha2 = (indicatorTime2 - time) * 2;

	if (time < indicatorTime1)
		drawfill([(width - size1) / 2, (height - (size1 / 3)) / 2],
			[size1, size1 / 3], '255 0 0', alpha1, 1);

	if (time < indicatorTime2)
		drawfill([(width - (size2 / 3)) / 2, (height - size2) / 2],
			[size2 / 3, size2], '255 0 0' , alpha2, 1);
};
