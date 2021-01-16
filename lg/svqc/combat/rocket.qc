// rocket.qc
//
// all the functions required for the best weapon in the game ^H^H^H^H
// ^H^H^H^H the rocket launcher
//
// this file is licensed under the GPL v3

// touch function for the rocket itself
void rocketTouch()
{
	local float damage;
	local float splashDamage;

	// don't explode on the one who fired the rocket
	if (other == self.owner)
		return;

	// disappear into the sky if we hit it
	// note that this requires the sky brush to be textured
	// on all sides.
	if (pointContents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}

	damage = 100;

	// invert damage for the implosion cannon
	if (self.owner.prim == PRIM_IMPLOSION)
		damage *= -1;

	splashDamage = damage * 1.2;

	if (other.health)
		applyDmg(other, self, self.owner, damage);

	// don't do radius damage to other, since it was already
	// done in the impact
	applyRadiusDmg(self, self.owner, splashDamage, other);
	
	// move back eight units so it looks right
	self.origin = self.origin - 8 * normalize(self.velocity);

	// send the temporary explosion entity to client
	writeByte(MSG_BROADCAST, SVC_TEMPENTITY);
	writeByte(MSG_BROADCAST, TE_EXPLOSION);
	writeCoord(MSG_BROADCAST, self.origin_x);
	writeCoord(MSG_BROADCAST, self.origin_y);
	writeCoord(MSG_BROADCAST, self.origin_z);

	becomeExplosion();
}

// the shoot function called from weapons.qc
void fireRocket()
{
	local entity rocket;

	sound(self, CHAN_AUTO, "weapons/fire_rocket.ogg", 0.3, ATTN_NORM);

	// display some visual knockback
	self.punchangle_x = -2;

	rocket = spawn();
	rocket.owner = self;
	rocket.movetype = MOVETYPE_FLYMISSILE;
	rocket.solid = SOLID_BBOX;
	rocket.classname = "rocket";

	//set missile velocity
	makeVectors(self.v_angle);
	rocket.velocity = aim(self, 1000);
	rocket.velocity = rocket.velocity * 1000;
	rocket.angles = vecToAngles(rocket.velocity);

	rocket.touch = rocketTouch;

	rocket.nextthink = time + 5;
	rocket.think = SUB_remove;

	setModel(rocket, "progs/weapon_world/w_rocket.iqm");
	setSize(rocket, '0 0 0', '0 0 0');
	setOrigin(rocket, self.origin + v_forward * 8 + '0 0 32');

	rocket.effects |= EF_MUZZLEFLASH | EF_DIMLIGHT;
}
