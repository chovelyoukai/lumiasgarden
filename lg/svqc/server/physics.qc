void calculateFrameTime()
{
    frameTime = time - oldTime;
    oldTime = time;
}

vector stickToGround()
{
    traceLine(self.origin, self.origin + '0 0 1', TRUE, self);

    return trace_endpos;
}

float reversedGround()
{
    traceBox(self.origin + '0 0 -1', -1 * VEC_HULL_MAX,
        -1 * VEC_HULL_MIN, self.origin + '0 0 0.05', 1, self);

    if (trace_fraction < 1)
        return TRUE;

    return FALSE;
}

vector reversedFriction(vector vel)
{
    float sv_friction = cvar("sv_friction");
    float sv_stopspeed = cvar("sv_stopspeed");
    vector newVel;
    float speed, newSpeed, control;

    newVel = vel;
    newVel.z = 0;

    speed = vlen(newVel);

    if (!speed)
        return vel;
    
    if (speed < sv_stopspeed)
        control = sv_stopspeed;
    else
        control = speed;

    newSpeed = speed - (frameTime * control * sv_friction);

    if (newSpeed < 0)
        newSpeed = 0;

    newSpeed /= speed;

    return vel * newSpeed;
}

vector reversedWalk()
{
    vector flatForward;
    vector wishDir;
    float currentSpeed;
    float addSpeed;

    float sv_maxspeed = cvar("sv_maxspeed");
    float sv_accelerate = cvar("sv_accelerate");
    sv_accelerate *= sv_maxspeed;

    flatForward = self.v_angle;
    flatForward.x = 0;
    makeVectors(flatForward);

    wishDir = (input_movevalues.x * v_forward) +
        (input_movevalues.y * v_right);
    wishDir = normalize(wishDir);

    currentSpeed = dotProduct(self.velocity, wishDir);

    addSpeed = sv_maxspeed - currentSpeed;
    if (addSpeed < 0)
        addSpeed = 0;

    if (addSpeed > sv_accelerate * frameTime)
        addSpeed = sv_accelerate * frameTime;

    return self.velocity + (addSpeed * wishDir);
}
