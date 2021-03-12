// thirdperson.qc
//
// the server connect and disconnect functions are in this file 
//
// this file is licensed under the GPL v3

// the camera think function that makes it follow the player
void updateCamera()
{
	local vector camOrg;

	makeVectors(self.owner.v_angle);

	// go back as far as we can without hitting anything
    if (self.reversed > time)
    {
	    traceLine(self.owner.origin + self.owner.view_ofs,
	    	self.owner.origin + (self.owner.view_ofs) -
	    	(v_forward * TP_BACK * 300), TRUE, self.owner);
    }
    else
    {
	    traceLine(self.owner.origin + self.owner.view_ofs,
	    	self.owner.origin + (self.owner.view_ofs) +
	    	(v_forward * TP_BACK), TRUE, self.owner);
    }

	camOrg_x = trace_endpos_x;
	camOrg_y = trace_endpos_y;
    if (self.owner.reversed > time)
    {
	    camOrg_z = trace_endpos_z + 64;
        camOrg -= trace_plane_normal;
    }
    else
    {
	    camOrg_z = trace_endpos_z - 64;
        camOrg += trace_plane_normal;
	}

	setOrigin(self, camOrg);

	self.nextthink = time + 0.015;
}

// this function sets the player view at the given entity
void setViewPoint(entity spot)
{
	msg_entity = self;
	writeByte(1, SVC_SETVIEW);
	writeEntity(1, spot);
}

// this function spawns a camera entity and sets it to our view point
void thirdpersonOn()
{
    local entity oldSelf;
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
    
    oldSelf = self;
    self = cam;
	updateCamera();
    self = oldSelf;
	setViewPoint(cam);
	stuffCmd(self, "r_drawviewmodel 0\n");
}

// this function deletes the camera and puts us back in our own body
void thirdpersonOff()
{
	setViewPoint(self);
	remove(self.camera);
	self.camera = world;
	stuffCmd(self, "r_drawviewmodel 1\n");
}

// this function toggles between third and first person
void thirdpersonToggle()
{
	// self.camera is set to world when there is no camera.
	if (self.camera == world)
		thirdpersonOn();
	else
		thirdpersonOff();
}

// this function changes whether or not we are stuck, as in while
// sitting
void toggleStuck()
{
	if (!self.stuck)
	{
        self.angles = '0 0 0';
		self.movetype = MOVETYPE_NONE;
		self.stuck = TRUE;
	}
	else
	{
		self.movetype = MOVETYPE_WALK;
		self.stuck = FALSE;
	}
}
