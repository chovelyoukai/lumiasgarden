float scale = 0;
float force;
vector newVelocity;

if (inflictor.classname == "missile")
{
    if (self.flags & FL_ONGROUND)
    {
        scale = GROUND_FORCE_SCALE;
    }
    else
    {
        scale = AIR_FORCE_SCALE;
    }

    scale *= 82 / 55;
}

force = damage * scale;

newVelocity = normalize(self.origin - inflictor.origin) * force;

self.velocity += newVelocity;
