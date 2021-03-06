void trigger_reversegravityTouch()
{
    float newSensitivity;

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

    other.v_angle.z = 180;
    other.view_ofs = '0 0 -64';
    other.velocity += '0 0 27';

    newSensitivity = -1 * cvar("sensitivity");
    if (newSensitivity < 0)
    {
        stuffCmd(other, "sensitivity ");
        stuffCmd(other, ftos(newSensitivity));
        stuffCmd(other, "\n");
    }

    setSize(other, -1 * VEC_HULL_MAX, -1 * VEC_HULL_MIN);

    if (other.reversed == 0)
    {
        other.origin += '0 0 80';
        bprint("setting reversed to ");
        bprint(ftos(time + 0.2));
        bprint(" at time ");
        bprint(ftos(time));
        bprint("\n");
    }
    other.reversed = time + 0.1;

}

void trigger_reversegravity()
{
    initTrigger();
    
    self.touch = trigger_reversegravityTouch;
}
