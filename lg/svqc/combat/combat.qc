// combat.qc
//
// handle basic combat functions shared by all weapons
//
// this file is licensed under the GPL v3

// print a death message
void obituary(string killed, string killer)
{
	local float msgNum = random() * 100;
	bprint(killer);
	if (killer != killed)
	{
		if (msgNum > 80)
			bprint(" choveled ");
		else if (msgNum > 60)
			bprint(" gicced ");
		else if (msgNum > 40)
			bprint(" gardened ");
		else if (msgNum > 20)
			bprint(" spooned ");
		else
			bprint(" freezeglitched ");
		bprint(killed);
	}
	else
	{
		if (msgNum > 80)
			bprint(" gave it all up");
		else if (msgNum > 60)
			bprint(" strategically retreated fatally");
		else if (msgNum > 40)
			bprint(" bid farewell, cruel world");
		else if (msgNum > 20)
			bprint(" has had enough of you guys");
		else
			bprint(" choveled themselves");
	}

	bprint(".\n");
}

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
	
	if (target != attacker)
		spawnKill(attacker);

	obituary(target.netname, attacker.netname);
}

// add the velocity gained from taking damage (knockback)
void addVelocity(entity target, entity inflictor, entity attacker,
	float damage)
{
	local vector dir;
	local float mult;
	mult = 0;

    if (globalMode == MODE_TRICKJUMP && target != attacker)
    {
        return;
    }

	// TODO: re-add props
	if ((inflictor != world) && target.movetype == MOVETYPE_WALK)
	{
		dir = (target.origin + (target.mins + target.maxs) * 0.5) -
			(inflictor.absmin + inflictor.absmax) * 0.5;

		dir = normalize(dir);

		// if we're launching ourselves while midair, give
		// an extra boost
		if (!(self.flags & FL_ONGROUND) && target == attacker)
			mult = 15.2;
		else
			mult = 7.455;

        if (inflictor.classname == "grenade")
            mult = 10.063;

		// grenades cause no knockback to enemies
		if (inflictor.classname == "grenade" && target != attacker)
			mult = 0;

		// TODO: investigate the pushBall shenanigans
		// do extra boost to the ball in KADM
		if (target.classname == "ball")
			mult = 14;
		
		target.velocity = target.velocity + (dir * damage * mult);
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

	if (target.classname == "player")
	{
		spawnDamager(target, damage, inflictor.origin);
		if (target != attacker)
			spawnHurt(attacker, damage);
	}
}

// do damage to anything in a particular range
void applyRadiusDmg(entity inflictor, entity attacker, float damage,
	entity ignore, float radius)
{
	local float distance;
	local entity head;
	local vector center, org, closest;

	head = findRadius(inflictor.origin, radius);

	while (head)
	{
		if ((head == ignore) || (!head.takedamage))
		{
			head = head.chain;
			continue;
		}

        if (!canDamage(head, inflictor))
        {
            head = head.chain;
            continue;
        }

        center = head.origin + (head.mins + head.maxs) * 0.5;
        org = head.origin;

        if (vlen(head.origin - inflictor.origin) <
            vlen(center - inflictor.origin))
        {
            closest = head.origin;
        }
        else
        {
            closest = center;
        }

        distance = vlen(closest - inflictor.origin);

        damage = (damage * (0.5 - 1) * distance / 121) + damage;

        if (head == attacker && !(head.flags & FL_ONGROUND))
            damage *= 0.6;
        else
            damage *= 0.5;

        applyDmg(head, inflictor, attacker, damage);

		head = head.chain;
	}
}
