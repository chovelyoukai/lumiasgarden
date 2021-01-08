entity spawnTracker(); 

float trackerSend(entity to, float sendFlags) 
{
	local float id = 1;

	if (to == self.owner)
		return FALSE;
	
	//bprint("sending\n");
	//if (self.owner.deadflag != DEAD_NO)
	//	return FALSE;

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

// something is broken in the engine I think, so every update we
// will just spawn a new tracker and remove the old one.
void trackerUpdate()
{
	//entity oldSelf;

	//oldSelf = self;
	//self = self.owner;
	//self.tracker = spawnTracker();
	//self = oldSelf;
	//remove(self);

	self.SendFlags |= 1;
	setOrigin(self, self.owner.origin);
	self.nextthink = time + 0.3;
	self.think = trackerUpdate;
}

entity spawnTracker()
{
	local entity t = spawn();
	t.owner = self;
	t.think = trackerUpdate;
	t.nextthink = time + 0.3;
	t.SendEntity = trackerSend;
	t.SendFlags |= 1;
	setOrigin(t, self.origin);
	return t;
}
