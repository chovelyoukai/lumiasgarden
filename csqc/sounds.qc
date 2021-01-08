float oldStatHit;
float oldStatKill;

void() playSounds =
{
	local float newStatHit = getstatf(STAT_LG_HIT);
	local float newStatKill = getstatf(STAT_LG_KILL);
	local string soundFile = "NO";

	if (newStatHit != oldStatHit)
	{
		soundFile = "ui/hit.wav";
		oldStatHit = newStatHit;
	}
	if (newStatKill != oldStatKill)
	{
		soundFile = "ui/kill.wav";
		oldStatKill = newStatKill;
	}
	if (soundFile != "NO")
	{
		sound(self, CHAN_VOICE, soundFile, 1, ATTN_NONE);
	}
};
