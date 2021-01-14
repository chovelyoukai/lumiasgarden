// send.qc
//
// this file sends special entities to clients over the network
//
// this file is licensed under the GPL v3

entity spawnTracker(); 

// send the location of a tracker entity so the client can update their
// radar. note the difference bwtween sendFlags and SendFlags
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
	t.SendEntity = trackerSend;
	t.SendFlags |= 1;
	setOrigin(t, self.origin);
	return t;
}
