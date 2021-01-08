void playerDie();

void ClientKill()
{

}

void ClientConnect()
{
	self.tracker = spawnTracker();
	self.invuln = TRUE;
	self.inMenu = TRUE;
	self.openMenu = MENU_PRIM;
	self.camera = world;
}

void ClientDisconnect()
{

}

entity selectSpawn()
{
	local entity spot, thing;
	local float nearby;

	spot = lastSpawn;

	while (TRUE)
	{
		spot = find(spot, classname, "info_player_start");
		if (spot != world)
		{
			if (spot == lastSpawn)
				return spot;

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

void PutClientInServer()
{
	local entity spawnLocation;

	spawnLocation = selectSpawn();

	if (self.switchWeps)
	{
		self.invuln = TRUE;
		self.inMenu = TRUE;
		self.openMenu = MENU_PRIM;
	}
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

void respawn()
{
	PutClientInServer();
}
