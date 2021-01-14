// combat.qc
//
// handle basic combat functions shared by all weapons
//
// this file is licensed under the GPL v3

// used to check if attacker can actually hit target
// with splash damage
float canDamage(entity target, entity inflictor)
{
	// bmodels need special checks because their origin is '0 0 0'
	if (target.movetype == MOVETYPE_PUSH)
	{
		traceLine(inflictor.origin, 0.5 * (target.absmin +
			target.absmax), TRUE, self);
		if (trace_fraction == 1)
			return TRUE;
		if (trace_ent == target)
			return TRUE;
		return FALSE;
	}

	traceLine(inflictor.origin, target.origin, TRUE, self);
	if (trace_fraction == 1)
		return TRUE;
	
	traceLine(inflictor.origin, target.origin + '15 15 0',
		TRUE, self);
	if (trace_fraction == 1)
		return TRUE;
	traceLine(inflictor.origin, target.origin + '-15 -15 0',
		TRUE, self);
	if (trace_fraction == 1)
		return TRUE;
	traceLine(inflictor.origin, target.origin + '-15 15 0',
		TRUE, self);
	if (trace_fraction == 1)
		return TRUE;
	traceLine(inflictor.origin, target.origin + '15 -15 0',
		TRUE, self);
	if (trace_fraction == 1)
		return TRUE;

	return FALSE;
}

// called when something is killed
void killed(entity target, entity attacker)
{
	local entity oldSelf, grenade;

	// can only kill players
	if (target.classname != "player")
		return;

	oldSelf = self;
	self = target;

	// all grenades disappear on death
	self.grenades = 0;

	grenade = world;
	grenade = nextEnt(grenade);

	while (grenade)
	{
		if (grenade.classname == "grenade" && grenade.owner == self)
			remove(grenade);

		grenade = nextEnt(grenade);
	}

	// any grapple hooks disappear as well
	self.grappled = FALSE;
	if (self.grapple != world)
		remove(self.grapple);

	self.takedamage = DAMAGE_NO;
	self.touch = SUB_null;
	self.thinkDie();

	self = oldSelf;
}

// add the velocity gained from taking damage (knockback)
void addVelocity(entity target, entity inflictor, entity attacker,
	float damage)
{
	local vector dir;
	local float mult;
	mult = 0;

	// TODO: re-add props
	if ((inflictor != world) && target.movetype == MOVETYPE_WALK)
	{
		dir = target.origin -
			(inflictor.absmin + inflictor.absmax) * 0.5;

		dir = normalize(dir);

		// if we're launching ourselves while midair, give
		// an extra boost
		if (!(self.flags & FL_ONGROUND) && target == attacker)
			mult = 14.5;
		else
			mult = 7;

		// grenades cause no knockback to enemies
		if (inflictor.classname == "grenade" && target != attacker)
			mult = 0;

		// TODO: investigate the pushBall shenanigans
		// do extra boost to the ball in KADM
		if (target.classname == "ball")
			mult = 14;
		
		target.velocity = target.velocity + dir * damage * mult;
	}
}

// apply damage to an enemy (does not affect health at all)
// target is the victim, inflictor is the weapon, and attacker is the
// source of the attack
void applyDmg(entity target, entity inflictor, entity attacker,
	float damage)
{
	if (!target.takedamage)
		return;
	
	// TODO: apparently this is needed for doors and whatnot,
	// please fix
	//damage_attacker = attacker;

	addVelocity(target, inflictor, attacker, damage);

	if (target.stat_hurt < 1)
		target.stat_hurt = 1;
	else
		target.stat_hurt = 0;

	target.stat_damage = ceil(damage);

	target.rocketJumpFlag = TRUE;

	// TODO: investigate if this is necessary
	/*
	oldself = self;
	self = targ;

	if (self.thinkPain);
		self.thinkPain(attacker, take);

	self = oldself;
	*/
}

// do damage to anything in a particular range
void applyRadiusDmg(entity inflictor, entity attacker, float damage,
	entity ignore)
{
	local float points;
	local entity head;
	local vector org;

	head = findRadius(inflictor.origin, fabs(damage) + 70);

	while (head)
	{
		if ((head == ignore) || (!head.takedamage))
		{
			head = head.chain;
			continue;
		}

		org = head.origin + (head.mins + head.maxs) * 0.5;
		// TODO: replace magic number 0.3 with a define
		points = 0.3 * vlen(inflictor.origin - org);

		if (points < 0)
			points = 0;

		points = fabs(damage) - points;

		if (head == attacker)
			points = points * 0.5;

		if ((points > 0) && canDamage(head, inflictor))
		{
			// extra knockback from grenades
			if (head.classname == "player" && 
				inflictor.classname == "grenade")
			{
				points = points * 1.5;
			}

			// scale properly for implosion cannon
			if (damage < 0)
				points *= -1;

			applyDmg(head, inflictor, attacker, points);
		}

		head = head.chain;
	}
}
