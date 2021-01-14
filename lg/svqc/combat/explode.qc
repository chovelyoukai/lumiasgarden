// explode.qc
//
// the explosion function used by many different weapons
//
// this file is licensed under the GPL v3

// explosion animations
void animExplode1() = [0, animExplode2] {};
void animExplode2() = [1, animExplode3] {};
void animExplode3() = [2, animExplode4] {};
void animExplode4() = [3, animExplode5] {};
void animExplode5() = [4, animExplode6] {};
void animExplode6() = [5, SUB_remove] {}; 

// self becomes an explosion (doesn't deal damage)
void becomeExplosion()
{
	self.movetype = MOVETYPE_NONE;
	self.velocity = '0 0 0';
	self.touch = SUB_null;
	setModel(self, "");
	self.solid = SOLID_NOT;
	animExplode1();
}
