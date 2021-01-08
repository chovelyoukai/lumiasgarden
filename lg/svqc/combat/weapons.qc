void menuInput(float input);
void thirdpersonToggle();

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
		anim_playerAttack();
		self.attackFinished = time + 0.96;
	}

}

void changeWeapon()
{
	if (self.impulse == self.weapon + 1)
		return;

	self.deployTime = time + 0.6;
	self.weaponframe = 0;
	self.think = anim_playerRun;

	if (self.impulse == 1)
	{
		// set all the animations to use.
		self.idlePose = POSE_RL_IDLE;
		self.runPose = POSE_RL_RUN;
		self.idleAttackPose = POSE_RL_IDLE_ATT;
		self.runAttackPose = POSE_RL_RUN_ATT;

		self.weaponmodel = "progs/weapon_views/v_rocket.iqm";
		self.weaponframe = 0;
		self.weapon = IT_ROCKET_LAUNCHER;
	}
	else if (self.impulse == 2)
	{
		// can't actually switch to conc grenades or grapple gun
		// so don't change anything and reset delay
		
		if (self.sec == SEC_CONC || self.sec == SEC_GRAPPLE)
		{
			self.deployTime = 0;
			return;
		}

		// set all the animations to use.
		self.idlePose = POSE_GL_IDLE;
		self.runPose = POSE_GL_RUN;
		self.idleAttackPose = POSE_GL_IDLE_ATT;
		self.runAttackPose = POSE_GL_RUN_ATT;

		self.weaponmodel = "progs/weapon_views/v_grenade.iqm";
		self.weaponframe = 0;
		self.weapon = IT_GRENADE_LAUNCHER;
	}
	else if (self.impulse == 3)
	{
		// set all the animations to use.
		self.idlePose = POSE_CH_IDLE;
		self.runPose = POSE_CH_RUN;
		self.idleAttackPose = POSE_CH_IDLE_ATT;
		self.runAttackPose = POSE_CH_RUN_ATT;

		self.weaponmodel = "progs/weapon_views/v_chovel.iqm";
		self.weaponframe = 0;
		self.weapon = IT_CHOVEL;
	}
}

void impulseCommands()
{
	if (self.inMenu)
	{
		menuInput(self.impulse);
		self.impulse = 0;
		return;
	}
	if (self.impulse >= 1 && self.impulse <= 3)
		changeWeapon();

	if (self.impulse == 254)
		killed(self, self);
	else if (self.impulse == 253)
	{
		self.switchWeps = TRUE;
		centerPrint(self, "You can switch weapons on respawn.\n");
	}
	else if (self.impulse == 252)
		thirdpersonToggle();
	else if (self.impulse == 251)
	{
		if (self.stuck)
			anim_sitLeave1();
		else
		{
			if (self.flags & FL_ONGROUND)
			{
				self.velocity = '0 0 0';
				anim_sitEnter1();
			}
		}
	}

	self.impulse = 0;
}

void weaponFrame()
{
	if (self.impulse)
		impulseCommands();

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

	// if we are currently spewing, handle that here
	if (self.spewing && self.nextSpew < time)
	{
		if (self.overloaded == 0)
			self.spewing = 0;
		else
		{
			fireRocket();
			self.overloaded--;
			self.nextSpew = time + 0.24;
		}
	}

	// if we are using the overloader, spew when anything is loaded
	// and button0 is not being held down
	if (self.overloaded > 0 && self.overloaded < 6 &&
		!self.spewing && !self.button0)
	{
		// if some was already overloaded, then don't fire it a second
		// time
		if (self.overloaded > 3)
			self.overloaded = 6 - self.overloaded;

		self.spewing = 1;
		self.nextSpew = time + 0.24;
	}
}
