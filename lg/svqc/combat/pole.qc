void poleVault()
{
    vector traceDest;
    vector vertVel;
    vector horizVel = self.velocity;
    horizVel.z = 0;

    makeVectors(self.v_angle);
    v_forward.z = 0;
    v_forward = normalize(v_forward);

    traceDest = self.origin + (200 * v_forward);

    if (self.reversed != 0)
        traceDest.z += 400;
    else
        traceDest.z -= 400;

    traceLine(self.origin, traceDest, 0, self);

    if (trace_fraction == 1)
        return;

    if (fabs(trace_plane_normal.z) < 0.4)
        return;

    sound(self, CHAN_WEAPON, "weapons/swing.wav", 0.6, ATTN_NORM);

    vertVel = 600 * trace_plane_normal;

    self.velocity += horizVel * (0.1 + trace_fraction);
    self.velocity += vertVel * (0.1 + (1 - trace_fraction));
}
