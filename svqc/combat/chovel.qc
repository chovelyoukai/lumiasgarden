void hboxTouch()
{
	if (other == self.owner)
		return;

	if (self.rocketJumpFlag)
	{
		killed(other, self.owner);
	}
	else
	{
		if (other.classname == "player")
			applyDmg(other, self, self.owner, 15);
		remove(self);
	}
}


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

void swingChovel()
{
	spawnHitBox(0);
	spawnHitBox(24);
	spawnHitBox(-24);
}
