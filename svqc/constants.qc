const float FALSE = 0;
const float TRUE  = 1;

const float FL_FLY           = 1;
const float FL_SWIM          = 2;
const float FL_CLIENT        = 8;
const float FL_INWATER       = 16;
const float FL_MONSTER       = 32;
const float FL_GODMODE       = 64;
const float FL_NOTARGET      = 128;
const float FL_ITEM          = 256;
const float FL_ONGROUND      = 512;
const float FL_PARTIALGROUND = 1024;
const float FL_WATERJUMP     = 2048;
const float FL_JUMPRELEASED  = 4096;

const float MOVETYPE_NONE          = 0;
const float MOVETYPE_WALK          = 3;
const float MOVETYPE_STEP          = 4;
const float MOVETYPE_FLY           = 5;
const float MOVETYPE_TOSS          = 6;
const float MOVETYPE_PUSH          = 7;
const float MOVETYPE_NOCLIP        = 8;
const float MOVETYPE_FLYMISSILE    = 9;
const float MOVETYPE_BOUNCE        = 10;
const float MOVETYPE_BOUNCEMISSILE = 11;

const float SOLID_NOT      = 0;
const float SOLID_TRIGGER  = 1;
const float SOLID_BBOX     = 2;
const float SOLID_SLIDEBOX = 3;
const float SOLID_BSP      = 4;

const float RANGE_MELEE = 0;
const float RANGE_NEAR  = 1;
const float RANGE_MID   = 2;
const float RANGE_FAR   = 3;

const float DEAD_NO          = 0;
const float DEAD_DYING       = 1;
const float DEAD_DEAD        = 2;
const float DEAD_RESPAWNABLE = 3;

const float DAMAGE_NO  = 0;
const float DAMAGE_YES = 1;
const float DAMAGE_AIM = 2;

const float CONTENT_EMPTY = -1;
const float CONTENT_SOLID = -2;
const float CONTENT_WATER = -3;
const float CONTENT_SLIME = -4;
const float CONTENT_LAVA  = -5;
const float CONTENT_SKY   = -6;

const float STATE_TOP    = 0;
const float STATE_BOTTOM = 1;
const float STATE_UP     = 2;
const float STATE_DOWN   = 3;

const float SVC_SETVIEW       = 5;
const float SVC_TEMPENTITY    = 23;
const float SVC_KILLEDMONSTER = 27;
const float SVC_FOUNDSECRET   = 28;
const float SVC_FINALE        = 31;
const float SVC_CDTRACK       = 32;
const float SVC_SELLSCREEN    = 33;

const float TE_SPIKE        = 0;
const float TE_SUPERSPIKE   = 1;
const float TE_GUNSHOT      = 2;
const float TE_EXPLOSION    = 3;
const float TE_TAREXPLOSION = 4;
const float TE_LIGHTNING1   = 5;
const float TE_LIGHTNING2   = 6;
const float TE_WIZSPIKE     = 7;
const float TE_KNIGHTSPIKE  = 8;
const float TE_LIGHTNING3   = 9;
const float TE_LAVASPLASH   = 10;
const float TE_TELEPORT     = 11;

const float CHAN_AUTO   = 0;
const float CHAN_WEAPON = 1;
const float CHAN_VOICE  = 2;
const float CHAN_ITEM   = 3;
const float CHAN_BODY   = 4;

const float ATTN_NONE   = 0;
const float ATTN_NORM   = 1;
const float ATTN_IDLE   = 2;
const float ATTN_STATIC = 3;

const float MSG_BROADCAST = 0;
const float MSG_ONE       = 1;
const float MSG_ALL       = 2;
const float MSG_INIT      = 3;
const float MSG_ENTITY    = 5;

const float IT_ROCKET_LAUNCHER  = 0;
const float IT_GRENADE_LAUNCHER = 1;
const float IT_CHOVEL           = 2;

const float PRIM_ROCKET_LAUNCHER = 1;
const float PRIM_IMPLOSION       = 2;
const float PRIM_OVERLOADER      = 3;

const float SEC_STICKYBOMB = 1;
const float SEC_GRAPPLE    = 2;
const float SEC_CONC       = 3;

const vector VEC_ORIGIN   = '0 0 0';
const vector VEC_HULL_MIN = '-24 -24 -32';
const vector VEC_HULL_MAX = '24 24 48';

const float BHOP_MAXSPEED = 800;

const float WR_RIGHT   = 0;
const float WR_LEFT    = 1;
const float WR_MAXDIST = 64;

const float MENU_PRIM = 0;
const float MENU_SEC  = 1;

const float EV_STRING   = 1;
const float EV_FLOAT    = 2;
const float EV_VECTOR   = 3;
const float EV_ENTITY   = 4;
const float EV_FIELD    = 5;
const float EV_FUNCTION = 6;
const float EV_POINTER  = 7;
const float EV_INTEGER  = 8;
const float EV_VARIANT  = 9;

float STAT_LG_HURT      = 32;
float STAT_LG_DAMAGE    = 33;
float STAT_LG_HIT       = 34;
float STAT_LG_KILL      = 35;
float STAT_LG_PX        = 36;
float STAT_LG_PY        = 37;
float STAT_LG_PZ        = 38;
float STAT_LG_PP        = 39;
float STAT_LG_IN_MENU   = 40;
float STAT_LG_OPEN_MENU = 41;

const float RESTRICT_ROCKET  = 1; 
const float RESTRICT_GRENADE = 2; 
const float RESTRICT_TELEGUN = 4; 
const float RESTRICT_CONC    = 8; 
const float RESTRICT_WALLRUN = 16;

const float EF_BRIGHTFIELD = 1;
const float EF_MUZZLEFLASH = 2;
const float EF_BRIGHTLIGHT = 4;
const float EF_DIMLIGHT    = 8;

const float POSE_RL_IDLE     = 0;
const float POSE_RL_RUN      = 1;
const float POSE_RL_IDLE_ATT = 2;
const float POSE_RL_RUN_ATT  = 3;
const float POSE_GL_IDLE     = 4;
const float POSE_GL_RUN      = 5;
const float POSE_GL_IDLE_ATT = 6;
const float POSE_GL_RUN_ATT  = 7;
const float POSE_CH_IDLE     = 8;
const float POSE_CH_RUN      = 9;
const float POSE_CH_IDLE_ATT = 10;
const float POSE_CH_RUN_ATT  = 11;
const float POSE_SIT_ENTER   = 12;
const float POSE_SIT_IDLE    = 13;
const float POSE_SIT_LEAVE   = 14;
