// playeranims.qc
//
// this is where all the player animation functions live.
// each function acts as a player's think function, and defines a
// particular frame of animation to be in, as well as the delay before
// the next think function (which defaults to 0.1) if not specified
//
// this file is licensed under the GPL v3

void swingChovel();
void poleVault();

void() anim_playerRun;

// idle animation
void() anim_playerStand = [self.idlePose, anim_playerStand]
{
	if (self.velocity_x || self.velocity_y)
		anim_playerRun();
}

// running animation
void() anim_playerRun = [self.runPose, anim_playerRun]
{
	if (!self.velocity_x && !self.velocity_y)
		anim_playerStand();
}
// pole swing animations while running
void() anim_playerRunPole4 = [self.runPose, anim_playerRun]
	{self.weaponframe = 0;};
void anim_playerRunPole3()
{
	self.nextthink = time + 0.6;
	self.think = anim_playerRunPole4;
    poleVault();
}
void anim_playerRunPole2()
{
	self.nextthink = time + 0.2;
	self.think = anim_playerRunPole3;
}
void() anim_playerRunPole1 = [self.runAttackPose, anim_playerRunPole2]
	{self.weaponframe = 1;};

// pole swing animations while idle
void() anim_playerIdlePole4 = [self.idlePose, anim_playerStand]
	{self.weaponframe = 0;};
void anim_playerIdlePole3()
{
	self.nextthink = time + 0.6;
	self.think = anim_playerIdlePole4;
	poleVault();
}
void anim_playerIdlePole2()
{
	self.nextthink = time + 0.2;
	self.think = anim_playerIdlePole3;
}
void() anim_playerIdlePole1 = [self.idleAttackPose, anim_playerIdlePole2]
	{self.weaponframe = 1;};

// chovel swing animations while running
void() anim_playerRunChovel4 = [self.runPose, anim_playerRun]
	{self.weaponframe = 0;};
void anim_playerRunChovel3()
{
	self.nextthink = time + 0.15;
	self.think = anim_playerRunChovel4;
	swingChovel();
}
void anim_playerRunChovel2()
{
	self.nextthink = time + 0.05;
	self.think = anim_playerRunChovel3;
}
void() anim_playerRunChovel1 = [self.runAttackPose, anim_playerRunChovel2]
	{self.weaponframe = 1;};

// chovel swing animations while idle
void() anim_playerIdleChovel4 = [self.idlePose, anim_playerStand]
	{self.weaponframe = 0;};
void anim_playerIdleChovel3()
{
	self.nextthink = time + 0.15;
	self.think = anim_playerIdleChovel4;
	swingChovel();
}
void anim_playerIdleChovel2()
{
	self.nextthink = time + 0.05;
	self.think = anim_playerIdleChovel3;
}
void() anim_playerIdleChovel1 = [self.idleAttackPose, anim_playerIdleChovel2]
	{self.weaponframe = 1;};

// generic attack animations
void () anim_playerIdleAttack1 = [self.idleAttackPose, anim_playerIdleAttack2]
{self.weaponframe = 1; self.nextthink = time + 0.5;};
void () anim_playerIdleAttack2 = [self.idlePose, anim_playerStand]
{self.weaponframe = 0; self.nextthink = time + 0.1;};

void () anim_playerRunAttack1 = [self.runAttackPose, anim_playerRunAttack2]
{self.weaponframe = 1; self.nextthink = time + 0.5;};
void () anim_playerRunAttack2 = [self.runPose, anim_playerRun]
{self.weaponframe = 0; self.nextthink = time + 0.1;};

// called from weapons.qc
void anim_playerAttack()
{
	if (self.velocity_x || self.velocity_y)
	{
        if (self.weapon == IT_POLE)
            anim_playerRunPole1();
		else if (self.weapon == IT_CHOVEL)
			anim_playerRunChovel1();
		else
			anim_playerRunAttack1();
	}
	else
	{
        if (self.weapon == IT_POLE)
            anim_playerIdlePole1();
		else if (self.weapon == IT_CHOVEL)
			anim_playerIdleChovel1();
	    else	
			anim_playerIdleAttack1();
	}
}

// sit down animation
void () anim_sitIdle = [POSE_SIT_IDLE, SUB_null] {};
void () anim_sitEnter1 = [POSE_SIT_ENTER, anim_sitEnter2]
{
	thirdpersonOn();
	self.nextthink = time + 0.01;
};
void anim_sitEnter2()
{
	toggleStuck();
	self.nextthink = time + 0.876;
	self.think = anim_sitIdle;
}

// and then stand back up
void () anim_sitLeave1 = [POSE_SIT_LEAVE, anim_sitLeave2]
	{self.nextthink = time + 1.229;};
void () anim_sitLeave2 = [self.idlePose, anim_playerStand]
{
	toggleStuck();
	thirdpersonOff();
};
