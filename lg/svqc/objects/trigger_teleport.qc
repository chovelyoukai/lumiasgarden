void info_teleport_destination()
{
}

void trigger_teleportTouch()
{
    local entity dest;

    if (other.classname != "player")
        return;

    dest = find(world, targetname, self.target);

    if (dest)
    {
        setOrigin(other, dest.origin);
        other.velocity = '0 0 0';
        other.v_angle = dest.angles;
    }
}

void trigger_teleport()
{
    initTrigger();

    self.touch = trigger_teleportTouch;
}
