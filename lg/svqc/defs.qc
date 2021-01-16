// defs.qc
//
// game-wide definitions, global variables, and built-in functions
//
// this file is licensed under the GPL v3


//==========
//
// system globals
//
//==========

entity self;
entity other;
entity world;
float time;
float frametime;
float force_retouch; // force non moving entities to touch

string mapname;
float deathmatch;
float coop;
float teamplay;
float serverflags;

float total_secrets;
float total_monsters;
float found_secrets;
float killed_monsters;

// spawnparms are used to encode information about clients across server
// level changes
float parm1, parm2, parm3, parm4, parm5, parm6, parm7, parm8;
float parm9, parm10, parm11, parm12, parm13, parm14, parm15, parm16;

// global variables set by built in functions
vector v_forward, v_up, v_right; // set by makevectors()

// set by traceline / tracebox
float trace_allsolid;
float trace_startsolid;
float trace_fraction;
vector trace_endpos;
vector trace_plane_normal;
float trace_plane_dist;
entity trace_ent;
float trace_inopen;
float trace_inwater;

entity msg_entity;  // destination of single entity writes

//==========
//
// required prog functions
//
//==========

void main();   // only for testing

void StartFrame();

void PlayerPreThink();
void PlayerPostThink();

void ClientKill();
void ClientConnect();
void PutClientInServer(); // call after setting the parm1... parms
void ClientDisconnect();

void SetNewParms(); // called when a client first connects to
                    // a server. sets parms so they can be
                    // saved off for restarts

void SetChangeParms(); // call to set parms for self so they can
                       // be saved for a level transition

void end_sys_globals; // flag for structure dumping

//=====
//
// system fields
//
//=====
.float modelindex; // model index in the precached list
.vector absmin, absmax;// origin + mins / maxs

.float ltime; // local time for entity
.float movetype;
.float solid;

.vector origin;
.vector oldorigin;
.vector velocity;
.vector angles;
.vector avelocity;

.vector punchangle; // temp angle adjust from damage or recoil

.string classname; // spawn function
.string model;
.float frame;
.float skin;
.float effects;

.vector mins, maxs; // bounding box extents reletive to origin
.vector size; // maxs - mins

.void() touch;
.void() use;
.void() think;
.void() blocked; // for doors or plats, called when can't push other

.float nextthink;
.entity groundentity;

// stats
.float health;
.float frags;
.float weapon; // one of the IT_SHOTGUN, etc flags
.string weaponmodel;
.float weaponframe;
.float currentammo;
.float ammo_shells, ammo_nails, ammo_rockets, ammo_cells;

.float items; // bit flags

.float takedamage;
.entity chain;
.float deadflag;

.vector view_ofs; // add to origin to get eye point

.float button0; // fire
.float button1; // use
.float button2; // jump

.float impulse; // weapon changes

.float fixangle;
.vector v_angle; // view / targeting angle for players
.float idealpitch; // calculated pitch angle for lookup up slopes


.string netname;

.entity enemy;

.float flags;

.float colormap;
.float team;

.float max_health; // players maximum health is stored here

.float teleport_time; // don't back up

.float armortype; // save this fraction of incoming damage
.float armorvalue;

.float waterlevel; // 0 = not in, 1 = feet, 2 = wast, 3 = eyes
.float watertype; // a contents value

.float ideal_yaw;
.float yaw_speed;

.entity aiment;

.entity goalentity; // a movetarget or an enemy

.float spawnflags;

.string target;
.string targetname;

// damage is accumulated through a frame. and sent as one single
// message, so the super shotgun doesn't generate huge messages
.float dmg_take;
.float dmg_save;
.entity dmg_inflictor;

.entity owner; // who launched a missile
.vector movedir;// mostly for doors, but also used for waterjump

.string message; // trigger messages

.float sounds; // either a cd track number or sound number

.string noise, noise1, noise2, noise3;// contains names of wavs to play

void end_sys_fields; // flag for structure dumping

//==========
//
// optional entity fields
//
//==========

.float(entity to, float sendFlags) SendEntity;
.float SendFlags;

//==========
//
// builtin functions
//
//==========

void makeVectors(vector ang) = #1; // sets v_forward, etc globals
void setOrigin(entity e, vector o) = #2;
void setModel(entity e, string m) = #3; // set movetype and solid first
void setSize(entity e, vector min, vector max) = #4;
// no #5 or #6
float random() = #7; // returns 0 - 1
void sound(entity e, float chan, string samp, float vol, float atten) = #8;
vector normalize(vector v) = #9;
void error(string e) = #10;
void objError(string e) = #11;
float vlen(vector v) = #12;
float vecToYaw(vector v) = #13;
entity spawn() = #14;
void remove(entity e) = #15;
void traceLine(vector v1, vector v2, float nomonsters, entity forent) = #16;

entity checkClient()  = #17; // returns a client to look for
entity find(entity start, .string fld, string match) = #18;
string precache_sound(string s) = #19;
string precache_model(string s) = #20;
void stuffCmd(entity client, string s) = #21;
entity findRadius(vector org, float rad) = #22;
void bprint(string s) = #23;
void sprint(entity client, string s) = #24;
void dprint(string s) = #25;
string ftos(float f) = #26;
string vtos(vector v) = #27;
void coredump() = #28; // prints all edicts
void traceOn() = #29; // turns statment trace on
void traceOff() = #30;
void eprint(entity e) = #31; // prints an entire edict
float walkMove(float yaw, float dist) = #32;// returns TRUE or FALSE
// #33 was removed
float dropToFloor() = #34;// TRUE if landed on floor
void lightStyle(float style, string value) = #35;
float roundInt(float v) = #36; // round to nearest int
float floor(float v) = #37; // largest integer <= v
float ceil(float v) = #38; // smallest integer >= v
// #39 was removed
float checkBottom(entity e) = #40; // true if self is on ground
float pointContents(vector v) = #41; // returns a CONTENT_*
// #42 was removed
float fabs(float f) = #43;
vector aim(entity e, float speed) = #44; // returns the shooting vector
float cvar(string s) = #45; // return cvar.value
void localCmd(string s) = #46; // put string into local que
entity nextEnt(entity e) = #47; // for looping through all ents
void particle(vector o, vector d, float color, float count) = #48;// start a particle effect
void ChangeYaw() = #49; // turn towards self.ideal_yaw
                        // at self.yaw_speed
// #50 was removed
vector vecToAngles(vector v) = #51;
//
// direct client message generation
//
void(float to, float f) writeByte = #52;
void(float to, float f) writeChar = #53;
void(float to, float f) writeShort = #54;
void(float to, float f) writeLong = #55;
void(float to, float f) writeCoord = #56;
void(float to, float f) writeAngle = #57;
void(float to, string s) writeString= #58;
void(float to, entity s) writeEntity= #59;
// no #60 through #66
void moveToGoal(float step)  = #67;
string precache_file(string s) = #68; // no effect except for -copy
void makeStatic(entity e) = #69;
void changeLevel(string s) = #70;
//#71 was removed
void cvarSet(string var, string val) = #72; // sets cvar.value

void centerPrint(entity client, string s) = #73; // sprint, but in middle

void ambientSound(vector pos, string samp, float vol, float atten) = #74;

string precache_model2(string s) = #75; // registered version only
string precache_sound2(string s) = #76; // registered version only
string precache_file2(string s) = #77; // registered version only

void setSpawnParms(entity e) = #78; // set parm1... to the
                                    // values at level start
                                    // for coop respawn
void clientStat(float num, float type, ...) = #232;
void runStandardPlayerPhysics(entity ent) = #347;
void writeFloat(float to, float f) = #280;
