// funcs.qc
//
// this file contains the spawn function for function entities 
//
// function entities are brush entities that have some passive effect in
// their borders.
//
// this file is licensed under the GPL v3

// this is the touch function for func_restrictmove, which disallows
// certain kinds of movement in it's volume
void func_restrictmoveTouch()
{

	if (self.restrict_flags & RESTRICT_ROCKET &&
		other.classname == "rocket")
	{
		remove(other);
	}
	else if (self.restrict_flags & RESTRICT_GRENADE &&
		other.classname == "grenade")
	{
		remove(other);
	}
	else if (self.restrict_flags & RESTRICT_TELEGUN &&
		other.classname == "tele_grenade")
	{
		other.owner.grenades--;
		remove(other);
	}
	else if (self.restrict_flags & RESTRICT_CONC &&
		(other.classname == "conc" || other.classname == "timer"))
	{
			remove(other);
	}
	if (other.classname == "player")
	{
		if (self.restrict_flags & RESTRICT_ROCKET)
			other.cantOverload = TRUE;
		if (self.restrict_flags & RESTRICT_CONC)
			other.cantConc = TRUE;
		if (self.restrict_flags & RESTRICT_WALLRUN)
			other.cantWallrun = TRUE;
	}
}

// this is the spawn function for func_restrictmove
void func_restrictmove()
{
	if (!self.restrict_flags)
		self.restrict_flags = RESTRICT_ROCKET +
			RESTRICT_GRENADE +
			RESTRICT_TELEGUN +
			RESTRICT_CONC +
			RESTRICT_WALLRUN;

	initTrigger();

	self.touch = func_restrictmoveTouch;
}
