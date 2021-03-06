// rocket.qc
//
// all the functions required for the stickybomb launcher
//
// this file is licensed under the GPL v3

// called when grenades explode
void grenadeExplode()
{
	applyRadiusDmg(self, self.owner, 150, world, BLAST_RADIUS);
	self.classname = "explodingGrenade";

	writeByte(MSG_BROADCAST, SVC_TEMPENTITY);
	writeByte(MSG_BROADCAST, TE_EXPLOSION);
	writeCoord(MSG_BROADCAST, self.origin_x);
	writeCoord(MSG_BROADCAST, self.origin_y);
	writeCoord(MSG_BROADCAST, self.origin_z);

	becomeExplosion();
}

// add brightness to grenade when it arms
void grenadeArmEffect()
{
    self.effects |= EF_DIMLIGHT;
}

// the grenade touch function that sticks it to things
void grenadeTouch()
{
	if (other == self.owner)
		return;

    if (other.classname == "grenade")
        return;
	
	if (other == world)
	{
		self.movetype = MOVETYPE_NONE;
		return;
	}

	sound(self, CHAN_WEAPON, "ui/slap.wav", 0.1, ATTN_NORM);
	
	// stop spinning if not moving
	if (self.velocity == '0 0 0')
		self.avelocity = '0 0 0';
}

// the shoot function called from weapons.qc
void fireGrenade()
{
	local entity grenade, oldGrenade;
	local entity oldSelf;
	local float bestTime = time;

	sound(self, CHAN_WEAPON, "weapons/fire_grenade.ogg", 0.3, ATTN_NORM);

	self.punchangle_x = -2;

	self.grenades++;

	// can only have 2 grenades out at once
	if (self.grenades > MAX_GRENADES)
	{
		// world is entity 0, so we need to immediately go
		// to the next ent so the loop will actually execute.
		oldGrenade = world;
		oldGrenade = nextEnt(oldGrenade);
	
		while(oldGrenade)
		{
			if (oldGrenade.classname != "grenade"
				|| oldGrenade.owner != self)
			{
				oldGrenade = nextEnt(oldGrenade);
				continue;
			}

			// try to blow the first grenade out
			if (oldGrenade.launchTime < bestTime)
			{
				grenade = oldGrenade;
				bestTime = oldGrenade.launchTime;
			}

			oldGrenade = nextEnt(oldGrenade);
		}
		// grenade should now reference the earliest undetonated
		// grenade.
		oldSelf = self;
		self = grenade;
		grenadeExplode();
		self = oldSelf;
		self.grenades--;
	}

	grenade = spawn();
	grenade.owner = self;
	grenade.movetype = MOVETYPE_BOUNCE;
	grenade.solid = SOLID_BBOX;
	grenade.classname = "grenade";

	// keep track of when it was destroyed so we can get nice
	// behavior when we shoot a third grenade
	grenade.launchTime = time;

	// set grenade velocity
	makeVectors(self.v_angle);

	if (self.v_angle_x)
	{
		grenade.velocity = (v_forward * 900) + (v_up * 200);
	}
	else
	{
		grenade.velocity = aim(self, 10000);
		grenade.velocity = grenade.velocity * 600;
		grenade.velocity_z = 200;
	}

	grenade.avelocity = '300 300 300';

	grenade.angles = vecToAngles(grenade.velocity);

	grenade.touch = grenadeTouch;

	grenade.nextthink = time + 0.8;
	grenade.think = grenadeArmEffect;

	grenade.armTime = time + 0.8;
	grenade.exploding = FALSE;
	
	setModel(grenade, "progs/weapon_world/w_grenade.iqm");
	setSize(grenade, '-4 -4 -4', '4 4 4');
	setOrigin(grenade, self.origin + '0 0 60');

	grenade.effects |= EF_MUZZLEFLASH;
}

// this is also called from weapons.qc when the player uses +attack2
void blowGrenades()
{
	local entity grenade;

	// world is ent 0 so immediately go to the next ent so we
	// actually enter the while loop
	grenade = world;
	grenade = nextEnt(grenade);

	while (grenade)
	{
		if (grenade.classname != "grenade" ||
			grenade.owner != self)
		{
			grenade = nextEnt(grenade);
			continue;
		}

		// don't detonate already exploding grenades.
		if (grenade.armTime < time && grenade.exploding == FALSE)
		{
			grenade.nextthink = time;
			grenade.think = grenadeExplode;
			grenade.exploding = TRUE;
			// keep track of how many grenades we actually detonated
			self.grenades--;
		}

		// this fixes some kind of glitch where we get a negative number
		// of grenades, and thus can shoot more than two
		if (self.grenades < 0)
			self.grenades = 0;

		grenade = nextEnt(grenade);
	}
}
