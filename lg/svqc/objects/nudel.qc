void spawnNudel(vector spot)
{
	local entity nudel = spawn();

	nudel.classname = "nudel";
	nudel.effects |= EF_FULLBRIGHT;

	nudel.solid = SOLID_NOT;
	nudel.movetype = MOVETYPE_NONE;

	setModel(nudel, "progs/nudel.iqm");
	setSize(nudel, '0 0 0', '0 0 0');

	setOrigin(nudel, spot);

	nudel.basebone = 10;
	nudel.baseframe = 1;
	nudel.frame = 3;
}
