void playerLook()
{
	makeVectors(self.v_angle);

	traceLine(self.origin + self.view_ofs, v_forward * 10000, 0, self);

	if (trace_ent.classname == "player")
		self.lookName = trace_ent.classname;
	else
		self.lookName = "";
}
