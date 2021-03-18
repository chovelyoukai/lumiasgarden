// player.qc
//
// all the player physics functions and other player actions 
//
// this file is licensed under the GPL v3
float reversedGround();

// required engine function for player prediction
void SV_RunClientCommand()
{
    calculateFrameTime();
    runStandardPlayerPhysics(self);
    
    if (self.v_angle.x - self.prevPitch > 100)
    {
        self.v_angle.x = self.prevPitch;
        self.prevPitch = 0;
    }

    if (self.reversed > time)
    {
        if (self.reverseGround == TRUE)
        {
            self.velocity = reversedFriction(self.velocity);
            self.velocity = reversedWalk();
        }
        else
        {
            self.velocity += '0 0 27';
        }
        
        self.v_angle.z = 180;
    }

    if (self.reversed == 0)
    {
        setSize(self, VEC_HULL_MIN, VEC_HULL_MAX);
        self.v_angle.z = 360;
    }
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
    local float jumpVel = 270;

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
	if (!(self.flags & FL_ONGROUND) && !self.reverseGround)
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
	if (vlen(self.velocity) > BHOP_MAXSPEED && globalMode != MODE_TRICKJUMP)
		self.velocity = BHOP_MAXSPEED * normalize(self.velocity);

    if (self.reversed > time)
    {
        self.reverseGround = FALSE;
        self.groundCheck = time + 0.1;
        jumpVel *= -1;
    }

	self.velocity_z = self.velocity_z + jumpVel;
}

// this is called every frame before physics is run
void PlayerPreThink()
{
	// check to see if we are running on a wall
	wallrun();

    if (self.reversed > time && self.groundCheck < time)
    {
        self.reverseGround = reversedGround();
    }
    else
    {
        self.reverseGround = FALSE;
    }

	// do grappling hook stuff
	if (self.grappled)
		grapplePull();
    else if (self.grapple != world)
        self.grapple.SendFlags |= 1;

	// see if we are looking at a player and set our lookName to that
	playerLook();

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

void unreverse();
// this is called every frame after physics are run
void PlayerPostThink()
{
	// check for any weapon buttons being held down
	weaponFrame();

	// handle impulse commands
	if (self.impulse)
		impulseCommands();

    if (self.reverseGround)
    {
        self.origin = stickToGround();
        self.velocity.z = 0;
    }

    // if the player has left a reversegravity trigger, then reset
    // angles
    if (self.reversed != 0 && self.reversed < time)
    {
        unreverse();
    }
}

void unreverse()
{
    self.origin -= '0 0 80';
    self.view_ofs = '0 0 64';
    self.v_angle.z = 0;

    self.prevPitch = self.v_angle.x;

    setSize(self, VEC_HULL_MIN, VEC_HULL_MAX);
    setModel(self, "progs/lumia.iqm");

    self.flipTime = time + 0.3;
    self.reversed = 0;

}
