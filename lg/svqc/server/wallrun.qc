// called in player prethink
void wallrun()
{
	local vector right, up, traceOrigin;

	// if this is set by a trigger, unset it
	// and then it will be set again if we are
	// still in the trigger.
	if (self.cantWallrun)
	{	
		self.cantWallrun = 0;
		return;
	}

	makeVectors(self.v_angle);

	// we can always initiate a wallrun if we were
	// on the ground first.
	if (self.flags & FL_ONGROUND)
	{
		self.wallrunning = 0;
		self.wallrunTime = 0;
	}

	// jumping cancels wallrun on the current side
	if (self.wallrunning && self.button2 &&
		self.wallrunTime != 0 &&
		self.wallrunTime <= time - 0.2)
	{
		right = 350 * normalize(v_right);

		// pop off the wall in the opposite direction
		if (self.wallrunSide == WR_RIGHT)
			self.velocity -= right;

		else if (self.wallrunSide == WR_LEFT)
			self.velocity += right;

		self.wallrunning = 0;
		self.wallrunTime = 0;
		self.velocity_z += 270;	
		sound(self, CHAN_BODY, "ui/slap.wav", 1, ATTN_NORM);
		return;
	}

	// default 64 *
	right = WR_MAXDIST * normalize(v_right);
	traceOrigin = self.origin - '0 0 16';
	up = '0 0 13';

	self.wallrunning = 0;

	traceLine(traceOrigin, traceOrigin + right, 1, self);
	if (trace_fraction < 1 && trace_ent == world)
	{
		self.wallrunSide = WR_RIGHT;
		self.wallrunning = 1;
	}
	
	traceLine(self.origin, self.origin - right, 1, self);
	if (trace_fraction < 1 && trace_ent == world)
	{
		self.wallrunSide = WR_LEFT;
		self.wallrunning = 1;
	}

	if (self.wallrunning == 1 && !(self.flags & FL_ONGROUND))
	{
		// if we just started wallrunning, then keep
		// track of when we did, so there can be a delay
		// for jump-off
		if (self.wallrunTime == 0)
		{
			sound (self, CHAN_AUTO, "ui/wallattach.wav", 1, ATTN_NORM);
			self.wallrunTime = time;
		}

		if (self.velocity_z > 0)
			return;

		self.velocity += up;
	}
	else if (self.wallrunning == 0)
		self.wallrunTime = 0;
}