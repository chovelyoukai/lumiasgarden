// chovel.qc
//
// all the functions required for the chovel weapon
//
// this file is licensed under the GPL v3

// touch function for damaging hitboxes
void hboxTouch()
{
	if (other == self.owner)
		return;

	// only kill if spawned during explosive jump
	if (self.rocketJumpFlag)
	{
		killed(other, self.owner);
	}
	// otherwise a little knockback
	else
	{
		if (other.classname == "player")
			applyDmg(other, self, self.owner, 15);
		remove(self);
	}
}

// spawn a damaging hitbox at some rightward distance from self
void spawnHitBox(float distance)
{
	local entity hbox;
	local vector newOrigin;

	makeVectors(self.v_angle);

	newOrigin = self.origin + (v_forward * 32) + (v_right * distance);

	hbox = spawn();
	hbox.movetype = MOVETYPE_NOCLIP;
	hbox.solid = SOLID_TRIGGER;
	hbox.classname = "trigger_hitbox";
	hbox.takedamage = FALSE;
	hbox.touch = hboxTouch;
	hbox.owner = self;
	hbox.velocity = self.velocity;
	hbox.angles = self.v_angle;
	hbox.nextthink = time + 0.1;
	hbox.think = SUB_remove;
	hbox.rocketJumpFlag = self.rocketJumpFlag;

	setSize(hbox, '-12 -12 -12', '12 12 12');
	setOrigin(hbox, newOrigin);
}

// chovel attack function, called during the animations in 
// playeranims.qc
void swingChovel()
{
	spawnHitBox(0);
	spawnHitBox(24);
	spawnHitBox(-24);
}
