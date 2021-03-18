void setAngles()
{
    local float viewZ = getviewprop(VF_ORIGIN_Z);
    local float viewPitch = getviewprop(VF_ANGLES_X);
    local float reversed = getstatf(STAT_LG_REVERSED);
    local float reversedGround = getstatf(STAT_LG_REVGND);
    local float wallrunning = getstatf(STAT_LG_WALLRUN);
    local float wallrunSide = getstatf(STAT_LG_WALLSIDE);

    local float rollTarget;
    local float overRollTarget;

    if (reversed != 0)
    {
        localcmd("sensitivity ");
        localcmd(ftos(playerSens * -1));
        localcmd("\n");

        rollTarget = 180;

        if (wallrunning)
        {
            if (wallrunSide == WR_RIGHT)
                overRollTarget = -10;
            else
                overRollTarget = 10;
        }
        else
            overRollTarget = 0;

        if (lastRoll < rollTarget)
            lastRoll += 8;
        if (lastRoll > rollTarget)
            lastRoll = rollTarget;

        if (lastOverRoll < overRollTarget)
            lastOverRoll += 2;
        if (lastOverRoll > overRollTarget)
            lastOverRoll -= 2;

        setviewprop(VF_ANGLES_Z, lastRoll + lastOverRoll);
        lastPitch = viewPitch;
    }
    else
    {
        localcmd("sensitivity ");
        localcmd(ftos(playerSens * 1));
        localcmd("\n");

        if (lastPitch != -1)
        {
            if (lastPitch < 90)
            {
                setviewprop(VF_ANGLES_X, lastPitch);
                lastPitch = -1;
            }
            else
            {
                lastPitch = -1 * (360 - lastPitch) + 0.5;
                setviewprop(VF_ANGLES_X, lastPitch);
                lastPitch = -1;
            }
        }

        if (viewPitch > 89)
        {
            viewPitch = lastUprightPitch;
        }

        rollTarget = 0;

        if (wallrunning)
        {
            if (wallrunSide == WR_RIGHT)
                overRollTarget = -10;
            else
                overRollTarget = 10;
        }
        else
            overRollTarget = 0;

        if (lastRoll > rollTarget)
            lastRoll -= 8;
        if (lastRoll < rollTarget)
            lastRoll = rollTarget;

        if (lastOverRoll < overRollTarget)
            lastOverRoll += 2;
        if (lastOverRoll > overRollTarget)
            lastOverRoll -= 2;

        setviewprop(VF_ANGLES_Z, lastRoll + lastOverRoll);

        lastUprightPitch = getviewprop(VF_ANGLES_X);
    }

    if (reversedGround)
    {
        setviewprop(VF_ORIGIN_Z, viewZ - 16);
    }
    else
    {
    }
}

