// player.qc
//
// all the player physics functions and other player actions 
//
// this file is licensed under the GPL v3

// required engine function for player prediction
void SV_RunClientCommand()
{
	runStandardPlayerPhysics(self);
}

// called when the player dies as self.thinkDie()
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

// this is how we jump
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

	// if we're in midair, don't jump
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

	// clip the player's speed if they're going too fast
	if (vlen(self.velocity) > BHOP_MAXSPEED)
		self.velocity = BHOP_MAXSPEED * normalize(self.velocity);

	self.velocity_z = self.velocity_z + 270;
}

// this is called every frame before physics is run
void PlayerPreThink()
{
	// check to see if we are running on a wall
	wallrun();

	// do grappling hook stuff
	if (self.grappled)
		grapplePull();

	// if we're holding jump, then store our rocketJumpFlag status
	// even if we hit the ground
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

// this is called every frame after physics are run
void PlayerPostThink()
{
	// check for any weapon buttons being held down
	weaponFrame();

}
