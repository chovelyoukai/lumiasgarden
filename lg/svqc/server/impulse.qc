void unreverse();

// this function selects a new weapon on impulse commands
void changeWeapon()
{
	// if we have selected the weapon we are already holding, do nothing
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
		self.lastWeapon = self.weapon;
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
		self.lastWeapon = self.weapon;
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
		self.lastWeapon = self.weapon;
		self.weapon = IT_CHOVEL;
	}
}

// handle various input impulses from the client
void impulseCommands()
{
	// if we're in a menu, re-route the input to the menu function
	if (self.inMenu)
	{
		menuInput(self.impulse);
		self.impulse = 0;
		return;
	}
	if (self.impulse >= 1 && self.impulse <= 3)
		changeWeapon();
	else if (self.impulse == IMP_INCWEP)
	{
		self.impulse = self.weapon;
		if (self.sec == SEC_GRAPPLE || self.sec == SEC_CONC)
			self.impulse--;
		if (self.impulse < 1)
			self.impulse = 3;

		changeWeapon();
	}
	else if (self.impulse == IMP_DECWEP)
	{
		self.impulse = self.weapon + 2;
		if (self.sec == SEC_GRAPPLE || self.sec == SEC_CONC)
			self.impulse++;
		if (self.impulse > 3)
			self.impulse = 1;

		changeWeapon();
	}
	else if (self.impulse == IMP_LASTWEP)
	{
		self.impulse = self.lastWeapon + 1;
		changeWeapon();
	}

	if (self.impulse == IMP_KILL && self.suicideFinished < time)
	{
        unreverse();
		self.suicideFinished = time + 3;
		killed(self, self);
	}
	else if (self.impulse == IMP_CHANGEWEPS)
	{
		self.switchWeps = TRUE;
		// TODO: change from a centerprint to a client-side print
		centerPrint(self, "You can switch weapons on respawn.\n");
	}
	else if (self.impulse == IMP_THIRDPERSON)
		thirdpersonToggle();
	// the sit animation
	else if (self.impulse == IMP_SIT)
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
	else if (self.impulse == 69)
	{
        bprint(vtos(self.v_angle));
        bprint("\n");
        /*
        makeVectors(self.v_angle);
        traceLine(self.origin + self.view_ofs, self.origin + self.view_ofs + 10000 * v_forward, 1, self);
        local entity nudel = spawn();
        setOrigin(nudel, trace_endpos);
        setModel(nudel, "progs/lumia.iqm");
        nudel.basebone = 10;
        nudel.baseframe = 4;
        nudel.frame = 1;
		sprint(self, "nice\n");
        */
	}

	self.impulse = 0;
}
