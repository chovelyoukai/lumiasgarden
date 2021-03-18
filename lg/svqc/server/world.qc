// world.qc
//
// this file contains the spawn function for the world, all the
// asset precaches, and light style information
//
// this file is licensed under the GPL v3

// keeps track of the last spawn used
entity lastSpawn;

// this is required by the engine but it doesn't do anything
void main()
{

}

// load all the models before they are used
void precacheModels()
{
	precache_model("progs/weapon_world/w_conc.iqm");
	precache_model("progs/weapon_world/w_grenade.iqm");
	precache_model("progs/weapon_world/w_rocket.iqm");
	precache_model("progs/weapon_world/w_spike.iqm");
	precache_model("progs/weapon_views/v_grenade.iqm");
	precache_model("progs/weapon_views/v_rocket.iqm");
	precache_model("progs/player.iqm");
	precache_model("progs/lumia.iqm");
	precache_model("progs/lumia_reverse.iqm");

}

// load all the sounds so they are used
void precacheSounds()
{
	precache_sound("objects/timer.wav");
	precache_sound("ui/slap.wav");
	precache_sound("ui/wallattach.wav");
	precache_sound("weapons/bounce.ogg");
	precache_sound("weapons/click.ogg");
	precache_sound("weapons/cork.wav");
	precache_sound("weapons/explosion2.ogg");
	precache_sound("weapons/fire_grenade.ogg");
	precache_sound("weapons/fire_rocket.ogg");
	precache_sound("weapons/hollow_boom.wav");
	precache_sound("weapons/r_exp3.wav");
	precache_sound("weapons/swing.wav");
}

// this is the spawn function for the world itself
void worldspawn()
{
	precacheModels();
	precacheSounds();
	
	//
	// Setup light animation tables. 'a' is total darkness, 'z' is maxbright
	//

	// 0 normal
	lightStyle(0, "m");
	
	// 1 FLICKER (first variety)
	lightStyle(1, "mmnmmommommnonmmonqnmmo");
	
	// 2 SLOW STRONG PULSE
	lightStyle(2, "abcdefghijklmnopqrstuvwxyzyxwvutsrqponmlkjihgfedcba");
	
	// 3 CANDLE (first variety)
	lightStyle(3, "mmmmmaaaaammmmmaaaaaabcdefgabcdefg");
	
	// 4 FAST STROBE
	lightStyle(4, "mamamamamama");
	
	// 5 GENTLE PULSE 1
	lightStyle(5,"jklmnopqrstuvwxyzyxwvutsrqponmlkj");
	
	// 6 FLICKER (second variety)
	lightStyle(6, "nmonqnmomnmomomno");
	
	// 7 CANDLE (second variety)
	lightStyle(7, "mmmaaaabcdefgmmmmaaaammmaamm");
	
	// 8 CANDLE (third variety)
	lightStyle(8, "mmmaaammmaaammmabcdefaaaammmmabcdefmmmaaaa");
	
	// 9 SLOW STROBE (fourth variety)
	lightStyle(9, "aaaaaaaazzzzzzzz");
	
	// 10 FLUORESCENT FLICKER
	lightStyle(10, "mmamammmmammamamaaamammma");

	// 11 SLOW PULSE NOT FADE TO BLACK
	lightStyle(11, "abcdefghijklmnopqrrqponmlkjihgfedcba");
	
	// styles 32-62 are assigned by the light program for switchable lights

	// 63 testing
	lightStyle(63, "a");

	// Initialize LG stats
	clientStat(STAT_LG_HURT, EV_FLOAT, stat_hurt);
	clientStat(STAT_LG_DAMAGE, EV_FLOAT, stat_damage);
	clientStat(STAT_LG_HIT, EV_FLOAT, stat_hit);
	clientStat(STAT_LG_KILL, EV_FLOAT, stat_kill);
	clientStat(STAT_LG_PX, EV_FLOAT, origin_x);
	clientStat(STAT_LG_PY, EV_FLOAT, origin_y);
	clientStat(STAT_LG_PZ, EV_FLOAT, origin_z);
	clientStat(STAT_LG_PP, EV_FLOAT, v_angle_y);
	clientStat(STAT_LG_IN_MENU, EV_FLOAT, inMenu);
	clientStat(STAT_LG_OPEN_MENU, EV_FLOAT, openMenu);
	clientStat(STAT_LG_LOOK_NAME, EV_STRING, lookName);
	clientStat(STAT_LG_REVERSED, EV_FLOAT, reversed);
	clientStat(STAT_LG_REVGND, EV_FLOAT, reverseGround);
	clientStat(STAT_LG_WALLRUN, EV_FLOAT, wallrunning);
	clientStat(STAT_LG_WALLSIDE, EV_FLOAT, wallrunSide);
	//clientStat(STAT_LG_TELE_TIME, EV_FLOAT, stat_tele_time);
}

// the following 3 functions are required by the engine but are not used
// in this game
void SetNewParms()
{

}

void SetChangeParms()
{

}

void StartFrame()
{

}
