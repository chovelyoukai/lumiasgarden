// playerdefs.qc
//
// player specific fields
//
// this file is licensed under the GPL v3

// menu status
.float inMenu;
.float openMenu;
.float stuck;

// animation status
.float walkFrame;
.float idlePose;
.float runPose;
.float idleAttackPose;
.float runAttackPose;

// whether or not a button must be reset
.float button0Reset;
.float button3Reset;

// thirdperson entities
.entity tracker;
.entity camera;

// amount of time until a weapon can be deployed
.float deployTime;

// wallrun status
.float cantWallrun;
.float wallrunning;
.float wallrunTime;
.float wallrunSide;

// various weapon statuses
.float rocketJumpFlag;
.float grenades;
.float attackFinished;
.float attackFinishedRocket;
.float attackFinishedGrenade;

// grapple status
.entity grapple;
.float grappled;
.float grappleDistance;

// overloader status
.float overloaded;
.float cantOverload;
.float spewing;
.float nextSpew;

// conc status
.float holdingGrenade;
.float cantConc;
.float throwCount;

// for preventing too many suicides
.float suicideFinished;

// used in KADM
.string hasBall;

// player stats
.float stat_hurt;
.float stat_damage;
.float stat_hit;
.float stat_kill;
.float stat_py;
.float stat_px;
.float stat_pz;
.float stat_pp;
.float stat_tele_time;

// more menu related statuses
.float inMenu;
.float openMenu;
.float invuln;
.float switchWeps;
.float prim;
.float sec;

// player inputs
.float button3;
.float button4;

// what to do when killed
.void() thinkDie;
