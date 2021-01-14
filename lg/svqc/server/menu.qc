// menu.qc
//
// this handles the input from the client for the weapon select menus 
//
// this file is licensed under the GPL v3

// this function is called from weapons.qc if the player is currently
// in a menu
void menuInput(float input)
{
	if (self.openMenu == MENU_PRIM)
	{
		if (input > 0 && input < 4)
		{
			self.prim = input;
			self.openMenu = MENU_SEC;
		}
	}
	else if (self.openMenu == MENU_SEC)
	{
		if (input > 0 && input < 4)
		{
			self.sec = input;
			self.inMenu = FALSE;

			// if the player was invulnerable, make them not
			if (self.invuln)
			{
				self.takedamage = DAMAGE_AIM;
				self.solid = SOLID_SLIDEBOX;
				self.movetype = MOVETYPE_WALK;
				self.switchWeps = FALSE;
				self.invuln = FALSE;
			}
		}
	}
}
