// overload.qc
//
// all the functions required for the overloader weapon
//
// this file is licensed under the GPL v3

// this function is used for when the overloader overloads, causing
// an explosion on the player that pushes them around
void() overloadExplode =
{
	local float	damg;
	local entity oldself, explosion;
	local vector newOrigin;

	explosion = spawn();
	explosion.classname = "missile";

	makeVectors(self.v_angle);
	newOrigin = self.origin + (64 * v_forward) + (16 * v_right);

	setOrigin(explosion, newOrigin);

	damg = 45;
	
	applyDmg(self, explosion, self, damg );

	sound(self, CHAN_WEAPON, "weapons/r_exp3.wav", 1, ATTN_NORM);

	oldself = self;
	self = explosion;
	becomeExplosion();
	self = oldself;
};

// this is the function called from weapons.qc
// the actual shooting of rockets is handled in weapons.qc
// TODO: move the weapons.qc code into a dedicated function in here
void fireOverload()
{
	// can't load while currently firing.
	if (self.spewing)
		return;
	
	sound (self, CHAN_WEAPON, "weapons/cork.wav", 0.3, ATTN_NORM);

	self.punchangle_x = -2;
	
	self.overloaded++;

	if (self.overloaded > 6)
		self.overloaded = 1;

	if (self.overloaded > 3 && !self.cantOverload)
		overloadExplode();
		
};
