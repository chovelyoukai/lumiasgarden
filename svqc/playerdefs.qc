//=====
//
// player specific fields
//
//=====

.float inMenu;
.float openMenu;
.float stuck;

.float walkFrame;
.float idlePose;
.float runPose;
.float idleAttackPose;
.float runAttackPose;

.float button0Reset;
.float button3Reset;

.entity tracker;
.entity camera;

.float deployTime;

.float cantWallrun;
.float wallrunning;
.float wallrunTime;
.float wallrunSide;

.float rocketJumpFlag;
.float grenades;
.float attackFinished;
.float attackFinishedRocket;
.float attackFinishedGrenade;

.entity grapple;
.float grappled;
.float grappleDistance;

.float overloaded;
.float cantOverload;
.float spewing;
.float nextSpew;

.float holdingGrenade;
.float cantConc;
.float throwCount;

.float suicideFinished;
.string hasBall;

.float stat_hurt;
.float stat_damage;
.float stat_hit;
.float stat_kill;
.float stat_py;
.float stat_px;
.float stat_pz;
.float stat_pp;
.float stat_tele_time;

.float inMenu;
.float openMenu;
.float invuln;
.float switchWeps;
.float prim;
.float sec;

.float button3;
.float button4;

.void() thinkDie;
