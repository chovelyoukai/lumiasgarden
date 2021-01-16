// server.qc
//
// the server connect and disconnect functions are in this file 
//
// this file is licensed under the GPL v3

void playerDie();

// ?
void ClientKill()
{

}

// called when a player connects 
void ClientConnect()
{
	// give them a radar tracker
	self.tracker = spawnTracker();
	// open the weapon select menu
	self.invuln = TRUE;
	self.inMenu = TRUE;
	self.openMenu = MENU_PRIM;
	// set their camera to world so they are in first person
	self.camera = world;
	// print join message
	bprint(self.netname);
	bprint(" has connected.\n");

	stuffCmd(self, "exec configs/particles/lg_particles.cfg\n");
}

void ClientDisconnect()
{
	local entity grenade;

	remove(self.tracker);

	grenade = world;
	grenade = nextEnt(grenade);
	while(grenade)
	{
		if (grenade.classname == "grenade" && grenade.owner == self)
			remove(grenade);

		grenade = nextEnt(grenade);
	}

	if (self.grapple != world)
		remove(self.grapple);
}

// choose a spawn point to put the player at
entity selectSpawn()
{
	local entity spot, thing;
	local float nearby;

	// set our spot to lastSpawn so we don't select it initially
	spot = lastSpawn;

	while (TRUE)
	{
		spot = find(spot, classname, "info_player_start");
		if (spot != world)
		{
			// if the only spot we can use is lastSpawn, use it
			if (spot == lastSpawn)
				return spot;

			// try to find a spot without many players near it
			nearby = 0;
			thing = findRadius(spot.origin, 32);
			
			while (thing)
			{
				if (thing.classname == "player")
					nearby++;
				thing = thing.chain;
			}

			if (nearby == 0)
			{
				lastSpawn = spot;
				return spot;
			}
		}
	}

	return spot;
}

// called when a player connects and when a player spawns
void PutClientInServer()
{
	local entity spawnLocation;

	spawnLocation = selectSpawn();

	// if on the last life we wanted to change weapons, put us in the
	// menu to do so
	if (self.switchWeps)
	{
		self.invuln = TRUE;
		self.inMenu = TRUE;
		self.openMenu = MENU_PRIM;
	}
	// if we are invulnerable due to being in a menu, freeze us in place
	// and make us unhittable
	if (self.invuln)
	{
		self.takedamage = DAMAGE_NO;
		self.solid = SOLID_NOT;
		self.movetype = MOVETYPE_NONE;
	}
	else
	{
		self.takedamage = DAMAGE_AIM;
		self.solid = SOLID_SLIDEBOX;
		self.movetype = MOVETYPE_WALK;
	}

	self.classname = "player";
	self.health = self.max_health = 100;
	self.flags = FL_CLIENT;
	self.weapon = IT_ROCKET_LAUNCHER;
	self.weaponmodel = "progs/weapon_views/v_rocket.iqm";
	self.thinkDie = playerDie;
	self.rocketJumpFlag = TRUE;
	self.effects |= EF_FULLBRIGHT;

	// set initial animations for the rocket launcher
	self.idlePose = POSE_RL_IDLE;
	self.runPose = POSE_RL_RUN;
	self.idleAttackPose = POSE_RL_IDLE_ATT;
	self.runAttackPose = POSE_RL_RUN_ATT;

	self.grappled = FALSE;
	self.grapple = world;

	setModel(self, "progs/player.iqm");
	setSize(self, VEC_HULL_MIN, VEC_HULL_MAX);
	// this is the offset **relative** to the player's origin that
	// the camera view should be placed at.
	self.view_ofs = '0 0 32';
	self.velocity = '0 0 0';

	self.angles = spawnLocation.angles;
	self.fixangle = TRUE; // immediately update angles
	setOrigin(self, spawnLocation.origin + '0 0 1');

	anim_playerStand();
}

// called after a player dies
void respawn()
{
	PutClientInServer();
}
