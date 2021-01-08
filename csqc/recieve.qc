void CSQC_Ent_Update(float isnew)
{
	local float entType = readbyte();
	local float flags;

	switch(entType)
	{
	case 1:
		flags = readbyte();
		if (flags & 1)
		{
			self.origin_x = readcoord();
			self.origin_y = readcoord();
			self.origin_z = readcoord();
			setorigin(self, self.origin);
		}
		if (flags & 2)
			self.frame = readbyte();
		if (flags & 128)
		{
			self.modelindex = readbyte();
			self.drawmask = MASK_ENGINE;
		}
		if (isnew)
		{
			self.classname = "tracker";
			self.tdone = "0";
			self.drawmask = MASK_ENGINE;
		}
		break;
	default:
		error("Unknown entity type recieved.");
	}
}

void CSQC_Ent_Remove()
{
	remove(self);
}

