// weapons.qc
//
// this file handles shooting weapons, as well as input impulses
//
// this file is licensed under the GPL v3

void menuInput(float input);
void thirdpersonToggle();

// called on +attack with a shootable weapon
void attack()
{
	// precalculate forward attack angle
	makeVectors(self.v_angle);

	if (self.weapon == IT_ROCKET_LAUNCHER)
	{
		if (self.prim == PRIM_ROCKET_LAUNCHER ||
			self.prim == PRIM_IMPLOSION)
		{
			anim_playerAttack();
			fireRocket();
			self.attackFinishedRocket = time + 0.8;
		}
		else if (self.prim == PRIM_OVERLOADER)
		{
			// don't do anything when spewing.
			if (self.spewing)
				return;

			fireOverload();
			self.attackFinishedRocket = time + 1.04;
		}
	}
	else if (self.weapon == IT_GRENADE_LAUNCHER)
	{
		if (self.sec == SEC_STICKYBOMB)
		{
			anim_playerAttack();
			fireGrenade();
			self.attackFinishedGrenade = time + 0.6;
		}
	}
	else if (self.weapon == IT_CHOVEL)
	{
		sound(self, CHAN_WEAPON, "weapons/swing.wav", 0.6, ATTN_NORM);
		// the actual swing function doesn't start until a little bit
		// into the animation, so it is called in playeranims.qc
		anim_playerAttack();
		self.attackFinished = time + 0.96;
	}
}

// this is called every frame in playerPostThink, after physics is run
void weaponFrame()
{
	// don't auto-fire on weappons that don't allow it
	if (!self.stuck && self.button0 && !self.button0Reset)
	{		
		// don't switch off a weapon until it is done firing
		if (self.weapon == IT_ROCKET_LAUNCHER &&
			time < self.attackFinishedRocket)
		{
			return;
		}
		else if (self.weapon == IT_GRENADE_LAUNCHER &&
			time < self.attackFinishedGrenade)
		{
			return;
		}
		else if (self.weapon == IT_CHOVEL && 
			time < self.attackFinished)
		{
			return;
		}
		
		if (time < self.deployTime)
			return;

		attack();
	}
	else if (!self.button0)
		self.button0Reset = FALSE;

	// +button3 since +use doesn't work
	// don't auto-fire concs
	if (!self.stuck && self.button3 && !self.button3Reset)
	{
		if (self.sec == SEC_STICKYBOMB)
			blowGrenades();
		else if (self.sec == SEC_CONC)
		{
			self.button3Reset = TRUE;
			primeConc();
		}
		else if (self.sec == SEC_GRAPPLE)
		{
			fireGrapple();
			self.attackFinishedGrenade = time + 0.1;
			self.button3Reset = TRUE;
		}
	}
	else if (!self.button3)
		self.button3Reset = FALSE;

	if (self.button4)	
		self.cantWallrun = TRUE;

	checkSpew();
}
