const float STAT_LG_HURT = 32;
const float STAT_LG_DAMAGE = 33;
const float STAT_LG_HIT = 34;
const float STAT_LG_KILL = 35;
const float STAT_LG_PX = 36;
const float STAT_LG_PY = 37;
const float STAT_LG_PZ = 38;
const float STAT_LG_PP = 39;
const float STAT_LG_IN_MENU = 40;
const float STAT_LG_OPEN_MENU = 41;
const float STAT_LG_LOOK_NAME = 42;
const float TWOPI360 = 0.01745329;
const float ONEHALFPI = 1.570796327;

const float ENT_TRACKER = 1;
const float ENT_DAMAGER = 2;
const float ENT_HURT    = 3;
const float ENT_KILL    = 4;

const float MENU_PRIM = 0;
const float MENU_SEC = 1;

// tracker done
.string tdone;

.float timeLeft;
.float health;

void (entity e) stopSound = #106;
