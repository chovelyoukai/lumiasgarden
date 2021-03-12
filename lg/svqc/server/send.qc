// send.qc
//
// this file sends special entities to clients over the network
//
// this file is licensed under the GPL v3

entity spawnTracker(); 

// send the location of a tracker entity so the client can update their
// radar. note the difference bwtween sendFlags and SendFlags
float sendTracker(entity to, float sendFlags) 
{
	local float id = ENT_TRACKER;

	if (to == self.owner)
		return FALSE;
	
	writeByte(MSG_ENTITY, id);
	writeByte(MSG_ENTITY, sendFlags);
	if (sendFlags & 1)
	{
		writeCoord(MSG_ENTITY, self.origin_x);
		writeCoord(MSG_ENTITY, self.origin_y);
		writeCoord(MSG_ENTITY, self.origin_z);
	}
	if (sendFlags & 2)
		writeByte(MSG_ENTITY, self.frame);
	if (sendFlags & 128)
		writeByte(MSG_ENTITY, self.modelindex);

	return TRUE;
}

// the tracker think function, which updates every 0.3 seconds
void trackerUpdate()
{
	self.SendFlags |= 1;
	setOrigin(self, self.owner.origin);
	self.nextthink = time + 0.3;
	self.think = trackerUpdate;
}

// this is called when a client connects from server.qc
entity spawnTracker()
{
	local entity t = spawn();
	t.owner = self;
	t.think = trackerUpdate;
	t.nextthink = time + 0.3;
	t.SendEntity = sendTracker;
	t.SendFlags |= 1;
	setOrigin(t, self.origin);
	return t;
}

float sendDamager(entity to, float sendFlags)
{
	local float id = ENT_DAMAGER;

	if (to != self.owner)
		return FALSE;

	writeByte(MSG_ENTITY, id);
	writeByte(MSG_ENTITY, sendFlags);
	if (sendFlags & 1)
	{
		writeCoord(MSG_ENTITY, self.origin_x);
		writeCoord(MSG_ENTITY, self.origin_y);
		writeCoord(MSG_ENTITY, self.origin_z);
		writeFloat(MSG_ENTITY, self.health);
	}

	return TRUE;
}

// this entity keeps track of damage dealt to players
void spawnDamager(entity target, float amount, vector spot)
{
	local entity d = spawn();
	d.owner = target;
	d.think = SUB_remove;
	d.nextthink = time + 1;
	d.SendEntity = sendDamager;
	d.SendFlags |= 1;
	d.health = amount;
	setOrigin(d, spot);
}

float sendHurt(entity to, float sendFlags)
{
	local float id = ENT_HURT;

	if (to != self.owner)
		return FALSE;

	writeByte(MSG_ENTITY, id);
	writeByte(MSG_ENTITY, sendFlags);
	if (sendFlags & 1)
	{
		writeFloat(MSG_ENTITY, self.health);
	}

	return TRUE;
}

// this entity that notifies the attacker of a successful hit
void spawnHurt(entity target, float amount)
{
	local entity d = spawn();
	d.owner = target;
	d.think = SUB_remove;
	d.nextthink = time + 1;
	d.SendEntity = sendHurt;
	d.SendFlags |= 1;
	d.health = amount;
	setOrigin(d, '0 0 0');
}

float sendKill(entity to, float sendFlags)
{
	local float id = ENT_KILL;

	if (to != self.owner)
		return FALSE;

	writeByte(MSG_ENTITY, id);
	writeByte(MSG_ENTITY, sendFlags);

	return TRUE;
}

// this entity notifies players of a successful kill
void spawnKill(entity target)
{
	local entity d = spawn();
	d.owner = target;
	d.think = SUB_remove;
	d.nextthink = time + 1;
	d.SendEntity = sendKill;
	d.SendFlags |= 1;
	setOrigin(d, '0 0 0');
}

float sendGrapple(entity to, float sendFlags)
{
	local float id = ENT_GRAPPLE;

	writeByte(MSG_ENTITY, id);
	writeByte(MSG_ENTITY, sendFlags);
	if (sendFlags & 1)
	{
		writeCoord(MSG_ENTITY, self.origin.x);
		writeCoord(MSG_ENTITY, self.origin.y);
		writeCoord(MSG_ENTITY, self.origin.z);
        writeCoord(MSG_ENTITY, self.owner.origin.x);
        writeCoord(MSG_ENTITY, self.owner.origin.y);
        writeCoord(MSG_ENTITY, self.owner.origin.z);
	}

	return TRUE;
}
