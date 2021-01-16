void CSQC_Ent_Update(float isnew)
{
	local float entType = readbyte();
	local float flags;

	switch(entType)
	{
	case ENT_TRACKER:
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
	case ENT_DAMAGER:
		flags = readbyte();
		self.classname = "damager";
		self.timeLeft = time + 1;
		if (flags & 1)
		{
			self.origin_x = readcoord();
			self.origin_y = readcoord();
			self.origin_z = readcoord();
			self.health = readfloat();
			setorigin(self, self.origin);
		}
		break;
	case ENT_HURT:
		flags = readbyte();
		if (flags & 1)
		{
			self.health = readfloat();
			self.health = -1 * self.health;
			self.health += 200;
			if (self.health < 75)
				self.health = 75;
			if (self.health > 175)
				self.health = 150;
			sound(self, CHAN_AUTO, "ui/hit.wav", 1.0, ATTN_NONE,
				self.health);
		}
		break;
	case ENT_KILL:
		flags = readbyte();
		if (flags & 1)
		{
			sound(self, CHAN_AUTO, "ui/kill.wav", 1.0, ATTN_NONE);
		}
		break;
	default:
		print(ftos(entType));
		print("\n");
		//error("Unknown entity type recieved.");
	}
}

void CSQC_Ent_Remove()
{
	remove(self);
}

