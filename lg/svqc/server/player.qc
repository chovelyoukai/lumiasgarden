// player.qc
//
// all the player physics functions and other player actions 
//
// this file is licensed under the GPL v3
float reversedGround();

// required engine function for player prediction
void SV_RunClientCommand()
{
	runStandardPlayerPhysics(self);

    if (self.reversed > time)
    {
        if (reversedGround() == TRUE)
        {
            makeVectors(self.v_angle);
            self.velocity = '0 0 0';
            if (input_movevalues.x > 0)
            {
                self.velocity += 320 * v_forward;
            }
            if (input_movevalues.x < 0)
            {
                self.velocity -= 320 * v_forward;
            }
            if (input_movevalues.y > 0)
            {
                self.velocity += 320 * v_right;
            }
            if (input_movevalues.y < 0)
            {
                self.velocity -= 320 * v_right;
            }
        }
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

// check if we are standing while reverse gravitied
float reversedGround()
{
    if (self.reversed < time)
        return FALSE;

    traceBox(self.origin + '0 0 -1', -1 * VEC_HULL_MAX,
             -1 * VEC_HULL_MIN, self.origin + '0 0 0.1', 1, self);

    if (trace_fraction < 1)
        return TRUE;

    return FALSE;
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
	if (!(self.flags & FL_ONGROUND) && !reversedGround())
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
        jumpVel *= -1;

	self.velocity_z = self.velocity_z + jumpVel;
}

// this is called every frame before physics is run
void PlayerPreThink()
{
	// check to see if we are running on a wall
	wallrun();

	// do grappling hook stuff
	if (self.grappled)
		grapplePull();

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

// this is called every frame after physics are run
void PlayerPostThink()
{
    float newSensitivity;

	// check for any weapon buttons being held down
	weaponFrame();

	// handle impulse commands
	if (self.impulse)
		impulseCommands();

    // if the player has left a reversegravity trigger, then reset
    // angles
    if (self.reversed != 0 && self.reversed < time)
    {
        bprint("undoing flip\n");
        bprint(ftos(self.reversed));
        bprint("\n");
        bprint(ftos(time));
        bprint("\n");

        self.origin -= '0 0 80';
        self.view_ofs = '0 0 64';
        self.v_angle.z = 0;
        newSensitivity = -1 * cvar("sensitivity");
        if (newSensitivity > 0)
        {
            stuffCmd(self, "sensitivity ");
            stuffCmd(self, ftos(newSensitivity));
            stuffCmd(self, "\n");
        }
        setSize(self, VEC_HULL_MIN, VEC_HULL_MAX);

        self.flipTime = time + 0.3;
        self.reversed = 0;
    }
}
