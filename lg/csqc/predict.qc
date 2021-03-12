void predict()
{
    local float viewZ = getviewprop(VF_ORIGIN_Z);
    local float reversed = getstatf(STAT_LG_REVERSED);
    local float reversedGround = getstatf(STAT_LG_REVGND);

    if (reversed != 0)
    {
        localcmd("sensitivity ");
        localcmd(ftos(playerSens * -1));
        localcmd("\n");
        setviewprop(VF_ANGLES_Z, 180);
    }
    else
    {
        localcmd("sensitivity ");
        localcmd(ftos(playerSens * 1));
        localcmd("\n");
        setviewprop(VF_ANGLES_Z, 0);
    }

    if (reversedGround)
    {
        setviewprop(VF_ORIGIN_Z, viewZ - 16);
    }
    else
    {
    }
}

