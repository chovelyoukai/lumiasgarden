void initTrigger()
{
	if (self.angles != '0 0 0')
	{
		makeVectors(self.angles);
		self.movedir = v_forward;
		self.angles = '0 0 0';
	}

	self.solid = SOLID_TRIGGER;
	setModel(self, self.model);
	self.movetype = MOVETYPE_NONE;
	self.modelindex = 0;
	self.model = "";
}
