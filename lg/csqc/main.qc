float playing;

void CSQC_Init(float apiver, string enginename, float enginever)
{
	drawfont = loadfont("", autocvar(menu_font, "LiberationMono-Regular.ttf"), "12", -1, 0, 0);

	precache_sound("ui/hit.wav");
	precache_sound("ui/kill.wav");
	precache_sound("music/sadness.wav");
    precache_model("progs/weapon_world/w_spike.iqm");
	precache_file("gfx/radar.lmp");
	
	playing = TRUE;
    
    lastRoll = 0;
    lastOverRoll = 0;
    lastPitch = -1;

	return;
}

float CSQC_InputEvent(float evtype, float scanx, float chary,
	float devid)
{
	return FALSE;
}

float CSQC_ConsoleCommand(string cmd)
{
	return FALSE;
}

void CSQC_UpdateView(float width, float height, float menushown)
{
    local float shouldDrawRadar = cvar("cl_drawradar");

    playerSens = cvar("cl_sense");
	
    clearscene();

	setviewprop(VF_DRAWENGINESBAR, 0);
	setviewprop(VF_DRAWCROSSHAIR, 1);

	addentities((intermission ? 0 : MASK_VIEWMODEL) | MASK_ENGINE);

    drawGrapples();
    
    setAngles();

	renderscene();

    if (shouldDrawRadar != 0)
	    drawRadar(width, height);

	drawDamageIndicator(width, height);

	drawMenu(width, height);

	drawCrosshairString(width, height);

	if (!playing)
	{
		playMusic();
		playing = TRUE;
	}
}
