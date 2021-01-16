// conc.qc
//
// all the functions required for conc grenades
//
// this file is licensed under the GPL v3

// the knockback function for conc grenades, based on the function
// from TF
void radiusBounce(entity inflictor, entity attacker, float bounce, entity ignore)
{
	local float points;
	local vector org;

	if (vlen(attacker.origin - self.origin) > bounce + 40)
		return;

	attacker.rocketJumpFlag = 1;

	org = attacker.origin + (attacker.mins + attacker.maxs) * 0.5;
	
	points = 0.5 * vlen(org - inflictor.origin);
	if (points < 0)
		points = 0;
	points = bounce - points;

	if (points > 0)
	{
		attacker.velocity = org - inflictor.origin;
		attacker.velocity *= (points / 20);
	}

	spawnDamager(attacker, vlen(org - inflictor.origin) / 2, self.origin);
}

// explode function for concs that have actually been thrown
void() concExplode =
{
	radiusBounce (self, self.owner, 240, world);

	writeByte (MSG_BROADCAST, SVC_TEMPENTITY);
	writeByte (MSG_BROADCAST, TE_EXPLOSION);
	writeCoord (MSG_BROADCAST, self.origin_x);
	writeCoord (MSG_BROADCAST, self.origin_y);
	writeCoord (MSG_BROADCAST, self.origin_z);

	becomeExplosion ();
}

// conc touch function
void() concTouch =
{
	sound (self, CHAN_WEAPON, "ui/slap.wav", 0.1, ATTN_NORM);
	if (self.velocity == '0 0 0')
		self.avelocity = '0 0 0';
}

// this is the think function for the timer entity spawned when the
// player primes a conc grenade. it will try to throw the conc if
// the player has let go of the button, otherwise it will try again
// in 0.02 seconds
void throwConc()
{
	local entity conc;

	setOrigin(self, self.owner.origin);

	// if we have reached the end of the countdown, explode
	// on holder
	if (self.countdown <= time)
	{
		self.owner.holdingGrenade = 0;
		self.owner.velocity *= 2;

		writeByte (MSG_BROADCAST, SVC_TEMPENTITY);
		writeByte (MSG_BROADCAST, TE_EXPLOSION);
		writeCoord (MSG_BROADCAST, self.origin_x);
		writeCoord (MSG_BROADCAST, self.origin_y);
		writeCoord (MSG_BROADCAST, self.origin_z);
	
		becomeExplosion ();
	}

	// if we're still holding the conc button, don't throw it.
	// (only if the throw countdown hasn't begun)
	if (self.throwCount == 0 && self.owner.button3)
	{
		self.nextthink = time + 0.02;
		return;
	}

	// owner's throwCount is time until they can start priming
	// another grenade
	self.owner.throwCount = time + 0.3;
	// our throwCount is time until we actually throw the grenade
	if (self.throwCount == 0)
		self.throwCount = time + 0.2;

	// don't do anything until *our* throwCount is up
	if (self.throwCount > time)
	{
		self.nextthink = 0.02;
		return;
	}

	self.owner.holdingGrenade = 0;

	conc = spawn();
	conc.classname = "conc";
	conc.owner = self.owner;

	conc.movetype = MOVETYPE_BOUNCE;
	conc.solid = SOLID_BBOX;
	conc.classname = "conc";

	conc.nextthink = self.countdown;
	conc.think = concExplode;
		
	// set missile speed	

	makeVectors (self.owner.v_angle);

	if (self.owner.v_angle_x)
	{
		conc.velocity = v_forward*600 + v_up * 200;
	}
	else
	{
		conc.velocity = aim(self.owner, 10000);
		conc.velocity = conc.velocity * 600;
		conc.velocity_z = 200;
	}

	conc.avelocity = '0 0 0';

	conc.angles = vecToAngles(conc.velocity);
	conc.angles_x = 0;
	
	conc.touch = concTouch;
	
	setModel (conc, "progs/weapon_world/w_conc.iqm");
	setSize (conc, '-4 -4 -4', '4 4 4');		
	setOrigin (conc, self.owner.origin);

	conc.effects |= EF_DIMLIGHT;

	remove(self);
}

// this function is called from weapons.qc. it creates a timer entity
// that will keep track of whether or not the conc should be thrown
// and how long it has until it explodes
void primeConc()
{
	local entity timer;

	// if we are in func_restrictmove, dont conc, and reset the
	// test variable.
	if (self.cantConc)
	{
		self.cantConc = 0;
		return;
	}
	
	if (self.holdingGrenade)
		return;

	if (self.throwCount > time)
		return;

	// reset this so we can't spam grenades
	self.throwCount = 0;

	self.holdingGrenade = 1;

	// the timer will check every 0.02 seconds to see if the conc
	// should be thrown or not.
	// if the timer runs out, then the conc will explode
	// on the player.

	timer = spawn();
	timer.classname = "timer";
	timer.owner = self;

	timer.nextthink = time + 0.02;
	timer.countdown = time + 4;
	timer.think = throwConc;
	
	setOrigin(timer, self.origin);

	sound(self, CHAN_AUTO, "objects/timer.wav", 1, ATTN_NORM);
}
