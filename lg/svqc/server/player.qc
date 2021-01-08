void playerDie()
{
	self.weaponmodel = "";
	self.view_ofs = '0 0 -8';
	self.deadflag = DEAD_DYING;
	self.solid = SOLID_NOT;
	self.flags = self.flags - (self.flags & FL_ONGROUND);
	self.movetype = MOVETYPE_TOSS;

	self.angles_x = 0;
	self.angles_y = 0;

	respawn();
}

void playerJump()
{
	// don't jump in water
	if (self.flags & FL_WATERJUMP)
		return;
	
	// swim up in water
	if (self.waterlevel >= 2)
	{
		self.velocity_z = 100;
		return;
	}

	if (!(self.flags & FL_ONGROUND))
	{
		return;
	}

	if (!(self.flags & FL_JUMPRELEASED))
	{
		return; // no autobhop
	}

	self.flags = self.flags - (self.flags & FL_JUMPRELEASED);
	self.button2 = 0;

	if (vlen(self.velocity) > BHOP_MAXSPEED)
		self.velocity = BHOP_MAXSPEED * normalize(self.velocity);

	self.velocity_z = self.velocity_z + 270;
}

void PlayerPreThink()
{
	wallrun();

	if (self.grappled)
		grapplePull();

	if (self.button2)
	{
		playerJump();
	}
	else
	{
		if (self.flags & FL_ONGROUND)
			self.rocketJumpFlag = FALSE;
		self.flags = self.flags | FL_JUMPRELEASED;
	}
}

void PlayerPostThink()
{
	// check for any weapon buttons being held down
	weaponFrame();

}
