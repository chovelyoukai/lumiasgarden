void trigger_reversegravityTouch()
{
    if (other.classname == "grenade" ||
        other.classname == "conc")
    {
        other.velocity += '0 0 27';
    }

    if (other.classname != "player")
        return;

    if (other.flipTime > time)
    {
        return;
    }

    other.view_ofs = '0 0 -64';

    setSize(other, -1 * VEC_HULL_MAX, -1 * VEC_HULL_MIN);

    if (other.reversed == 0)
    {
        other.origin += '0 0 80';
        setModel(other, "progs/lumia_reverse.iqm");
    }
    other.reversed = time + 0.1;

}

void trigger_reversegravity()
{
    initTrigger();
    
    self.touch = trigger_reversegravityTouch;
}
