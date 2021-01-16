#define HURT_DIST 512

void drawDamageIndicator(float width, float height)
{
	local vector playerOrg = getPlayerPosition();
	local vector sizeMin, sizeMax;
	local float x = width / 2;
	local float y = height / 2;
	local float v_angle;
	local float drawAngle;
	local float alpha;
	local entity damager;

	damager = world;
	damager = nextent(damager);

	while (damager)
	{
		if (damager.classname == "damager")
		{
			v_angle = TWOPI360 * getstatf(STAT_LG_PP);

			// reorient the angle in the world
			v_angle += ONEHALFPI;
			// correct for quadrant IV
			if (v_angle < 0)
				v_angle += 4 * ONEHALFPI;

			drawAngle = atan((-damager.origin_y + playerOrg_y)
					/ (-damager.origin_x + playerOrg_x));

			// reorient the angle in the world
			drawAngle += ONEHALFPI;
			// correct for over lower quadrants 
			if (damager.origin_x < playerOrg_x)
				drawAngle += 2 * ONEHALFPI;

			drawAngle = v_angle - drawAngle;

			alpha = damager.timeLeft - time; 

			sizeMin_x = -damager.health;
			sizeMin_y = -damager.health;
			sizeMax_x = damager.health;
			sizeMax_y = damager.health;

			drawrotpic([x, y], sizeMin, sizeMax, "gfx/hurt.png",
				'1 1 1', alpha, drawAngle / TWOPI360);
		}
		damager = nextent(damager);
	}
}
