#define ALIGN_LEFT 1
#define ALIGN_RIGHT 2
#define ALIGN_CENTER 3
#define ALIGN_TOP 1
#define ALIGN_BOTTOM 2

#define MENU_BG_COLOR '0 0 0'
#define MENU_BG_ALPHA 0.8
#define MENU_SIZE '50 80 0'

#define MENU_INTERNAL -1
#define MENU_ROOT 0
#define MENU_SETTINGS 1

float menuActive;
float splashTime;
float drawAlignX;
float drawAlignY;
float selected;
float maxSelect;
float currMenu;
vector realSize;
vector relCoords;
vector absCoords;

