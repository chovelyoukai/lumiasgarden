void drawRibbon(vector start, vector end)
{
    R_BeginPolygon("colours/grapplerope.png");
    R_PolygonVertex(start, '0 0 0', '1 1 1', 1);
    R_PolygonVertex(end, '0 1 0', '1 1 1', 1);
    R_EndPolygonRibbon(3, '0 0 0');
}

void drawGrapples()
{
    local entity grapple;

    grapple = world;
    grapple = nextent(world);

    while (grapple)
    {
        if (grapple.classname == "hook")
        {
            drawRibbon(grapple.origin, grapple.ownerPos);
        }

        grapple = nextent(grapple);
    }
}
