void updateCamera()
{
	local vector camOrg;

	makeVectors(self.owner.v_angle);

	traceLine(self.owner.origin + self.owner.view_ofs,
		self.owner.origin + (self.owner.view_ofs) +
		(v_forward * -64) + (v_up * -32), TRUE, self);

	camOrg_x = trace_endpos_x;
	camOrg_y = trace_endpos_y;
	camOrg_z = trace_endpos_z;
	camOrg += trace_plane_normal;

	setOrigin(self, camOrg);

	self.nextthink = time + 0.005;
}

void setViewPoint(entity spot)
{
	msg_entity = self;
	writeByte(1, SVC_SETVIEW);
	writeEntity(1, spot);
}

void thirdpersonOn()
{
	local entity cam;

	cam = spawn();
	cam.classname = "camera";
	cam.movetype = MOVETYPE_NONE;
	cam.solid = SOLID_NOT;
	cam.think = updateCamera;
	cam.owner = self;
	cam.nextthink = time + 0.015;
	setSize(cam, '0 0 0', '0 0 0');
	self.camera = cam;
	updateCamera();
	setViewPoint(cam);
	stuffCmd(self, "r_drawviewmodel 0\n");
}

void thirdpersonOff()
{
	setViewPoint(self);
	remove(self.camera);
	self.camera = world;
	stuffCmd(self, "r_drawviewmodel 1\n");
}

void thirdpersonToggle()
{
	// self.camera is set to world when there is no camera.
	if (self.camera == world)
		thirdpersonOn();
	else
		thirdpersonOff();
}

void toggleStuck()
{
	if (!self.stuck)
	{
		self.movetype = MOVETYPE_NONE;
		self.stuck = TRUE;
	}
	else
	{
		self.movetype = MOVETYPE_WALK;
		self.stuck = FALSE;
	}
}