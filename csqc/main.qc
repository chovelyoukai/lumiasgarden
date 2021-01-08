float playing;

void CSQC_Init(float apiver, string enginename, float enginever)
{
	drawfont = loadfont("", autocvar(menu_font, "LiberationMono-Regular.ttf"), "12", -1, 0, 0);

	precache_sound("ui/hit.wav");
	precache_sound("ui/kill.wav");
	precache_sound("music/sadness.wav");
	precache_file("gfx/radar.lmp");
	oldStatHurt = getstatf(STAT_LG_HURT);
	oldStatHit = getstatf(STAT_LG_HIT);
	oldStatKill = getstatf(STAT_LG_KILL);
	indicatorTime1 = 0;
	indicatorTime2 = 0;
	
	playing = TRUE;

//	sound(self, CHAN_VOICE, "ui/hit.wav", 1, ATTN_NONE); 
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
	clearscene();

	setviewprop(VF_DRAWENGINESBAR, 0);
	setviewprop(VF_DRAWCROSSHAIR, 1);

	addentities((intermission ? 0 : MASK_VIEWMODEL) | MASK_ENGINE);

	renderscene();

	drawRadar(width, height);

	checkDamage();
	drawDamageIndicator(width, height);

	drawMenu(width, height);

	playSounds();
	if (!playing)
	{
		playMusic();
		playing = TRUE;
	}
};
