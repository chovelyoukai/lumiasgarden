// grapple.qc
//
// all the functions required for the grappling hook
//
// this file is licensed under the GPL v3

// this function is called in playerPreThink every frame if the
// player is currently grappled, and it will pull the player if 
// the player is too far away
void grapplePull()
{
	local float dist = vlen(self.origin - self.grapple.origin);
	local vector separated = self.origin - self.grapple.origin;

	if (dist > self.grappleDistance)
	{
		// remove the part of our velocity pulling against the rope
		self.velocity = self.velocity - proj(self.velocity, separated);
		// give a small boost back up to keep from slowly dropping
		self.velocity -= (dist - self.grappleDistance)
			* normalize(separated);
	}

    self.grapple.SendFlags |= 1;
}

// touch function for the grapple hook, will stick it to things and
// activate the grapple status for the player
void grappleTouch()
{
	if (other == self.owner)
		return;
	
	if (other == world)
	{
		self.movetype = MOVETYPE_NONE;
		self.owner.grappled = TRUE;
		self.owner.grappleDistance = vlen(self.origin - self.owner.origin);
		return;
	}

	sound(self, CHAN_WEAPON, "ui/slap.wav", 0.1, ATTN_NORM);
	
	// stop spinning if not moving
	if (self.velocity == '0 0 0')
		self.avelocity = '0 0 0';
}

// grapple shoot function called from weapons.qc
void fireGrapple()
{
	local entity hook;

	sound(self, CHAN_WEAPON, "weapons/fire_grenade.ogg", 0.3, ATTN_NORM);

	self.punchangle_x = -2;

	// if we already have a hook out, get rid of it.
	if (self.grapple != world)
	{
		remove(self.grapple);
		self.grapple = world;
		self.grappled = FALSE;
		return;
	}
	
	hook = spawn();
	hook.owner = self;
	hook.movetype = MOVETYPE_BOUNCE;
	hook.solid = SOLID_BBOX;
	hook.classname = "hook";
    hook.SendEntity = sendGrapple;

	self.grapple = hook;

	// set hook velocity
	makeVectors(self.v_angle);

	if (self.v_angle_x)
	{
		hook.velocity = (v_forward * 1400) + (v_up * 150);
	}
	else
	{
		hook.velocity = aim(self, 10000);
		hook.velocity = hook.velocity * 900;
		hook.velocity_z = 150;
	}

	hook.avelocity = '0 0 0';

	hook.angles = vecToAngles(hook.velocity);

	hook.touch = grappleTouch;

	hook.nextthink = time + 5;
	hook.think = SUB_null;

	setModel(hook, "progs/weapon_world/w_spike.iqm");
	setSize(hook, '-4 -4 -4', '4 4 4');
	setOrigin(hook, self.origin + '0 0 64');

	hook.effects |= EF_MUZZLEFLASH | EF_DIMLIGHT;
}
