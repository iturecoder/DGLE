{
\file    DGLE2_types.pas
\author    Korotkov Andrey aka DRON
\version  2:0.3.0
\date    XX.XX.2012 (c)Korotkov Andrey

\brief    Engine types definition header.

This header is a part of DGLE_SDK.

\warning  Don't include this header directly, include "DGLE.pas" instead.
\see    DGLE.pas
}

unit DGLE_Types;

interface

{$I include.inc}

{$ifndef DGLE_TYPES}
{$define DGLE_TYPES}
{$ENDIF}

uses
  Windows
  {$IF COMPILERVERSION >= 20}, Generics.Collections{$IFEND};

const

  Minus1 = $FFFFFFFF;

//E_ENGINE_WINDOW_FLAGS

  EWF_DEFAULT                    = $00000000;//< This flag is suitable in most cases.
  EWF_ALLOW_SIZEING              = $00000001;//< User can resize engine window arbitrarily
  EWF_TOPMOST                    = $00000002;//< Engine window will be always on top.
  EWF_DONT_HOOK_MAINLOOP         = $00000004;//< If flag set and engine doesn't owns window, host applications main loop will not be hooked. User must call window repaint manually.
  EWF_DONT_HOOK_ROOT_WINDOW      = $00000008;//< If flag set and engine doesn't owns window, main host application window will not be hooked. User must redirect windows messages manually.
  EWF_RESTRICT_FULLSCREEN_HOTKEY = $00000010;//< Switching between fullscreen and windowed modes by pressing "Alt-Enter" will be restricted.
  EWF_RESTRICT_CONSOLE_HOTKEY    = $00000020;//< Restricts calling engine console window by pressing "~" key.

// E_MULTISAMPLING_MODE

  MM_NONE  = $00000000;//**< Multisampling is off. */
  MM_2X    = $00000001;//**< 2xMSAA */
  MM_4X    = $00000002;//**< 4xMSAA \note This value is recomended. */
  MM_8X    = $00000004;//**< 8xMSAA */
  MM_16X   = $00000008;//**< 16xMSAA */

type
//  E_KEYBOARD_KEY_CODES  = integer;
//  E_DGLE_VARIANT_TYPE   = integer;
  E_WINDOW_MESSAGE_TYPE =
  (
    WMT_UNKNOWN     = 0,
    WMT_REDRAW      = 1,
    WMT_PRESENT     = 2,
    WMT_CLOSE       = 3,
    WMT_CREATE      = 4,
    WMT_DESTROY     = 5,
    WMT_RELEASED    = 6,
    WMT_ACTIVATED   = 7,
    WMT_DEACTIVATED = 8,
    WMT_MINIMIZED   = 9,
    WMT_RESTORED    = 10,
    WMT_MOVE        = 11,
    WMT_SIZE        = 12,
    WMT_KEY_UP      = 13,
    WMT_KEY_DOWN    = 14,
    WMT_ENTER_CHAR  = 15,
    WMT_MOUSE_MOVE  = 16,
    WMT_MOUSE_DOWN  = 17,
    WMT_MOUSE_UP    = 18,
    WMT_MOUSE_WHEEL = 19
  );

type

// Variant data type definiton //

  E_DGLE_VARIANT_TYPE =
  (
    DVT_UNKNOWN = 0,
    DVT_INT     = 1,
    DVT_FLOAT   = 2,
    DVT_BOOL    = 3,
    DVT_POINTER = 4,
    DVT_DATA    = 5
  );

type

  DGLE_RESULT = Integer;

  TWindowHandle    = HWND;
  TWindowDrawHandle     = HDC;
  TCRndrInitResults   = Boolean;

  GLUInt = Cardinal;

  PByte   = Pointer;

  TEngineWindow = packed record
    uiWidth      : Cardinal;
    uiHeight    : Cardinal;
    bFullScreen  : Boolean;
    bVSync      : Boolean;
    eMultiSampling  : {E_MULTISAMPLING_MODE} Cardinal;
    uiFlags      : {ENG_WINDOW_FLAGS} Cardinal;
  {$IF COMPILERVERSION >= 18}
    constructor Create(var dummy);                      overload;
    constructor Create(uiWidth, uiHeight : Integer; bFullScreen : Boolean;
      bVSync : Boolean = False; eMSampling: {E_MULTISAMPLING_MODE} Cardinal = MM_NONE;
      uiFlags:{ENG_WINDOW_FLAGS}Integer = EWF_DEFAULT); overload;
  {$IFEND}
  end;
//  end;

  TSystemInfo = packed record
    cOSName           : array[0..127] of AnsiChar;
    cCPUName         : array[0..127] of AnsiChar;
    uiCPUCount       : Cardinal;
    uiCPUFrequency   : Cardinal;
    uiRAMTotal       : Cardinal;
    uiRAMAvailable   : Cardinal;
    cVideocardName   : array[0..127] of AnsiChar;
    uiVideocardCount : Cardinal;
    uiVideocardRAM   : Cardinal;
  end;

  TPluginInfo = packed record
    ui8PluginSDKVersion  : Byte;
    cName          : array[0..127] of AnsiChar;
    cVersion      : array[0..64] of AnsiChar;
    cVendor        : array[0..127] of AnsiChar;
    cDescription  : array[0..256] of AnsiChar;
  {$IF COMPILERVERSION >= 18}
    constructor Create(var dummy);
  {$IFEND}
  end;

  TWindowMessage = record
    eMsgType: E_WINDOW_MESSAGE_TYPE; //**< Window message type identifier. */
    ui32Param1: Cardinal;  //**< Message first parametr. */
    ui32Param2: Cardinal;  //**< Message second parametr. */
    pParam3: Pointer;  //**< Message third parametr. Points to specific message data. */
  {$IF COMPILERVERSION >= 18}
    constructor Create(var dummy);                      overload;
    constructor Create(msg: E_WINDOW_MESSAGE_TYPE; param1: Cardinal = 0;
      param2: Cardinal = 0; param3: Pointer = nil);     overload;
  {$IFEND}
  end;

  TColor4 = packed record
  {$IF COMPILERVERSION >= 18}
    constructor Create(var dummy);                      overload;
    constructor Create(ui32ABGR: Cardinal);             overload;
    constructor Create(ui32RGB: Cardinal; ubA: byte);   overload;
    constructor Create(ubR, ubG, ubB, ubA: Byte);       overload;
    constructor Create(fR, fG, fB, fA: Single);         overload;
    constructor Create(const rgba: array of Single);    overload;
    procedure SetColorF(fR, fG, fB, fA: Single);        inline;
    procedure SetColorB(ubR, ubG, ubB, ubA: Byte);      inline;
    function ColorRGB(): Cardinal;                      inline;
    function ColorRGBA(): Cardinal;                     inline;
  {$IFEND}
  {$IF COMPILERVERSION >= 20}
    class operator Implicit(Color: TColor4): Cardinal;  inline;
  {$IFEND}
    case Byte of
      0: (r, g, b, a : Single);
      1: (_rgba : array[0..3] of Single);
  end;
  PColor4 = ^TColor4;

type

  TPoint3 = packed record
  {$IF COMPILERVERSION >= 18}
    constructor Create (var dummy);                                                overload;
    constructor Create (x, y, z : Single);                                         overload;
    constructor Create (const Floats: Array of Single);                            overload;
    function Dot(const stPoint: TPoint3): Single;                                  inline;
    function Cross(const stPoint: TPoint3): TPoint3;                               inline;
    function FlatDistTo(const stPoint: TPoint3): Single;                           inline;
    function DistTo(const stPoint: TPoint3): Single;                               inline;
    function DistToQ(const stPoint: TPoint3): Single;                              inline;
    function LengthQ(): Single;                                                    inline;
    function Length(): Single;                                                     inline;
    function Normalize(): TPoint3;                                                 inline;
    function Lerp(const stPoint: TPoint3; coeff: Single): TPoint3;                 inline;
    function Angle(const stPoint: TPoint3): Single;                                inline;
    function Rotate(const Axis: TPoint3; fAngle: Single): TPoint3;                 inline;
    function Reflect(const normal : TPoint3): TPoint3;                             inline;
  {$IFEND}
  {$IF COMPILERVERSION >= 20}
    class operator Add(const stLeft, stRight: TPoint3): TPoint3;                   inline;
    class operator Subtract(const stLeft, stRight: TPoint3): TPoint3;              inline;
    class operator Multiply(const stLeft, stRight: TPoint3): TPoint3;              inline;
    class operator Divide(const stLeft, stRight: TPoint3): TPoint3;                inline;
    class operator Add(const stLeft: TPoint3; const fRight: Single): TPoint3;      inline;
    class operator Subtract(const stLeft: TPoint3; const fRight: Single): TPoint3; inline;
    class operator Multiply(const stLeft: TPoint3; const fRight: Single): TPoint3; inline;
    class operator Divide(const stLeft: TPoint3; const fRight: Single): TPoint3;   inline;
  {$IFEND}
    case byte of
      0: (_1D : array[0..2] of Single);
      1: (x, y, z : Single);
  end;
  PPoint3 = ^TPoint3;
  TVector3 = TPoint3;
  TVec3 = TPoint3;

  TPoint2 = packed record
  {$IF COMPILERVERSION >= 18}
    constructor Create (var dummy);                                                overload;
    constructor Create (x, y : Single);                                            overload;
    constructor Create (const Floats: Array of Single);                            overload;
    function Dot(const stPoint: TPoint2): Single;                                  inline;
    function Cross(const stPoint: TPoint2): Single;                                inline;
    function DistTo(const stPoint: TPoint2): Single;                               inline;
    function DistToQ(const stPoint: TPoint2): Single;                              inline;
    function LengthQ(): Single;                                                    inline;
    function Length(): Single;                                                     inline;
    function Normalize(): TPoint2;                                                 inline;
    function Lerp(const stPoint: TPoint2; coeff: Single): TPoint2;                 inline;
    function Angle(const stPoint: TPoint2): Single;                                inline;
    function Rotate(fAngle: Single): TPoint2;                                      inline;
    function Reflect(const normal : TPoint2): TPoint2;                             inline;
  {$IFEND}
  {$IF COMPILERVERSION >= 20}
    class operator Add(const stLeft, stRight: TPoint2): TPoint2;                   inline;
    class operator Subtract(const stLeft, stRight: TPoint2): TPoint2;              inline;
    class operator Multiply(const stLeft, stRight: TPoint2): TPoint2;              inline;
    class operator Divide(const stLeft, stRight: TPoint2): TPoint2;                inline;
    class operator Add(const stLeft: TPoint2; fRight: Single): TPoint2;            inline;
    class operator Subtract(const stLeft: TPoint2; fRight: Single): TPoint2;       inline;
    class operator Multiply(const stLeft: TPoint2; fRight: Single): TPoint2;       inline;
    class operator Divide(const stLeft: TPoint2; fRight: Single): TPoint2;         inline;
  {$IFEND}
    case byte of
      0: (_1D : array[0..1] of Single);
      1: (x, y : Single);
  end;
  PPoint2 = ^TPoint2;
  TVector2 = TPoint2;
  TVec2 = TPoint2;

  TVertex2 = packed record
    case byte of
      0: (_1D : array[0..7] of Single);
      1: (x, y, u, w, r, g, b, a : Single);
  end;
  PVertex2 = ^TVertex2;

  TRectf = packed record
    x, y, width, height : Single;
  {$IF COMPILERVERSION >= 18}
    constructor Create(var dummy);                                overload;
    constructor Create(x, y, width, height : Single);             overload;
    constructor Create(const stLeftTop, stRightBottom: TPoint2);  overload;
    function IntersectRect(const stRect: TRectf):Boolean;         inline;
    function PointInRect(const stPoint : TPoint2):Boolean;        inline;
    function RectInRect(const stRect : TRectf): Boolean;          inline;
    function GetIntersectionRect(const stRect : TRectf): TRectf;  inline;
  {$IFEND}
  end;
  PRectf = ^TRectf;

  TMatrix4x4 = packed record
  {$IF COMPILERVERSION >= 20}
    class operator Subtract(const stLeftMatrix, stRightMatrix : TMatrix4x4): TMatrix4x4; inline;
    class operator Add(const stLeftMatrix, stRightMatrix : TMatrix4x4): TMatrix4x4;      inline;
    class operator Multiply(const stLeftMatrix, stRightMatrix : TMatrix4x4): TMatrix4x4; inline;
    class operator Subtract(const stLeftMatrix: TMatrix4x4; right: Single): TMatrix4x4;  inline;
    class operator Add(const stLeftMatrix: TMatrix4x4; right: Single): TMatrix4x4;       inline;
    class operator Divide(const stLeftMatrix: TMatrix4x4; right: Single): TMatrix4x4;    inline;
    class operator Multiply(const stLeftMatrix: TMatrix4x4; right: Single): TMatrix4x4;  inline;
  {$IFEND}
    case byte of
      0: (_1D : array[0..15] of Single);
      1: (_2D : array[0..3, 0..3] of Single);
  end;
  PMatrix = ^TMatrix4x4;
  TMatrix = TMatrix4x4;
  TMat4 = TMatrix4x4;
  TMatrix4 = TMatrix4x4;


  TTransformStack = class
  private
{$IF COMPILERVERSION >= 20}
    stack: TStack<TMatrix>;
{$ELSE}
    stack: array of TMatrix;
{$IFEND}
    Constructor Create; overload;
    function GetTop: TMatrix4x4;
    procedure SetTop(const Value: TMatrix4x4);
  public
    Constructor Create(const base_transform: TMatrix4x4); overload;
    procedure Clear(const base_transform: TMatrix4x4);
    procedure Push;
    procedure Pop;
    property Top: TMatrix4x4 read GetTop write SetTop;
    procedure MultGLobal(const transform: TMatrix4x4);
    procedure MultLocal(const transform: TMatrix4x4);
  end;

  TMouseStates = packed record
    iX            : Integer;
    iY            : Integer;
    iDeltaX       : Integer;
    iDeltaY       : Integer;
    iDeltaWheel   : Integer;
    bLeftButton   : Boolean;
    bRightButton  : Boolean;
    bMiddleButton : Boolean;
  end;

  TKeyboardStates = packed record
    bCapsLock  : Boolean;
    bShiftL    : Boolean;
    bShiftR    : Boolean;
    bCtrlL     : Boolean;
    bCtrlR     : Boolean;
    bAltL      : Boolean;
    bAltR      : Boolean;
  end;

  TJoystickStates = packed record
    uiButtonsCount: Cardinal;  //**< Count of available joystick buttons. */
    bButtons: array[0..31] of Boolean;  //**< Array of joystick buttons states (pressed or not). */
    iXAxes : Integer;        //**< X-axis position. Value varies -100 to 100. */
    iYAxes : Integer;        //**< Y-axis position. Value varies -100 to 100. */
    iZAxes : Integer;        //**< Z-axis position. Value varies -100 to 100. */
    iRAxes : Integer;      //**< Current position of the rudder or fourth joystick axis. Value varies -100 to 100. */
    iUAxes : Integer;      //**< Current fifth axis position. Value varies -100 to 100. */
    iVAxes : Integer;      //**< Current sixth axis position. Value varies -100 to 100. */
    iPOV   : Integer;      //**< Point-Of-View direction. */
  end;

   TVariant = record
    _type: E_DGLE_VARIANT_TYPE;
    _Data: Pointer;
  {$IF COMPILERVERSION >= 20}
    class operator Implicit(AVar: TVariant): Integer; inline;
    class operator Implicit(AVar: TVariant): Single;  inline;
    class operator Implicit(AVar: TVariant): Boolean; inline;
    class operator Implicit(AVar: TVariant): Pointer; inline;
  {$IFEND}
  {$IF COMPILERVERSION < 18}
  end;
  {$IFEND}
    procedure Clear({$IF COMPILERVERSION < 18}var AVar: TVariant{$IFEND});                        {$IF COMPILERVERSION >= 18}inline;{$IFEND}
    procedure SetInt({$IF COMPILERVERSION < 18}var AVar: TVariant;{$IFEND}iVal: Integer);         {$IF COMPILERVERSION >= 18}inline;{$IFEND}
    procedure SetFloat({$IF COMPILERVERSION < 18}var AVar: TVariant;{$IFEND}fVal: Single);        {$IF COMPILERVERSION >= 18}inline;{$IFEND}
    procedure SetBool({$IF COMPILERVERSION < 18}var AVar: TVariant;{$IFEND}bVal: Boolean);        {$IF COMPILERVERSION >= 18}inline;{$IFEND}
    procedure SetPointer({$IF COMPILERVERSION < 18}var AVar: TVariant;{$IFEND}pPointer: Pointer); {$IF COMPILERVERSION >= 18}inline;{$IFEND}
    procedure SetData({$IF COMPILERVERSION < 18}var AVar: TVariant;{$IFEND}pData: Pointer; uiDataSize: Cardinal); {$IF COMPILERVERSION >= 18}inline;{$IFEND}
    function AsInt({$IF COMPILERVERSION < 18}var AVar: TVariant{$IFEND}): Integer;                {$IF COMPILERVERSION >= 18}inline;{$IFEND}
    function AsFloat({$IF COMPILERVERSION < 18}var AVar: TVariant{$IFEND}): Single;               {$IF COMPILERVERSION >= 18}inline;{$IFEND}
    function AsBool({$IF COMPILERVERSION < 18}var AVar: TVariant{$IFEND}): Boolean;               {$IF COMPILERVERSION >= 18}inline;{$IFEND}
    function AsPointer({$IF COMPILERVERSION < 18}var AVar: TVariant{$IFEND}): Pointer;            {$IF COMPILERVERSION >= 18}inline;{$IFEND}
    procedure GetData({$IF COMPILERVERSION < 18}var AVar: TVariant;{$IFEND}out pData: Pointer; out uiDataSize: Cardinal); {$IF COMPILERVERSION >= 18}inline;{$IFEND}
    function GetType({$IF COMPILERVERSION < 18}var AVar: TVariant{$IFEND}): E_DGLE_VARIANT_TYPE;  {$IF COMPILERVERSION >= 18}inline;{$IFEND}
  {$IF COMPILERVERSION >= 18}
  end;
  {$IFEND}
type

  E_KEYBOARD_KEY_CODES =
  (
    KEY_ESCAPE       = $01,  // Escape
    KEY_TAB          = $0F,  // Tab
    KEY_GRAVE        = $29,  // accent grave "~"
    KEY_CAPSLOCK     = $3A,  // Caps Lock
    KEY_BACKSPACE    = $0E,  // Backspace
    KEY_RETURN       = $1C,  // Enter
    KEY_SPACE        = $39,  // Space
    KEY_SLASH        = $35,  // "/"
    KEY_BACKSLASH    = $2B,  // "\"

    KEY_SYSRQ        = $B7,  // PtrScr (SysRq)
    KEY_SCROLL       = $46,  // Scroll Lock
    KEY_PAUSE        = $C5,  // Pause

    KEY_INSERT       = $D2,  // Insert
    KEY_DELETE       = $D3,  // Delete
    KEY_HOME         = $C7,  // Home
    KEY_END          = $CF,  // End
    KEY_PGUP         = $C9,  // PgUp
    KEY_PGDN         = $D1,  // PgDn

    KEY_LSHIFT       = $2A,  // Left Shift
    KEY_RSHIFT       = $36,  // Right Shift
    KEY_LALT         = $38,  // Left Alt
    KEY_RALT         = $B8,  // Right Alt
    KEY_LWIN_OR_CMD  = $DB,  // Left Windows key
    KEY_RWIN_OR_CMD  = $DC,  // Right Windows key
    KEY_LCONTROL     = $1D,  // Left Control
    KEY_RCONTROL     = $9D,  // Right Control

    KEY_UP           = $C8,  // UpArrow
    KEY_RIGHT        = $CD,  // RightArrow
    KEY_LEFT         = $CB,  // LeftArrow
    KEY_DOWN         = $D0,  // DownArrow

    KEY_1            = $02,
    KEY_2            = $03,
    KEY_3            = $04,
    KEY_4            = $05,
    KEY_5            = $06,
    KEY_6            = $07,
    KEY_7            = $08,
    KEY_8            = $09,
    KEY_9            = $0A,
    KEY_0            = $0B,

    KEY_F1           = $3B,
    KEY_F2           = $3C,
    KEY_F3           = $3D,
    KEY_F4           = $3E,
    KEY_F5           = $3F,
    KEY_F6           = $40,
    KEY_F7           = $41,
    KEY_F8           = $42,
    KEY_F9           = $43,
    KEY_F10          = $44,
    KEY_F11          = $57,
    KEY_F12          = $58,

    KEY_Q            = $10,
    KEY_W            = $11,
    KEY_E            = $12,
    KEY_R            = $13,
    KEY_T            = $14,
    KEY_Y            = $15,
    KEY_U            = $16,
    KEY_I            = $17,
    KEY_O            = $18,
    KEY_P            = $19,
    KEY_A            = $1E,
    KEY_S            = $1F,
    KEY_D            = $20,
    KEY_F            = $21,
    KEY_G            = $22,
    KEY_H            = $23,
    KEY_J            = $24,
    KEY_K            = $25,
    KEY_L            = $26,
    KEY_Z            = $2C,
    KEY_X            = $2D,
    KEY_C            = $2E,
    KEY_V            = $2F,
    KEY_B            = $30,
    KEY_N            = $31,
    KEY_M            = $32,
    KEY_MINUS        = $0C,  // "-"
    KEY_PLUS         = $0D,  // "+"
    KEY_LBRACKET     = $1A,  // "["
    KEY_RBRACKET     = $1B,  // "]"

    KEY_SEMICOLON    = $27,  // ";"
    KEY_APOSTROPHE   = $28,  // '"'

    KEY_COMMA        = $33,  // ","
    KEY_PERIOD       = $34,  // "."

    KEY_NUMPAD0      = $52,
    KEY_NUMPAD1      = $4F,
    KEY_NUMPAD2      = $50,
    KEY_NUMPAD3      = $51,
    KEY_NUMPAD4      = $4B,
    KEY_NUMPAD5      = $4C,
    KEY_NUMPAD6      = $4D,
    KEY_NUMPAD7      = $47,
    KEY_NUMPAD8      = $48,
    KEY_NUMPAD9      = $49,
    KEY_NUMPADPERIOD = $53,  // "." on numpad
    KEY_NUMPADENTER  = $9C,  // Enter on numpad
    KEY_NUMPADSTAR   = $37,  // "*" on numpad
    KEY_NUMPADPLUS   = $4E,  // "+" on numpad
    KEY_NUMPADMINUS  = $4A,  // "-" on numpad
    KEY_NUMPADSLASH  = $B5,  // "/" on numpad
    KEY_NUMLOCK      = $45  // Num Lock on numpad
  );

function PluginInfo(): TPluginInfo;                                         {$IF COMPILERVERSION >= 18}inline;{$IFEND}

function WindowMessage(): TWindowMessage;                                   overload; {$IF COMPILERVERSION >= 18}inline;{$IFEND}
function WindowMessage(msg: E_WINDOW_MESSAGE_TYPE; param1: Cardinal = 0;
  param2: Cardinal = 0; param3: Pointer = nil): TWindowMessage;             overload; {$IF COMPILERVERSION >= 18}inline;{$IFEND}

function Color4(r,g,b,a: Single): TColor4;                                  overload; {$IF COMPILERVERSION >= 18}inline;{$IFEND}
function Color4(r,g,b,a: Byte): TColor4;                                    overload; {$IF COMPILERVERSION >= 18}inline;{$IFEND}
function Color4(color : Cardinal; alpha : Byte = 255): TColor4;             overload; {$IF COMPILERVERSION >= 18}inline;{$IFEND}
function Color4(): TColor4;                                                 overload; {$IF COMPILERVERSION >= 18}inline;{$IFEND}
function Color4(const rgba: array of Single): TColor4;                      overload;

function ColorClear(alpha: Byte = 255)         : TColor4;
function ColorWhite(alpha: Byte = 255)         : TColor4;
function ColorBlack(alpha: Byte = 255)         : TColor4;
function ColorRed(alpha: Byte = 255)           : TColor4;
function ColorGreen(alpha: Byte = 255)         : TColor4;
function ColorBlue(alpha: Byte = 255)          : TColor4;

function ColorAqua(alpha: Byte = 255)          : TColor4;
function ColorBrown(alpha: Byte = 255)         : TColor4;
function ColorCyan(alpha: Byte = 255)          : TColor4;
function ColorFuchsia(alpha: Byte = 255)       : TColor4;
function ColorGray(alpha: Byte = 255)          : TColor4;
function ColorGrey(alpha: Byte = 255)          : TColor4;
function ColorMagenta(alpha: Byte = 255)       : TColor4;
function ColorMaroon(alpha: Byte = 255)        : TColor4;
function ColorNavy(alpha: Byte = 255)          : TColor4;
function ColorOlive(alpha: Byte = 255)         : TColor4;
function ColorOrange(alpha: Byte = 255)        : TColor4;
function ColorPink(alpha: Byte = 255)          : TColor4;
function ColorPurple(alpha: Byte = 255)        : TColor4;
function ColorSilver(alpha: Byte = 255)        : TColor4;
function ColorTeal(alpha: Byte = 255)          : TColor4;
function ColorViolet(alpha: Byte = 255)        : TColor4;
function ColorYellow(alpha: Byte = 255)        : TColor4;

function ColorOfficialOrange(alpha: Byte = 255): TColor4;
function ColorOfficialBlack(alpha: Byte = 255) : TColor4;

function Point2(): TPoint2;                                                 overload; {$IF COMPILERVERSION >= 18}inline;{$IFEND}
function Point2(x,y : Single): TPoint2;                                     overload; {$IF COMPILERVERSION >= 18}inline;{$IFEND}
function Point2(const Floats: Array of Single): TPoint2;                    overload;

// TPoint2 operators
function Add(const stLeft, stRight: TPoint2): TPoint2;                      overload; {$IF COMPILERVERSION >= 18}inline;{$IFEND}
function Subtract(const stLeft, stRight: TPoint2): TPoint2;                 overload; {$IF COMPILERVERSION >= 18}inline;{$IFEND}
function Multiply(const stLeft, stRight: TPoint2): TPoint2;                 overload; {$IF COMPILERVERSION >= 18}inline;{$IFEND}
function Divide(const stLeft, stRight: TPoint2): TPoint2;                   overload; {$IF COMPILERVERSION >= 18}inline;{$IFEND}
function Add(const stLeft: TPoint2; fRight: Single): TPoint2;               overload; {$IF COMPILERVERSION >= 18}inline;{$IFEND}
function Subtract(const stLeft: TPoint2; fRight: Single): TPoint2;          overload; {$IF COMPILERVERSION >= 18}inline;{$IFEND}
function Multiply(const stLeft: TPoint2; fRight: Single): TPoint2;          overload; {$IF COMPILERVERSION >= 18}inline;{$IFEND}
function Divide(const stLeft: TPoint2; fRight: Single): TPoint2;            overload; {$IF COMPILERVERSION >= 18}inline;{$IFEND}
// TPoint2 functions
function Dot(const stLeft, stRight: TPoint2): Single;                       overload; {$IF COMPILERVERSION >= 18}inline;{$IFEND}
function Cross(const stLeft, stRight: TPoint2): Single;                     overload; {$IF COMPILERVERSION >= 18}inline;{$IFEND}
function DistTo(const stLeft, stRight: TPoint2): Single;                    overload; {$IF COMPILERVERSION >= 18}inline;{$IFEND}
function DistToQ(const stLeft, stRight: TPoint2): Single;                   overload; {$IF COMPILERVERSION >= 18}inline;{$IFEND}
function LengthQ(stPoint: TPoint2): Single;                                 overload; {$IF COMPILERVERSION >= 18}inline;{$IFEND}
function Length(const stPoint: TPoint2): Single;                            overload; {$IF COMPILERVERSION >= 18}inline;{$IFEND}
function Normalize(const stPoint: TPoint2): TPoint2;                        overload; {$IF COMPILERVERSION >= 18}inline;{$IFEND}
function Lerp(const stLeft, stRight: TPoint2; coeff: Single): TPoint2;      overload; {$IF COMPILERVERSION >= 18}inline;{$IFEND}
function Angle(const stLeft, stRight: TPoint2): Single;                     overload; {$IF COMPILERVERSION >= 18}inline;{$IFEND}
function Rotate(const stLeft: TPoint2; fAngle: Single): TPoint2;            overload; {$IF COMPILERVERSION >= 18}inline;{$IFEND}
function Reflect(const stLeft, normal : TPoint2): TPoint2;                  overload; {$IF COMPILERVERSION >= 18}inline;{$IFEND}

function Point3(): TPoint3;                                                 overload; {$IF COMPILERVERSION >= 18}inline;{$IFEND}
function Point3(x,y,z : Single): TPoint3;                                   overload; {$IF COMPILERVERSION >= 18}inline;{$IFEND}
function Point3(const Floats: array of Single): TPoint3;                    overload;

// TPoint3 operators
function Add(const stLeft, stRight: TPoint3): TPoint3;                      overload; {$IF COMPILERVERSION >= 18}inline;{$IFEND}
function Subtract(const stLeft, stRight: TPoint3): TPoint3;                 overload; {$IF COMPILERVERSION >= 18}inline;{$IFEND}
function Multiply(const stLeft, stRight: TPoint3): TPoint3;                 overload; {$IF COMPILERVERSION >= 18}inline;{$IFEND}
function Divide(const stLeft, stRight: TPoint3): TPoint3;                   overload; {$IF COMPILERVERSION >= 18}inline;{$IFEND}
function Add(const stLeft: TPoint3; fRight: Single): TPoint3;               overload; {$IF COMPILERVERSION >= 18}inline;{$IFEND}
function Subtract(const stLeft: TPoint3; fRight: Single): TPoint3;          overload; {$IF COMPILERVERSION >= 18}inline;{$IFEND}
function Multiply(const stLeft: TPoint3; fRight: Single): TPoint3;          overload; {$IF COMPILERVERSION >= 18}inline;{$IFEND}
function Divide(const stLeft: TPoint3; fRight: Single): TPoint3;            overload; {$IF COMPILERVERSION >= 18}inline;{$IFEND}
// TPoint3 functions
function Dot(const stLeft, stRight: TPoint3): Single;                       overload; {$IF COMPILERVERSION >= 18}inline;{$IFEND}
function Cross(const stLeft, stRight: TPoint3): TPoint3;                    overload; {$IF COMPILERVERSION >= 18}inline;{$IFEND}
function FlatDistTo(const stLeft, stRight: TPoint3): Single;                {$IF COMPILERVERSION >= 18}inline;{$IFEND}
function DistTo(const stLeft, stRight: TPoint3): Single;                    overload; {$IF COMPILERVERSION >= 18}inline;{$IFEND}
function DistToQ(const stLeft, stRight: TPoint3): Single;                   overload; {$IF COMPILERVERSION >= 18}inline;{$IFEND}
function LengthQ(const stPoint: TPoint3): Single;                           overload; {$IF COMPILERVERSION >= 18}inline;{$IFEND}
function Length(const stPoint: TPoint3): Single;                            overload; {$IF COMPILERVERSION >= 18}inline;{$IFEND}
function Normalize(const stPoint: TPoint3): TPoint3;                        overload; {$IF COMPILERVERSION >= 18}inline;{$IFEND}
function Lerp(const stLeft, stRight: TPoint3; coeff: Single): TPoint3;      overload; {$IF COMPILERVERSION >= 18}inline;{$IFEND}
function Angle(const stLeft, stRight: TPoint3): Single;                     overload; {$IF COMPILERVERSION >= 18}inline;{$IFEND}
function Rotate(const stLeft, Axis: TPoint3; fAngle: Single): TPoint3;      overload; {$IF COMPILERVERSION >= 18}inline;{$IFEND}
function Reflect(const stLeft, normal : TPoint3): TPoint3;                  overload; {$IF COMPILERVERSION >= 18}inline;{$IFEND}

function Vertex2(x,y,u,w,r,g,b,a : Single): TVertex2;                       {$IF COMPILERVERSION >= 18}inline;{$IFEND}

function RectF(): TRectf;                                                   overload;  {$IF COMPILERVERSION >= 18}inline;{$IFEND}
function RectF(x, y, width, height: Single): TRectf;                        overload;  {$IF COMPILERVERSION >= 18}inline;{$IFEND}
function RectF(const stLeftTop, stRightBottom: TPoint2): TRectf;            overload;  {$IF COMPILERVERSION >= 18}inline;{$IFEND}
function IntersectRect(const stRect1, stRect2: TRectf):Boolean;             {$IF COMPILERVERSION >= 18}inline;{$IFEND}
function PointInRect(const stPoint: TPoint2; const stRect: TRectf):Boolean; {$IF COMPILERVERSION >= 18}inline;{$IFEND}
function RectInRect(const stRect1, stRect2: TRectf): Boolean;               {$IF COMPILERVERSION >= 18}inline;{$IFEND}
function GetIntersectionRect(const stRect1, stRect2: TRectf): TRectf;       {$IF COMPILERVERSION >= 18}inline;{$IFEND}

function Matrix(): TMatrix4x4;                                              {$IF COMPILERVERSION >= 18}inline;{$IFEND}
function MatrixMulGL(stMLeft, stMRight : TMatrix4x4): TMatrix4x4;           {$IF COMPILERVERSION >= 18}inline;{$IFEND}
function MatrixInverse(const stMatrix : TMatrix4x4): TMatrix4x4;
function MatrixTranspose(const stMatrix : TMatrix4x4): TMatrix4x4;          {$IF COMPILERVERSION >= 18}inline;{$IFEND}
function MatrixIdentity(): TMatrix4x4;                                      {$IF COMPILERVERSION >= 18}inline;{$IFEND}
function MatrixScale(const fVec : TPoint3): TMatrix4x4;                     {$IF COMPILERVERSION >= 18}inline;{$IFEND}
function MatrixTranslate(const fVec : TPoint3): TMatrix4x4;                 {$IF COMPILERVERSION >= 18}inline;{$IFEND}
function MatrixRotate(angle : Single; const stAxis : TPoint3): TMatrix4x4;  {$IF COMPILERVERSION >= 18}inline;{$IFEND}
function MatrixBillboard(const stMatrix : TMatrix4x4): TMatrix4x4;          {$IF COMPILERVERSION >= 18}inline;{$IFEND}
// Matrix operators
function MatrixSub(const stLeftMatrix, stRightMatrix : TMatrix4x4): TMatrix4x4;   overload; {$IF COMPILERVERSION >= 18}inline;{$IFEND}
function MatrixAdd(const stLeftMatrix, stRightMatrix : TMatrix4x4): TMatrix4x4;   overload; {$IF COMPILERVERSION >= 18}inline;{$IFEND}
function MatrixMul(const stLeftMatrix, stRightMatrix : TMatrix4x4): TMatrix4x4;   overload; {$IF COMPILERVERSION >= 18}inline;{$IFEND}
function MatrixSub(const stLeftMatrix: TMatrix4x4; right: Single): TMatrix4x4;    overload; {$IF COMPILERVERSION >= 18}inline;{$IFEND}
function MatrixAdd(const stLeftMatrix: TMatrix4x4; right: Single): TMatrix4x4;    overload; {$IF COMPILERVERSION >= 18}inline;{$IFEND}
function MatrixDiv(const stLeftMatrix: TMatrix4x4; right: Single): TMatrix4x4;    overload; {$IF COMPILERVERSION >= 18}inline;{$IFEND}
function MatrixMul(const stLeftMatrix: TMatrix4x4; right: Single): TMatrix4x4;    overload; {$IF COMPILERVERSION >= 18}inline;{$IFEND}
function ApplyToPoint(const stLeftMatrix: TMatrix4x4; stPoint: TPoint3): TPoint3; overload; {$IF COMPILERVERSION >= 18}inline;{$IFEND}
function ApplyToPoint(const stLeftMatrix: TMatrix4x4; stPoint: TPoint2): TPoint2; overload; {$IF COMPILERVERSION >= 18}inline;{$IFEND}
function ApplyToVector(const stLeftMatrix: TMatrix4x4; stPoint: TPoint3): TPoint3; {$IF COMPILERVERSION >= 18}inline;{$IFEND}


function EngWindow(): TEngineWindow;                                      overload; {$IF COMPILERVERSION >= 18}inline;{$IFEND}
function EngWindow(uiWidth, uiHeight: Integer; bFullScreen: Boolean;
  bVSync: Boolean = False; eMSampling: {E_MULTISAMPLING_MODE}Cardinal = MM_NONE;
  uiFlags: {ENG_WINDOW_FLAGS}Integer = EWF_DEFAULT): TEngineWindow;        overload; {$IF COMPILERVERSION >= 18}inline;{$IFEND}

implementation

uses
  Math,
  DGLE; // gets constants about SDK

function Color4(r,g,b,a: Single): TColor4;
begin
  Result.r := r;
  Result.g := g;
  Result.b := b;
  Result.a := a;
end;

function Color4(r,g,b,a: Byte): TColor4; overload;
begin
  Result.r := r/255.;
  Result.g := g/255.;
  Result.b := b/255.;
  Result.a := a/255.;
end;

function Color4(color : Cardinal; alpha : Byte = 255): TColor4; overload;
begin
  Result.r := Byte(color shr 16)/255.;
  Result.g := Byte(color shr 8)/255.;
  Result.b := Byte(color)/255.;
  Result.a := alpha/255.;
end;

function Color4(): TColor4; overload;
begin
  Result.r := 1.;
  Result.g := 1.;
  Result.b := 1.;
  Result.a := 1.;
end;

function Color4(const rgba: array of Single): TColor4;
begin
  Result.r := rgba[0];
  Result.g := rgba[1];
  Result.b := rgba[2];
  Result.a := rgba[3];
end;

{$IF COMPILERVERSION >= 18}
constructor TColor4.Create(var dummy);
begin
  Self := Color4();
end;

constructor TColor4.Create(ui32ABGR: Cardinal);
begin
  Self := Color4(ui32ABGR);
end;

constructor TColor4.Create(ui32RGB: Cardinal; ubA: byte);
begin
  Self := Color4(ui32RGB, ubA);
end;

constructor TColor4.Create(ubR, ubG, ubB, ubA: Byte);
begin
  Self := Color4(ubR, ubG, ubB, ubA);
end;

constructor TColor4.Create(fR, fG, fB, fA: Single);
begin
  Self := Color4(fR, fG, fB, fA);
end;

constructor TColor4.Create(const rgba: array of Single);
begin
  Self := Color4(rgba);
end;

procedure TColor4.SetColorF(fR, fG, fB, fA: Single);
begin
  Self := Color4(fR, fG, fB, fA);
end;

procedure TColor4.SetColorB(ubR, ubG, ubB, ubA: Byte);
begin
  Self := Color4(ubR, ubG, ubB, ubA);
end;

function TColor4.ColorRGB(): Cardinal;
begin
  Result := Round($FF * r + $FFFF * g + $FFFFFF * b);
end;

function TColor4.ColorRGBA(): Cardinal;
begin
  Result := Round($FF * r + $FFFF * g + $FFFFFF * b + $FFFFFFFF * a);
end;
{$IFEND}

{$IF COMPILERVERSION >= 20}
class operator TColor4.Implicit(Color: TColor4): Cardinal;
begin
  Result := Color.ColorRGBA();
end;
{$IFEND}

function ColorClear(alpha: Byte = 255)         : TColor4;
begin
  Result := Color4($00, $00, $00, alpha);
end;

function ColorWhite(alpha: Byte = 255)         : TColor4;
begin
  Result := Color4($FF, $FF, $FF, alpha);
end;

function ColorBlack(alpha: Byte = 255)         : TColor4;
begin
  Result := Color4($00, $00, $00, alpha);
end;

function ColorRed(alpha: Byte = 255)           : TColor4;
begin
  Result := Color4($FF, $00, $00, alpha);
end;

function ColorGreen(alpha: Byte = 255)         : TColor4;
begin
  Result := Color4($00, $FF, $00, alpha);
end;

function ColorBlue(alpha: Byte = 255)          : TColor4;
begin
  Result := Color4($00, $00, $FF, alpha);
end;

function ColorAqua(alpha: Byte = 255)          : TColor4;
begin
  Result := Color4($00, $FF, $FF, alpha);
end;

function ColorBrown(alpha: Byte = 255)         : TColor4;
begin
  Result := Color4($A5, $2A, $2A, alpha);
end;

function ColorCyan(alpha: Byte = 255)          : TColor4;
begin
  Result := Color4($00, $FF, $FF, alpha);
end;

function ColorFuchsia(alpha: Byte = 255)       : TColor4;
begin
  Result := Color4($FF, $00, $FF, alpha);
end;

function ColorGray(alpha: Byte = 255)          : TColor4;
begin
  Result := Color4($80, $80, $80, alpha);
end;

function ColorGrey(alpha: Byte = 255)          : TColor4;
begin
  Result := Color4($80, $80, $80, alpha);
end;

function ColorMagenta(alpha: Byte = 255)       : TColor4;
begin
  Result := Color4($FF, $00, $FF, alpha);
end;

function ColorMaroon(alpha: Byte = 255)        : TColor4;
begin
  Result := Color4($80, $00, $00, alpha);
end;

function ColorNavy(alpha: Byte = 255)          : TColor4;
begin
  Result := Color4($00, $00, $80, alpha);
end;

function ColorOlive(alpha: Byte = 255)         : TColor4;
begin
  Result := Color4($80, $80, $00, alpha);
end;

function ColorOrange(alpha: Byte = 255)        : TColor4;
begin
  Result := Color4($FF, $A5, $00, alpha);
end;

function ColorPink(alpha: Byte = 255)          : TColor4;
begin
  Result := Color4($FF, $C0, $CB, alpha);
end;

function ColorPurple(alpha: Byte = 255)        : TColor4;
begin
  Result := Color4($80, $00, $80, alpha);
end;

function ColorSilver(alpha: Byte = 255)        : TColor4;
begin
  Result := Color4($C0, $C0, $C0, alpha);
end;

function ColorTeal(alpha: Byte = 255)          : TColor4;
begin
  Result := Color4($00, $80, $80, alpha);
end;

function ColorViolet(alpha: Byte = 255)        : TColor4;
begin
  Result := Color4($EE, $82, $EE, alpha);
end;

function ColorYellow(alpha: Byte = 255)        : TColor4;
begin
  Result := Color4($FF, $FF, $00, alpha);
end;

function ColorOfficialOrange(alpha: Byte = 255): TColor4;
begin
  Result := Color4($E7, $78, $17, alpha);
end;

function ColorOfficialBlack(alpha: Byte = 255) : TColor4;
begin
  Result := Color4($38, $34, $31, alpha);
end;

function Point2(): TPoint2; overload;
begin
  Result.x := 0.;
  Result.y := 0.;
end;

function Point2(x,y : Single): TPoint2; overload;
begin
  Result.x := x;
  Result.y := y;
end;

function Point2(const Floats: array of Single): TPoint2; overload;
begin
  Result.x := Floats[0];
  Result.y := Floats[1];
end;

function Add(const stLeft, stRight: TPoint2): TPoint2;
begin
  Result := Point2(stLeft.x + stRight.x, stLeft.y + stRight.y);
end;

function Subtract(const stLeft, stRight: TPoint2): TPoint2;
begin
  Result := Point2(stLeft.x - stRight.x, stLeft.y - stRight.y);
end;

function Multiply(const stLeft, stRight: TPoint2): TPoint2;
begin
  Result := Point2(stLeft.x * stRight.x, stLeft.y * stRight.y);
end;

function Divide(const stLeft, stRight: TPoint2): TPoint2;
begin
  Result := Point2(stLeft.x / stRight.x, stLeft.y / stRight.y);
end;

function Add(const stLeft: TPoint2; fRight: Single): TPoint2;
begin
  Result := Point2(stLeft.x + fRight, stLeft.y + fRight);
end;

function Subtract(const stLeft: TPoint2; fRight: Single): TPoint2;
begin
  Result := Point2(stLeft.x - fRight, stLeft.y - fRight);
end;

function Multiply(const stLeft: TPoint2; fRight: Single): TPoint2;
begin
  Result := Point2(stLeft.x * fRight, stLeft.y * fRight);
end;

function Divide(const stLeft: TPoint2; fRight: Single): TPoint2;
begin
  Result := Point2(stLeft.x / fRight, stLeft.y / fRight);
end;

{$IF COMPILERVERSION >= 20}
class operator TPoint2.Add(const stLeft, stRight: TPoint2): TPoint2;
begin
  Result := Point2(stLeft.x + stRight.x, stLeft.y + stRight.y);
end;

class operator TPoint2.Subtract(const stLeft, stRight: TPoint2): TPoint2;
begin
  Result := Point2(stLeft.x - stRight.x, stLeft.y - stRight.y);
end;

class operator TPoint2.Multiply(const stLeft, stRight: TPoint2): TPoint2;
begin
  Result := Point2(stLeft.x * stRight.x, stLeft.y * stRight.y);
end;

class operator TPoint2.Divide(const stLeft, stRight: TPoint2): TPoint2;
begin
  Result := Point2(stLeft.x / stRight.x, stLeft.y / stRight.y);
end;

class operator TPoint2.Add(const stLeft: TPoint2; fRight: Single): TPoint2;
begin
  Result := Point2(stLeft.x + fRight, stLeft.y + fRight);
end;

class operator TPoint2.Subtract(const stLeft: TPoint2; fRight: Single): TPoint2;
begin
  Result := Point2(stLeft.x - fRight, stLeft.y - fRight);
end;

class operator TPoint2.Multiply(const stLeft: TPoint2; fRight: Single): TPoint2;
begin
  Result := Point2(stLeft.x * fRight, stLeft.y * fRight);
end;

class operator TPoint2.Divide(const stLeft: TPoint2; fRight: Single): TPoint2;
begin
  Result := Point2(stLeft.x / fRight, stLeft.y / fRight);
end;
{$IFEND}

function Dot(const stLeft, stRight: TPoint2): Single;
begin
  Result := stLeft.x * stRight.x + stLeft.y * stRight.y;
end;

function Cross(const stLeft, stRight: TPoint2): Single;
begin
  Result := stLeft.x * stRight.y - stRight.x * stLeft.y;
end;

function DistTo(const stLeft, stRight: TPoint2): Single;
begin
  Result := Sqrt((stRight.x - stLeft.x)*(stRight.x - stLeft.x) + (stRight.y - stLeft.y)*(stRight.y - stLeft.y));
end;

function DistToQ(const stLeft, stRight: TPoint2): Single;
begin
  Result := LengthQ(Subtract(stRight, stLeft));
end;

function LengthQ(stPoint: TPoint2): Single;
begin
  Result := stPoint.x * stPoint.x + stPoint.y * stPoint.y;
end;

function Length(const stPoint: TPoint2): Single;
begin
  Result := Sqrt(LengthQ(stPoint));
end;

function Normalize(const stPoint: TPoint2): TPoint2;
begin
  Result := Divide(stPoint, Length(stPoint));
end;

function Lerp(const stLeft, stRight: TPoint2; coeff: Single): TPoint2;
begin
  Result := Add(stLeft, Multiply(Subtract(stRight, stLeft), coeff));
end;

function Angle(const stLeft, stRight: TPoint2): Single;
begin
  Result := ArcTan2(stLeft.x * stRight.y - stLeft.y * stRight.x, stLeft.x * stRight.x + stLeft.y * stRight.y);
end;

function Rotate(const stLeft: TPoint2; fAngle: Single): TPoint2;
var
  s, c: Single;
begin
  s := sin(fAngle);
  c := cos(fAngle);
  Result := Point2(stLeft.x * c - stLeft.y * s, stLeft.x * s + stLeft.y * c);
end;

function Reflect(const stLeft, normal : TPoint2): TPoint2;
begin
  Result := Subtract(stLeft, Multiply(normal, Dot(stLeft,normal)* 2));
end;

{$IF COMPILERVERSION >= 18}
constructor TPoint2.Create (var dummy);
begin
  Self := Point2();
end;

constructor TPoint2.Create (x, y : Single);
begin
  Self := Point2(x, y);
end;

constructor TPoint2.Create (const Floats: Array of Single);
begin
  Self := Point2(Floats);
end;

function TPoint2.Dot(const stPoint: TPoint2): Single;
begin
  Result := x * stPoint.x + y * stPoint.y;
end;

function TPoint2.Cross(const stPoint: TPoint2): Single;
begin
  Result := x * stPoint.y - stPoint.x * y;
end;

function TPoint2.DistTo(const stPoint: TPoint2): Single;
begin
  Result := Sqrt((stPoint.x - x)*(stPoint.x - x) + (stPoint.y - y)*(stPoint.y - y));
end;

function TPoint2.DistToQ(const stPoint: TPoint2): Single;
begin
  Result := Subtract(stPoint, self).LengthQ();
end;

function TPoint2.LengthQ(): Single;
begin
  Result := x*x + y*y;
end;

function TPoint2.Length(): Single;
begin
  Result := Sqrt(LengthQ());
end;

function TPoint2.Normalize(): TPoint2;
begin
  Self := Divide(Self, Self.Length());
  Result := Self;
end;

function TPoint2.Lerp(const stPoint: TPoint2; coeff: Single): TPoint2;
begin
  Result := Add(Self, Multiply(Subtract(stPoint, Self), coeff));
end;

function TPoint2.Angle(const stPoint: TPoint2): Single;
begin
  Result := ArcTan2(x * stPoint.y - y * stPoint.x, x * stPoint.x + y * stPoint.y);
end;

function TPoint2.Rotate(fAngle: Single): TPoint2;
var
  s, c: Single;
begin
  s := sin(fAngle);
  c := cos(fAngle);
  Result := Point2(x * c - y * s, x * s + y * c);
end;

function TPoint2.Reflect(const normal : TPoint2): TPoint2;
begin
  Result := Subtract(Self, Multiply(normal, Dot(normal) * 2));
end;
{$IFEND}

function Point3(): TPoint3; overload;
begin
  Result.x := 0.;
  Result.y := 0.;
  Result.z := 0.;
end;

function Point3(x,y,z : Single): TPoint3; overload;
begin
  Result.x := x;
  Result.y := y;
  Result.z := z;
end;

function Point3(const Floats: array of Single): TPoint3; overload;
begin
  Result.x := Floats[0];
  Result.y := Floats[1];
  Result.z := Floats[2];
end;

function Add(const stLeft, stRight: TPoint3): TPoint3;
begin
  Result := Point3(stLeft.x + stRight.x, stLeft.y + stRight.y, stLeft.z + stRight.z);
end;

function Subtract(const stLeft, stRight: TPoint3): TPoint3;
begin
  Result := Point3(stLeft.x - stRight.x, stLeft.y - stRight.y, stLeft.z - stRight.z);
end;

function Multiply(const stLeft, stRight: TPoint3): TPoint3;
begin
  Result := Point3(stLeft.x * stRight.x, stLeft.y * stRight.y, stLeft.z * stRight.z);
end;

function Divide(const stLeft, stRight: TPoint3): TPoint3;
begin
  Result := Point3(stLeft.x / stRight.x, stLeft.y / stRight.y, stLeft.z / stRight.z);
end;

function Add(const stLeft: TPoint3; fRight: Single): TPoint3;
begin
  Result := Point3(stLeft.x + fRight, stLeft.y + fRight, stLeft.z + fRight);
end;

function Subtract(const stLeft: TPoint3; fRight: Single): TPoint3;
begin
  Result := Point3(stLeft.x - fRight, stLeft.y - fRight, stLeft.z - fRight);
end;

function Multiply(const stLeft: TPoint3; fRight: Single): TPoint3;
begin
  Result := Point3(stLeft.x * fRight, stLeft.y * fRight, stLeft.z * fRight);
end;

function Divide(const stLeft: TPoint3; fRight: Single): TPoint3;
begin
  Result := Point3(stLeft.x / fRight, stLeft.y / fRight, stLeft.z / fRight);
end;

{$IF COMPILERVERSION >= 20}
class operator TPoint3.Add(const stLeft, stRight: TPoint3): TPoint3;
begin
  Result := Point3(stLeft.x + stRight.x, stLeft.y + stRight.y, stLeft.z + stRight.z);
end;

class operator TPoint3.Subtract(const stLeft, stRight: TPoint3): TPoint3;
begin
  Result := Point3(stLeft.x - stRight.x, stLeft.y - stRight.y, stLeft.z - stRight.z);
end;

class operator TPoint3.Multiply(const stLeft, stRight: TPoint3): TPoint3;
begin
  Result := Point3(stLeft.x * stRight.x, stLeft.y * stRight.y, stLeft.z * stRight.z);
end;

class operator TPoint3.Divide(const stLeft, stRight: TPoint3): TPoint3;
begin
  Result := Point3(stLeft.x / stRight.x, stLeft.y / stRight.y, stLeft.z / stRight.z);
end;

class operator TPoint3.Add(const stLeft: TPoint3;const  fRight: Single): TPoint3;
begin
  Result := Point3(stLeft.x + fRight, stLeft.y + fRight, stLeft.z + fRight);
end;

class operator TPoint3.Subtract(const stLeft: TPoint3; const fRight: Single): TPoint3;
begin
  Result := Point3(stLeft.x - fRight, stLeft.y - fRight, stLeft.z - fRight);
end;

class operator TPoint3.Multiply(const stLeft: TPoint3; const fRight: Single): TPoint3;
begin
  Result := Point3(stLeft.x * fRight, stLeft.y * fRight, stLeft.z * fRight);
end;

class operator TPoint3.Divide(const stLeft: TPoint3; const fRight: Single): TPoint3;
begin
  Result := Point3(stLeft.x / fRight, stLeft.y / fRight, stLeft.z / fRight);
end;
{$IFEND}

function Dot(const stLeft, stRight: TPoint3): Single;
begin
  Result := stLeft.x * stRight.x + stLeft.y * stRight.y + stLeft.z * stRight.z;
end;

function Cross(const stLeft, stRight: TPoint3): TPoint3;
begin
  Result := Point3(stLeft.y * stRight.z - stLeft.z * stRight.y, stLeft.z * stRight.x - stLeft.x * stRight.z, stLeft.x * stRight.y - stLeft.y * stRight.x);
end;

function FlatDistTo(const stLeft, stRight: TPoint3): Single;
begin
  Result := Sqrt((stRight.x - stLeft.x)*(stRight.x - stLeft.x) + (stRight.y - stLeft.y)*(stRight.y - stLeft.y));
end;

function DistTo(const stLeft, stRight: TPoint3): Single;
begin
  Result := Sqrt((stRight.x - stLeft.x)*(stRight.x - stLeft.x) + (stRight.y - stLeft.y)*(stRight.y - stLeft.y) + (stRight.z - stLeft.z)*(stRight.z - stLeft.z));
end;

function DistToQ(const stLeft, stRight: TPoint3): Single;
begin
  Result := LengthQ(Subtract(stRight, stLeft));
end;

function LengthQ(const stPoint: TPoint3): Single;
begin
  Result := stPoint.x * stPoint.x + stPoint.y * stPoint.y + stPoint.y * stPoint.y;
end;

function Length(const stPoint: TPoint3): Single;
begin
  Result := Sqrt(LengthQ(stPoint));
end;

function Normalize(const stPoint: TPoint3): TPoint3;
begin
  Result := Divide(stPoint, Length(stPoint));
end;

function Lerp(const stLeft, stRight: TPoint3; coeff: Single): TPoint3;
begin
  Result := Add(stLeft, Multiply(Subtract(stRight, stLeft), coeff));
end;

function Angle(const stLeft, stRight: TPoint3): Single;
begin
  Result := ArcCos(Dot (stLeft, stRight)/ Sqrt(LengthQ(stLeft) * LengthQ(stRight)));
end;

function Rotate(const stLeft, Axis: TPoint3; fAngle: Single): TPoint3;
var
  s, c: Single;
  v: array[0..2] of TPoint3;
begin
  s := sin(fAngle);
  c := cos(fAngle);
  v[0] := Multiply(Axis, Dot(stLeft, Axis));
  v[1] := Subtract(stLeft, v[0]);
  v[2] := Cross(Axis, v[1]);
  Result := Point3(v[0].x + v[1].x * c + v[2].x * s, v[0].y + v[1].y * c + v[2].y * s, v[0].z + v[1].z * c + v[2].z * s);
end;

function Reflect(const stLeft, normal : TPoint3): TPoint3;
begin
  Result := Subtract(stLeft, Multiply(normal, Dot(stLeft,normal) * 2));
end;

{$IF COMPILERVERSION >= 18}
constructor TPoint3.Create (var dummy);
begin
  Self := Point3();
end;

constructor TPoint3.Create (x, y, z : Single);
begin
  Self := Point3(x, y, z);
end;

constructor TPoint3.Create (const Floats: Array of Single);
begin
  Self := Point3(Floats);
end;

function TPoint3.Dot(const stPoint: TPoint3): Single;
begin
  Result := x * stPoint.x + y * stPoint.y;
end;

function TPoint3.Cross(const stPoint: TPoint3): TPoint3;
begin
  Result := Point3(y * stPoint.z - z * stPoint.y, z * stPoint.x - x * stPoint.z, x * stPoint.y - y * stPoint.x);
end;

function TPoint3.FlatDistTo(const stPoint: TPoint3): Single;
begin
  Result := Sqrt((stPoint.x - x)*(stPoint.x - x) + (stPoint.y - y)*(stPoint.y - y));
end;

function TPoint3.DistTo(const stPoint: TPoint3): Single;
begin
  Result := Sqrt((stPoint.x - x)*(stPoint.x - x) + (stPoint.y - y)*(stPoint.y - y) + (stPoint.z - z)*(stPoint.z - z));
end;

function TPoint3.DistToQ(const stPoint: TPoint3): Single;
begin
  Result := Subtract(stPoint, self).LengthQ();
end;

function TPoint3.LengthQ(): Single;
begin
  Result := x*x + y*y + z*z;
end;

function TPoint3.Length(): Single;
begin
  Result := Sqrt(LengthQ());
end;

function TPoint3.Normalize(): TPoint3;
begin
  Self := Divide(Self, Self.Length());
  Result := Self;
end;

function TPoint3.Lerp(const stPoint: TPoint3; coeff: Single): TPoint3;
begin
  Result := Add(Self, Multiply(Subtract(stPoint, Self), coeff));
end;

function TPoint3.Angle(const stPoint: TPoint3): Single;
begin
  Result := ArcCos(Dot(stPoint)/ Sqrt(LengthQ() * stPoint.LengthQ()));
end;

function TPoint3.Rotate(const Axis: TPoint3; fAngle: Single): TPoint3;
var
  s, c: Single;
  v: array[0..2] of TPoint3;
begin
  s := sin(fAngle);
  c := cos(fAngle);
  v[0] := Multiply(Axis, Dot(Axis));
  v[1] := Subtract(Self, v[0]);
  v[2] := DGLE_types.Cross(Axis, v[1]);
  Result := Point3(v[0].x + v[1].x * c + v[2].x * s, v[0].y + v[1].y * c + v[2].y * s, v[0].z + v[1].z * c + v[2].z * s);
end;

function TPoint3.Reflect(const normal : TPoint3): TPoint3;
begin
  Result := Subtract(Self, Multiply(normal, Dot(normal) * 2));
end;
{$IFEND}

function Vertex2(x,y,u,w,r,g,b,a : Single): TVertex2;
begin
  Result.x := x;
  Result.y := y;
  Result.u := u;
  Result.w := w;
  Result.r := r;
  Result.g := g;
  Result.b := b;
  Result.a := a;
end;

function RectF(x, y, width, height : Single): TRectf; overload;
begin
  Result.x      := x;
  Result.y      := y;
  Result.width  := width;
  Result.height := height;
end;

function RectF(): TRectf; overload;
begin
  Result.x      := 0;
  Result.y      := 0;
  Result.width  := 0;
  Result.height := 0;
end;

function RectF(const stLeftTop, stRightBottom: TPoint2): TRectf; overload;
begin
  Result.x      := stLeftTop.x;
  Result.y      := stLeftTop.y;
  Result.width  := stRightBottom.x - stLeftTop.x;
  Result.height  := stRightBottom.y - stLeftTop.y;
end;

function IntersectRect(const stRect1, stRect2 : TRectf):Boolean;
begin
  Result :=
    ((stRect1.x < stRect2.x + stRect2.width) and
    (stRect1.x + stRect1.width > stRect2.x) and
    (stRect1.y < stRect2.y + stRect2.height) and
    (stRect1.y + stRect1.height > stRect2.y)) or
    ((stRect2.x + stRect2.width < stRect1.x) and
    (stRect2.x > stRect1.x + stRect1.width) and
    (stRect2.y + stRect2.height < stRect1.y) and
    (stRect2.y > stRect1.y + stRect1.height));
end;

function PointInRect(const stPoint : TPoint2; const stRect : TRectf):Boolean;
begin
  Result := (stPoint.x > stRect.x) and (stPoint.x < stRect.x + stRect.width)
    and (stPoint.y > stRect.y) and (stPoint.y < stRect.y + stRect.height);
end;

function RectInRect(const stRect1, stRect2 : TRectf): Boolean;
begin
  Result := (stRect1.x < stRect2.x) and (stRect1.y < stRect2.y) and
    (stRect1.x + stRect1.width > stRect2.x + stRect2.width) and
    (stRect1.y + stRect1.height > stRect2.y + stRect2.height);
end;

function GetIntersectionRect(const stRect1, stRect2: TRectf): TRectf;
begin
  Result := stRect1;
  if stRect2.x > stRect1.x then
    Result.x := stRect2.x;
  if stRect2.y > stRect1.y then
    Result.y := stRect2.y;
  Result.width := Min(stRect2.x + stRect2.width, stRect1.x+ stRect1.width) - Result.x;
  Result.height := Min(stRect2.y + stRect2.height, stRect1.y + stRect1.height) - Result.y;
  if (Result.width <= 0) or (Result.height <= 0) then
    Result := Rectf;
end;

{$IF COMPILERVERSION >= 18}

constructor TRectF.Create(var dummy);
begin
  Self := RectF();
end;

constructor TRectF.Create(x, y, width, height : Single);
begin
  Self := RectF(x, y, width, height);
end;

constructor TRectF.Create(const stLeftTop, stRightBottom: TPoint2);
begin
  Self := RectF(stLeftTop, stRightBottom);
end;

function TRectF.IntersectRect(const stRect: TRectf):Boolean;
begin
  Result := DGLE_types.IntersectRect(Self, stRect);
end;

function TRectF.PointInRect(const stPoint: TPoint2):Boolean;
begin
  Result := DGLE_types.PointInRect(stPoint, Self);
end;

function TRectF.RectInRect(const stRect: TRectf): Boolean;
begin
  Result := DGLE_types.RectInRect(Self, stRect);
end;

function TRectF.GetIntersectionRect(const stRect: TRectf): TRectf;
begin
  Result := DGLE_types.GetIntersectionRect(Self, stRect);
end;
{$IFEND}


function Matrix(): TMatrix4x4;
begin
  ZeroMemory(@Result._1D, 16 * SizeOf(Single));
end;

function MatrixMulGL(stMLeft, stMRight : TMatrix4x4): TMatrix4x4;
begin
  result := MatrixMul(stMRight, stMLeft);
end;

function MatrixInverse(const stMatrix : TMatrix4x4): TMatrix4x4;
type
  MatrixRows = array[0..7] of Single;
  PMatrixRows = ^MatrixRows;
var
  mat : array[0..3] of MatrixRows;
  rows : array[0..3] of PMatrixRows;
  i, r, row_num, c : Integer;
  major, cur_ABS, factor : Single;
begin
  mat[0, 0] := stMatrix._2D[0][0];
  mat[0, 1] := stMatrix._2D[0][1];
  mat[0, 2] := stMatrix._2D[0][2];
  mat[0, 3] := stMatrix._2D[0][3];
  mat[0, 4] := 1.0;
  mat[0, 5] := 0.0;
  mat[0, 6] := 0.0;
  mat[0, 7] := 0.0;

  mat[1, 0] := stMatrix._2D[1][0];
  mat[1, 1] := stMatrix._2D[1][1];
  mat[1, 2] := stMatrix._2D[1][2];
  mat[1, 3] := stMatrix._2D[1][3];
  mat[1, 4] := 0.0;
  mat[1, 5] := 1.0;
  mat[1, 6] := 0.0;
  mat[1, 7] := 0.0;

  mat[2, 0] := stMatrix._2D[2][0];
  mat[2, 1] := stMatrix._2D[2][1];
  mat[2, 2] := stMatrix._2D[2][2];
  mat[2, 3] := stMatrix._2D[2][3];
  mat[2, 4] := 0.0;
  mat[2, 5] := 0.0;
  mat[2, 6] := 1.0;
  mat[2, 7] := 0.0;

  mat[3, 0] := stMatrix._2D[3][0];
  mat[3, 1] := stMatrix._2D[3][1];
  mat[3, 2] := stMatrix._2D[3][2];
  mat[3, 3] := stMatrix._2D[3][3];
  mat[3, 4] := 0.0;
  mat[3, 5] := 0.0;
  mat[3, 6] := 0.0;
  mat[3, 7] := 1.0;

  rows[0]   := PMatrixRows(@mat[0]);
  rows[1]   := PMatrixRows(@mat[1]);
  rows[2]   := PMatrixRows(@mat[2]);
  rows[3]   := PMatrixRows(@mat[3]);


  for i := 0 to 3 do
  begin
    row_num := i;
    major := Abs(rows[i, i]);
    for r := i + 1 to 3 do
    begin
      cur_ABS := Abs(rows[r, i]);
      if cur_ABS > major then
      begin
        major := cur_ABS;
        row_num := r;
      end;
    end;
    if row_num <> i then
    begin
      rows[i]       := Pointer(Integer(rows[i]) xor Integer(rows[row_num]));
      rows[row_num] := Pointer(Integer(rows[i]) xor Integer(rows[row_num]));
      rows[i]       := Pointer(Integer(rows[i]) xor Integer(rows[row_num]));
    end;
    for r := i + 1 to 3 do
    begin
      factor := rows[r, i] / rows[i, i];
      for c := i to 7 do rows[r, c] := rows[r, c] - factor * rows[i, c];
    end;
  end;

  for i := 3 downto 1 do
    for r := 0 to i - 1 do
    begin
      factor := rows[r, i] / rows[i, i];
      for c := 4 to 7 do rows[r, c] := rows[r, c] - factor * rows[i, c];
    end;

  Result._2D[0, 0] := rows[0, 4] / rows[0, 0];
  Result._2D[0, 1] := rows[0, 5] / rows[0, 0];
  Result._2D[0, 2] := rows[0, 6] / rows[0, 0];
  Result._2D[0, 3] := rows[0, 7] / rows[0, 0];

  Result._2D[1, 0] := rows[1, 4] / rows[1, 1];
  Result._2D[1, 1] := rows[1, 5] / rows[1, 1];
  Result._2D[1, 2] := rows[1, 6] / rows[1, 1];
  Result._2D[1, 3] := rows[1, 7] / rows[1, 1];

  Result._2D[2, 0] := rows[2, 4] / rows[2, 2];
  Result._2D[2, 1] := rows[2, 5] / rows[2, 2];
  Result._2D[2, 2] := rows[2, 6] / rows[2, 2];
  Result._2D[2, 3] := rows[2, 7] / rows[2, 2];

  Result._2D[3, 0] := rows[3, 4] / rows[3, 3];
  Result._2D[3, 1] := rows[3, 5] / rows[3, 3];
  Result._2D[3, 2] := rows[3, 6] / rows[3, 3];
  Result._2D[3, 3] := rows[3, 7] / rows[3, 3];
end;

function MatrixTranspose(const stMatrix : TMatrix4x4): TMatrix4x4;
begin
  Result._2D[0, 0] := stMatrix._2D[0, 0];
  Result._2D[0, 1] := stMatrix._2D[1, 0];
  Result._2D[0, 2] := stMatrix._2D[2, 0];
  Result._2D[0, 3] := stMatrix._2D[3, 0];

  Result._2D[1, 0] := stMatrix._2D[0, 1];
  Result._2D[1, 1] := stMatrix._2D[1, 1];
  Result._2D[1, 2] := stMatrix._2D[2, 1];
  Result._2D[1, 3] := stMatrix._2D[3, 1];

  Result._2D[2, 0] := stMatrix._2D[0, 2];
  Result._2D[2, 1] := stMatrix._2D[1, 2];
  Result._2D[2, 2] := stMatrix._2D[2, 2];
  Result._2D[2, 3] := stMatrix._2D[3, 2];

  Result._2D[3, 0] := stMatrix._2D[0, 3];
  Result._2D[3, 1] := stMatrix._2D[1, 3];
  Result._2D[3, 2] := stMatrix._2D[2, 3];
  Result._2D[3, 3] := stMatrix._2D[3, 3];
end;

function MatrixIdentity(): TMatrix4x4;
begin
  Result := MatrixScale(Point3(1.0,1.0,1.0));
end;

function MatrixScale(const fVec : TPoint3): TMatrix4x4; overload;
begin
  Result._2D[0, 0] := fVec.x;
  Result._2D[0, 1] := 0.0;
  Result._2D[0, 2] := 0.0;
  Result._2D[0, 3] := 0.0;

  Result._2D[1, 0] := 0.0;
  Result._2D[1, 1] := fVec.y;
  Result._2D[1, 2] := 0.0;
  Result._2D[1, 3] := 0.0;

  Result._2D[2, 0] := 0.0;
  Result._2D[2, 1] := 0.0;
  Result._2D[2, 2] := fVec.z;
  Result._2D[2, 3] := 0.0;

  Result._2D[3, 0] := 0.0;
  Result._2D[3, 1] := 0.0;
  Result._2D[3, 2] := 0.0;
  Result._2D[3, 3] := 1.0;
end;

function MatrixTranslate(const fVec : TPoint3): TMatrix4x4;
begin
  Result := MatrixIdentity();
  Result._1D[12] := fVec.x;
  Result._1D[13] := fVec.y;
  Result._1D[14] := fVec.z;
end;

function MatrixRotate(angle : Single; const stAxis : TPoint3): TMatrix4x4;
var
  axis_norm, x, y, z, sin_angle, cos_angle : Single;
begin
  axis_norm := sqrt(stAxis.x * stAxis.x + stAxis.y * stAxis.y + stAxis.z * stAxis.z);
  x := stAxis.x / axis_norm;
  y := stAxis.y / axis_norm;
  z := stAxis.z / axis_norm;
  sin_angle := sin(angle*Pi/180.0);
  cos_angle := cos(angle*Pi/180.0);

  Result := MatrixIdentity();
  Result._2D[0][0] := (1.0 - x * x) * cos_angle + x * x;
  Result._2D[0][1] := z * sin_angle + x * y * (1.0 - cos_angle);
  Result._2D[0][2] := x * z * (1.0 - cos_angle) - y * sin_angle;

  Result._2D[1][0] := x * y * (1.0 - cos_angle) - z * sin_angle;
  Result._2D[1][1] := (1.0 - y * y) * cos_angle + y * y;
  Result._2D[1][2] := y * z * (1.0 - cos_angle) + x * sin_angle;

  Result._2D[2][0] := x * z * (1.0 - cos_angle) + y * sin_angle;
  Result._2D[2][1] := y * z * (1.0 - cos_angle) - x * sin_angle;
  Result._2D[2][2] := (1.0 - z * z) * cos_angle + z * z;
end;

function MatrixBillboard(const stMatrix : TMatrix4x4): TMatrix4x4;
begin
  Result := MatrixIdentity();
  Result._2D[3, 0] := stMatrix._2D[3, 0];
  Result._2D[3, 1] := stMatrix._2D[3, 1];
  Result._2D[3, 2] := stMatrix._2D[3, 2];
  Result._2D[0, 3] := stMatrix._2D[0, 3];
  Result._2D[1, 3] := stMatrix._2D[1, 3];
  Result._2D[2, 3] := stMatrix._2D[2, 3];
  Result._2D[3, 3] := stMatrix._2D[3, 3];
  Result._2D[0, 0] := Sign(stMatrix._2D[0, 0]) * Length(Point3(stMatrix._2D[0, 0], stMatrix._2D[1, 0], stMatrix._2D[2, 0]));
  Result._2D[1, 1] := Sign(stMatrix._2D[1, 1]) * Length(Point3(stMatrix._2D[0, 1], stMatrix._2D[1, 1], stMatrix._2D[2, 1]));
  Result._2D[2, 2] := Sign(stMatrix._2D[2, 2]) * Length(Point3(stMatrix._2D[0, 2], stMatrix._2D[1, 2], stMatrix._2D[2, 2]));
end;

function MatrixSub (const stLeftMatrix, stRightMatrix : TMatrix4x4): TMatrix4x4;
var i: Integer;
begin
  Result := MatrixIdentity();
  for i := 0 to 15 do
  begin
    Result._1D[i] := stLeftMatrix._1D[i] - stRightMatrix._1D[i];
  end;
end;

function MatrixAdd (const stLeftMatrix, stRightMatrix : TMatrix4x4): TMatrix4x4;
var
  i: Integer;
begin
  Result := MatrixIdentity();
  for i := 0 to 15 do
  begin
    Result._1D[i] := stLeftMatrix._1D[i] + stRightMatrix._1D[i];
  end;
end;

function MatrixMul (const stLeftMatrix, stRightMatrix : TMatrix4x4): TMatrix4x4;
//var
//  i, j, k: Integer;
begin
  Result := Matrix;

{This BLOCK of code, instead of cycle, makes very nice performance improvement}

  Result._2D[0][0] :=
    stLeftMatrix._2D[0][0] * stRightMatrix._2D[0][0] +
    stLeftMatrix._2D[0][1] * stRightMatrix._2D[1][0] +
    stLeftMatrix._2D[0][2] * stRightMatrix._2D[2][0] +
    stLeftMatrix._2D[0][3] * stRightMatrix._2D[3][0];
  Result._2D[1][0] :=
    stLeftMatrix._2D[1][0] * stRightMatrix._2D[0][0] +
    stLeftMatrix._2D[1][1] * stRightMatrix._2D[1][0] +
    stLeftMatrix._2D[1][2] * stRightMatrix._2D[2][0] +
    stLeftMatrix._2D[1][3] * stRightMatrix._2D[3][0];
  Result._2D[2][0] :=
    stLeftMatrix._2D[2][0] * stRightMatrix._2D[0][0] +
    stLeftMatrix._2D[2][1] * stRightMatrix._2D[1][0] +
    stLeftMatrix._2D[2][2] * stRightMatrix._2D[2][0] +
    stLeftMatrix._2D[2][3] * stRightMatrix._2D[3][0];
  Result._2D[3][0] :=
    stLeftMatrix._2D[3][0] * stRightMatrix._2D[0][0] +
    stLeftMatrix._2D[3][1] * stRightMatrix._2D[1][0] +
    stLeftMatrix._2D[3][2] * stRightMatrix._2D[2][0] +
    stLeftMatrix._2D[3][3] * stRightMatrix._2D[3][0];
  Result._2D[0][1] :=
    stLeftMatrix._2D[0][0] * stRightMatrix._2D[0][1] +
    stLeftMatrix._2D[0][1] * stRightMatrix._2D[1][1] +
    stLeftMatrix._2D[0][2] * stRightMatrix._2D[2][1] +
    stLeftMatrix._2D[0][3] * stRightMatrix._2D[3][1];
  Result._2D[1][1] :=
    stLeftMatrix._2D[1][0] * stRightMatrix._2D[0][1] +
    stLeftMatrix._2D[1][1] * stRightMatrix._2D[1][1] +
    stLeftMatrix._2D[1][2] * stRightMatrix._2D[2][1] +
    stLeftMatrix._2D[1][3] * stRightMatrix._2D[3][1];
  Result._2D[2][1] :=
    stLeftMatrix._2D[2][0] * stRightMatrix._2D[0][1] +
    stLeftMatrix._2D[2][1] * stRightMatrix._2D[1][1] +
    stLeftMatrix._2D[2][2] * stRightMatrix._2D[2][1] +
    stLeftMatrix._2D[2][3] * stRightMatrix._2D[3][1];
  Result._2D[3][1] :=
    stLeftMatrix._2D[3][0] * stRightMatrix._2D[0][1] +
    stLeftMatrix._2D[3][1] * stRightMatrix._2D[1][1] +
    stLeftMatrix._2D[3][2] * stRightMatrix._2D[2][1] +
    stLeftMatrix._2D[3][3] * stRightMatrix._2D[3][1];
  Result._2D[0][2] :=
    stLeftMatrix._2D[0][0] * stRightMatrix._2D[0][2] +
    stLeftMatrix._2D[0][1] * stRightMatrix._2D[1][2] +
    stLeftMatrix._2D[0][2] * stRightMatrix._2D[2][2] +
    stLeftMatrix._2D[0][3] * stRightMatrix._2D[3][2];
  Result._2D[1][2] :=
    stLeftMatrix._2D[1][0] * stRightMatrix._2D[0][2] +
    stLeftMatrix._2D[1][1] * stRightMatrix._2D[1][2] +
    stLeftMatrix._2D[1][2] * stRightMatrix._2D[2][2] +
    stLeftMatrix._2D[1][3] * stRightMatrix._2D[3][2];
  Result._2D[2][2] :=
    stLeftMatrix._2D[2][0] * stRightMatrix._2D[0][2] +
    stLeftMatrix._2D[2][1] * stRightMatrix._2D[1][2] +
    stLeftMatrix._2D[2][2] * stRightMatrix._2D[2][2] +
    stLeftMatrix._2D[2][3] * stRightMatrix._2D[3][2];
  Result._2D[3][2] :=
    stLeftMatrix._2D[3][0] * stRightMatrix._2D[0][2] +
    stLeftMatrix._2D[3][1] * stRightMatrix._2D[1][2] +
    stLeftMatrix._2D[3][2] * stRightMatrix._2D[2][2] +
    stLeftMatrix._2D[3][3] * stRightMatrix._2D[3][2];
  Result._2D[0][3] :=
    stLeftMatrix._2D[0][0] * stRightMatrix._2D[0][3] +
    stLeftMatrix._2D[0][1] * stRightMatrix._2D[1][3] +
    stLeftMatrix._2D[0][2] * stRightMatrix._2D[2][3] +
    stLeftMatrix._2D[0][3] * stRightMatrix._2D[3][3];
  Result._2D[1][3] :=
    stLeftMatrix._2D[1][0] * stRightMatrix._2D[0][3] +
    stLeftMatrix._2D[1][1] * stRightMatrix._2D[1][3] +
    stLeftMatrix._2D[1][2] * stRightMatrix._2D[2][3] +
    stLeftMatrix._2D[1][3] * stRightMatrix._2D[3][3];
  Result._2D[2][3] :=
    stLeftMatrix._2D[2][0] * stRightMatrix._2D[0][3] +
    stLeftMatrix._2D[2][1] * stRightMatrix._2D[1][3] +
    stLeftMatrix._2D[2][2] * stRightMatrix._2D[2][3] +
    stLeftMatrix._2D[2][3] * stRightMatrix._2D[3][3];
  Result._2D[3][3] :=
    stLeftMatrix._2D[3][0] * stRightMatrix._2D[0][3] +
    stLeftMatrix._2D[3][1] * stRightMatrix._2D[1][3] +
    stLeftMatrix._2D[3][2] * stRightMatrix._2D[2][3] +
    stLeftMatrix._2D[3][3] * stRightMatrix._2D[3][3];


//  for i := 0 to 3 do
//    for j := 0 to 3 do
//      for k := 0 to 3 do
//        Result._2D[i][j] := Result._2D[i][j] + stLeftMatrix._2D[i][k] * stRightMatrix._2D[k][j];
end;

function MatrixSub (const stLeftMatrix: TMatrix4x4; right: Single): TMatrix4x4;
var i: Integer;
begin
  Result := MatrixIdentity();
  for i := 0 to 15 do
  begin
    Result._1D[i] := stLeftMatrix._1D[i] - right;
  end;
end;

function MatrixAdd (const stLeftMatrix: TMatrix4x4; right: Single): TMatrix4x4;
var i: Integer;
begin
  Result := MatrixIdentity();
  for i := 0 to 15 do
  begin
    Result._1D[i] := stLeftMatrix._1D[i] + right;
  end;
end;

function MatrixDiv (const stLeftMatrix: TMatrix4x4; right: Single): TMatrix4x4;
var i: Integer;
begin
  Result := MatrixIdentity();
  for i := 0 to 15 do
  begin
    Result._1D[i] := stLeftMatrix._1D[i] / right;
  end;
end;

function MatrixMul (const stLeftMatrix: TMatrix4x4; right: Single): TMatrix4x4;
var i: Integer;
begin
  Result := MatrixIdentity();
  for i := 0 to 15 do
  begin
    Result._1D[i] := stLeftMatrix._1D[i] * right;
  end;
end;

function ApplyToPoint(const stLeftMatrix: TMatrix4x4; stPoint: TPoint3): TPoint3;
begin
  Result.x := stPoint.x * stLeftMatrix._2d[0, 0] + stPoint.y * stLeftMatrix._2d[1, 0] + stPoint.z * stLeftMatrix._2d[2, 0] + stLeftMatrix._2d[3, 0];
  Result.y := stPoint.x * stLeftMatrix._2d[0, 1] + stPoint.y * stLeftMatrix._2d[1, 1] + stPoint.z * stLeftMatrix._2d[2, 1] + stLeftMatrix._2d[3, 1];
  Result.z := stPoint.x * stLeftMatrix._2d[0, 2] + stPoint.y * stLeftMatrix._2d[1, 2] + stPoint.z * stLeftMatrix._2d[2, 2] + stLeftMatrix._2d[3, 2];
end;

function ApplyToPoint(const stLeftMatrix: TMatrix4x4; stPoint: TPoint2): TPoint2;
begin
  Result.x := stPoint.x * stLeftMatrix._2d[0, 0] + stPoint.y * stLeftMatrix._2d[1, 0] + stLeftMatrix._2d[3, 0];
  Result.y := stPoint.x * stLeftMatrix._2d[0, 1] + stPoint.y * stLeftMatrix._2d[1, 1] + stLeftMatrix._2d[3, 1];
end;

function ApplyToVector(const stLeftMatrix: TMatrix4x4; stPoint: TPoint3): TPoint3;
begin
  Result.x := stPoint.x * stLeftMatrix._2d[0, 0] + stPoint.y * stLeftMatrix._2d[1, 0] + stPoint.z * stLeftMatrix._2d[2, 0];
  Result.y := stPoint.x * stLeftMatrix._2d[0, 1] + stPoint.y * stLeftMatrix._2d[1, 1] + stPoint.z * stLeftMatrix._2d[2, 1];
  Result.z := stPoint.x * stLeftMatrix._2d[0, 2] + stPoint.y * stLeftMatrix._2d[1, 2] + stPoint.z * stLeftMatrix._2d[2, 2];
end;

{$IF COMPILERVERSION >= 20}
class operator TMatrix4x4.Subtract (const stLeftMatrix, stRightMatrix : TMatrix4x4): TMatrix4x4;
var i: Integer;
begin
  Result := MatrixIdentity();
  for i := 0 to 15 do
  begin
    Result._1D[i] := stLeftMatrix._1D[i] - stRightMatrix._1D[i];
  end;
end;

class operator TMatrix4x4.Add (const stLeftMatrix, stRightMatrix : TMatrix4x4): TMatrix4x4;
var
  i: Integer;
begin
  Result := MatrixIdentity();
  for i := 0 to 15 do
  begin
    Result._1D[i] := stLeftMatrix._1D[i] + stRightMatrix._1D[i];
  end;
end;

class operator TMatrix4x4.Multiply (const stLeftMatrix, stRightMatrix : TMatrix4x4): TMatrix4x4;
//var
//  i, j, k: Integer;
begin
  Result := Matrix;

{This BLOCK of code, instead of cycle, makes very nice performance improvement}

  Result._2D[0][0] :=
    stLeftMatrix._2D[0][0] * stRightMatrix._2D[0][0] +
    stLeftMatrix._2D[0][1] * stRightMatrix._2D[1][0] +
    stLeftMatrix._2D[0][2] * stRightMatrix._2D[2][0] +
    stLeftMatrix._2D[0][3] * stRightMatrix._2D[3][0];
  Result._2D[1][0] :=
    stLeftMatrix._2D[1][0] * stRightMatrix._2D[0][0] +
    stLeftMatrix._2D[1][1] * stRightMatrix._2D[1][0] +
    stLeftMatrix._2D[1][2] * stRightMatrix._2D[2][0] +
    stLeftMatrix._2D[1][3] * stRightMatrix._2D[3][0];
  Result._2D[2][0] :=
    stLeftMatrix._2D[2][0] * stRightMatrix._2D[0][0] +
    stLeftMatrix._2D[2][1] * stRightMatrix._2D[1][0] +
    stLeftMatrix._2D[2][2] * stRightMatrix._2D[2][0] +
    stLeftMatrix._2D[2][3] * stRightMatrix._2D[3][0];
  Result._2D[3][0] :=
    stLeftMatrix._2D[3][0] * stRightMatrix._2D[0][0] +
    stLeftMatrix._2D[3][1] * stRightMatrix._2D[1][0] +
    stLeftMatrix._2D[3][2] * stRightMatrix._2D[2][0] +
    stLeftMatrix._2D[3][3] * stRightMatrix._2D[3][0];
  Result._2D[0][1] :=
    stLeftMatrix._2D[0][0] * stRightMatrix._2D[0][1] +
    stLeftMatrix._2D[0][1] * stRightMatrix._2D[1][1] +
    stLeftMatrix._2D[0][2] * stRightMatrix._2D[2][1] +
    stLeftMatrix._2D[0][3] * stRightMatrix._2D[3][1];
  Result._2D[1][1] :=
    stLeftMatrix._2D[1][0] * stRightMatrix._2D[0][1] +
    stLeftMatrix._2D[1][1] * stRightMatrix._2D[1][1] +
    stLeftMatrix._2D[1][2] * stRightMatrix._2D[2][1] +
    stLeftMatrix._2D[1][3] * stRightMatrix._2D[3][1];
  Result._2D[2][1] :=
    stLeftMatrix._2D[2][0] * stRightMatrix._2D[0][1] +
    stLeftMatrix._2D[2][1] * stRightMatrix._2D[1][1] +
    stLeftMatrix._2D[2][2] * stRightMatrix._2D[2][1] +
    stLeftMatrix._2D[2][3] * stRightMatrix._2D[3][1];
  Result._2D[3][1] :=
    stLeftMatrix._2D[3][0] * stRightMatrix._2D[0][1] +
    stLeftMatrix._2D[3][1] * stRightMatrix._2D[1][1] +
    stLeftMatrix._2D[3][2] * stRightMatrix._2D[2][1] +
    stLeftMatrix._2D[3][3] * stRightMatrix._2D[3][1];
  Result._2D[0][2] :=
    stLeftMatrix._2D[0][0] * stRightMatrix._2D[0][2] +
    stLeftMatrix._2D[0][1] * stRightMatrix._2D[1][2] +
    stLeftMatrix._2D[0][2] * stRightMatrix._2D[2][2] +
    stLeftMatrix._2D[0][3] * stRightMatrix._2D[3][2];
  Result._2D[1][2] :=
    stLeftMatrix._2D[1][0] * stRightMatrix._2D[0][2] +
    stLeftMatrix._2D[1][1] * stRightMatrix._2D[1][2] +
    stLeftMatrix._2D[1][2] * stRightMatrix._2D[2][2] +
    stLeftMatrix._2D[1][3] * stRightMatrix._2D[3][2];
  Result._2D[2][2] :=
    stLeftMatrix._2D[2][0] * stRightMatrix._2D[0][2] +
    stLeftMatrix._2D[2][1] * stRightMatrix._2D[1][2] +
    stLeftMatrix._2D[2][2] * stRightMatrix._2D[2][2] +
    stLeftMatrix._2D[2][3] * stRightMatrix._2D[3][2];
  Result._2D[3][2] :=
    stLeftMatrix._2D[3][0] * stRightMatrix._2D[0][2] +
    stLeftMatrix._2D[3][1] * stRightMatrix._2D[1][2] +
    stLeftMatrix._2D[3][2] * stRightMatrix._2D[2][2] +
    stLeftMatrix._2D[3][3] * stRightMatrix._2D[3][2];
  Result._2D[0][3] :=
    stLeftMatrix._2D[0][0] * stRightMatrix._2D[0][3] +
    stLeftMatrix._2D[0][1] * stRightMatrix._2D[1][3] +
    stLeftMatrix._2D[0][2] * stRightMatrix._2D[2][3] +
    stLeftMatrix._2D[0][3] * stRightMatrix._2D[3][3];
  Result._2D[1][3] :=
    stLeftMatrix._2D[1][0] * stRightMatrix._2D[0][3] +
    stLeftMatrix._2D[1][1] * stRightMatrix._2D[1][3] +
    stLeftMatrix._2D[1][2] * stRightMatrix._2D[2][3] +
    stLeftMatrix._2D[1][3] * stRightMatrix._2D[3][3];
  Result._2D[2][3] :=
    stLeftMatrix._2D[2][0] * stRightMatrix._2D[0][3] +
    stLeftMatrix._2D[2][1] * stRightMatrix._2D[1][3] +
    stLeftMatrix._2D[2][2] * stRightMatrix._2D[2][3] +
    stLeftMatrix._2D[2][3] * stRightMatrix._2D[3][3];
  Result._2D[3][3] :=
    stLeftMatrix._2D[3][0] * stRightMatrix._2D[0][3] +
    stLeftMatrix._2D[3][1] * stRightMatrix._2D[1][3] +
    stLeftMatrix._2D[3][2] * stRightMatrix._2D[2][3] +
    stLeftMatrix._2D[3][3] * stRightMatrix._2D[3][3];


//  for i := 0 to 3 do
//    for j := 0 to 3 do
//      for k := 0 to 3 do
//        Result._2D[i][j] := Result._2D[i][j] + stLeftMatrix._2D[i][k] * stRightMatrix._2D[k][j];
end;

class operator TMatrix4x4.Subtract (const stLeftMatrix: TMatrix4x4; right: Single): TMatrix4x4;
var i: Integer;
begin
  Result := MatrixIdentity();
  for i := 0 to 15 do
  begin
    Result._1D[i] := stLeftMatrix._1D[i] - right;
  end;
end;

class operator TMatrix4x4.Add (const stLeftMatrix: TMatrix4x4; right: Single): TMatrix4x4;
var i: Integer;
begin
  Result := MatrixIdentity();
  for i := 0 to 15 do
  begin
    Result._1D[i] := stLeftMatrix._1D[i] + right;
  end;
end;

class operator TMatrix4x4.Divide (const stLeftMatrix: TMatrix4x4; right: Single): TMatrix4x4;
var i: Integer;
begin
  Result := MatrixIdentity();
  for i := 0 to 15 do
  begin
    Result._1D[i] := stLeftMatrix._1D[i] / right;
  end;
end;

class operator TMatrix4x4.Multiply (const stLeftMatrix: TMatrix4x4; right: Single): TMatrix4x4;
var i: Integer;
begin
  Result := Matrix
end;

constructor TTransformStack.Create;
begin
  inherited;
  stack := TStack<TMatrix>.Create();
end;

procedure TTransformStack.Clear(const base_transform: TMatrix4x4);
begin
  while stack.Count <> 0  do
    Pop();
  SetTop(base_transform);
end;

constructor TTransformStack.Create(const base_transform: TMatrix4x4);
begin
  Create;
  stack.Push(base_transform);
end;

procedure TTransformStack.Push;
begin
  stack.Push(stack.Peek());
end;

procedure TTransformStack.Pop;
begin
if stack.Count > 1 then
  stack.Pop();
end;

function TTransformStack.GetTop: TMatrix4x4;
begin
    Result := stack.Peek();
end;

procedure TTransformStack.SetTop(const Value: TMatrix4x4) ;
begin
  stack.Pop();
  Stack.Push(Value);
end;

procedure TTransformStack.MultGlobal(const transform: TMatrix4x4);
begin
  stack.Push(MatrixMul(stack.Pop, transform));
end;

procedure TTransformStack.MultLocal(const transform: TMatrix4x4);
begin
  stack.Push(MatrixMul(transform, stack.Pop));
end;

{$ELSE}

constructor TTransformStack.Create;
begin
  inherited;
    SetLength(stack, 0);
end;

procedure TTransformStack.Clear(const base_transform: TMatrix4x4);
begin
  SetLength(stack, 1);
  SetTop(base_transform);
end;

constructor TTransformStack.Create(const base_transform: TMatrix4x4);
begin
  Create;
  SetLength(stack, 1);
  stack[0] := base_transform;
end;

function TTransformStack.GetTop: TMatrix4x4;
begin
  Result := stack[High(stack)];
end;

procedure TTransformStack.MultGlobal(const transform: TMatrix);
begin
  stack[High(stack)] := MatrixMul(stack[High(stack)], transform);
end;

procedure TTransformStack.MultLocal(const transform: TMatrix);
begin
  stack[High(stack)] := MatrixMul(transform, stack[High(stack)]);
end;

procedure TTransformStack.Pop;
begin
if(System.Length(stack) > 1) then
  SetLength(stack, System.Length(stack) - 1);
end;

procedure TTransformStack.Push;
begin
  SetLength(stack, System.Length(stack) + 1);
  stack[High(stack)] := stack[High(stack) - 1];
end;

procedure TTransformStack.SetTop(const Value: TMatrix4x4);
begin
  stack[High(stack)] := Value;
end;

{$IFEND}

function EngWindow(): TEngineWindow; overload;
begin
  Result.uiWidth        := 800;
  Result.uiHeight       := 600;
  Result.bFullScreen    := False;
  Result.bVSync         := False;
  Result.eMultiSampling := MM_NONE;
  Result.uiFlags        := EWF_DEFAULT;
end;

function EngWindow(uiWidth, uiHeight : Integer; bFullScreen : Boolean;
  bVSync : Boolean = False; eMSampling: {E_MULTISAMPLING_MODE} Cardinal = MM_NONE;
  uiFlags:{ENG_WINDOW_FLAGS}Integer = EWF_DEFAULT): TEngineWindow; overload;
begin
  Result.uiWidth        := uiWidth;
  Result.uiHeight       := uiHeight;
  Result.bFullScreen    := bFullScreen;
  Result.bVSync         := bVSync;
  Result.eMultiSampling := eMSampling;
  Result.uiFlags        := uiFlags;
end;

{$IF COMPILERVERSION >= 18}
constructor TEngineWindow.Create(var dummy);
begin
  Self := EngWindow();
end;

constructor TEngineWindow.Create(uiWidth, uiHeight : Integer; bFullScreen : Boolean;
  bVSync : Boolean = False; eMSampling: {E_MULTISAMPLING_MODE} Cardinal = MM_NONE;
  uiFlags:{ENG_WINDOW_FLAGS}Integer = EWF_DEFAULT);
begin
  Self := EngWindow(uiWidth, uiHeight, bFullScreen, bVSync, eMSampling, uiFlags);
end;
{$IFEND}

{$IF COMPILERVERSION >= 18}
constructor TPluginInfo.Create(var dummy);
begin
  Self := PluginInfo();
end;
{$IFEND}

function PluginInfo(): TPluginInfo;
begin
  Result.ui8PluginSDKVersion := _DGLE_PLUGIN_SDK_VER_;
end;

{$IF COMPILERVERSION >= 18}
constructor TWindowMessage.Create(var dummy);
begin
  Self := WindowMessage();
end;

constructor TWindowMessage.Create(msg: E_WINDOW_MESSAGE_TYPE; param1: Cardinal = 0;
  param2: Cardinal = 0; param3: Pointer = nil);
begin
  Self := WindowMessage(Msg, param1, param2, param3);
end;
{$IFEND}

function WindowMessage(): TWindowMessage; overload;
begin
  Result.eMsgType   := WMT_UNKNOWN;
  Result.ui32Param1 := 0;
  Result.ui32Param2 := 0;
  Result.pParam3    := nil;
end;

function WindowMessage(msg: E_WINDOW_MESSAGE_TYPE; param1: Cardinal = 0;
  param2: Cardinal = 0; param3: Pointer = nil): TWindowMessage; overload;
begin
  Result.eMsgType   := msg;
  Result.ui32Param1 := param1;
  Result.ui32Param2 := param2;
  Result.pParam3    := param3;
end;

procedure {$IF COMPILERVERSION >= 18}TVariant.{$IFEND}Clear({$IF COMPILERVERSION < 18}var AVar: TVariant{$IFEND});
begin
  {$IF COMPILERVERSION < 18}with AVar do {$IFEND}
  begin
    _type := DVT_UNKNOWN;
    if Assigned(_Data) then
      FreeMem(_Data);
    _Data :=  nil;
  end;
end;

procedure {$IF COMPILERVERSION >= 18}TVariant.{$IFEND}SetInt({$IF COMPILERVERSION < 18}var AVar: TVariant;{$IFEND}iVal: Integer);
begin
  {$IF COMPILERVERSION < 18}with AVar do {$IFEND}
  begin
    Clear({$IF COMPILERVERSION < 18}AVar{$IFEND});
    _type := DVT_INT;
    GetMem(_Data, SizeOf(Integer));
    CopyMemory(_Data, @iVal, SizeOf(Integer));
  end;
end;

procedure {$IF COMPILERVERSION >= 18}TVariant.{$IFEND}SetFloat({$IF COMPILERVERSION < 18}var AVar: TVariant;{$IFEND}fVal: Single);
begin
  {$IF COMPILERVERSION < 18}with AVar do {$IFEND}
  begin
    Clear({$IF COMPILERVERSION < 18}AVar{$IFEND});
    _type := DVT_FLOAT;
    GetMem(_Data, SizeOf(Single));
    CopyMemory(_Data, @fVal, SizeOf(Single));
  end;
end;

procedure {$IF COMPILERVERSION >= 18}TVariant.{$IFEND}SetBool({$IF COMPILERVERSION < 18}var AVar: TVariant;{$IFEND}bVal: Boolean);
begin
  {$IF COMPILERVERSION < 18}with AVar do {$IFEND}
  begin
    Clear({$IF COMPILERVERSION < 18}AVar{$IFEND});
    _type := DVT_BOOL;
    GetMem(_Data, SizeOf(LongBool));
    if bVal then
      PInteger(_Data)^ := 1
    else
      PInteger(_Data)^ := 0;
  end;
end;

procedure {$IF COMPILERVERSION >= 18}TVariant.{$IFEND}SetPointer({$IF COMPILERVERSION < 18}var AVar: TVariant;{$IFEND}pPointer: Pointer);
begin
  {$IF COMPILERVERSION < 18}with AVar do {$IFEND}
  begin
    Clear({$IF COMPILERVERSION < 18}AVar{$IFEND});
    _type := DVT_POINTER;
    _Data := pPointer;
  end;
end;

procedure {$IF COMPILERVERSION >= 18}TVariant.{$IFEND}SetData({$IF COMPILERVERSION < 18}var AVar: TVariant;{$IFEND}pData: Pointer; uiDataSize: Cardinal);
begin
  {$IF COMPILERVERSION < 18}with AVar do {$IFEND}
  begin
    Clear({$IF COMPILERVERSION < 18}AVar{$IFEND});
    _type := DVT_DATA;
    GetMem(_Data, uiDataSize + SizeOf(Integer));
    CopyMemory(_Data, @uiDataSize, SizeOf(Integer));
    CopyMemory(Pointer(Integer(_Data) + SizeOf(Integer)), pData, uiDataSize);
  end;
end;

function {$IF COMPILERVERSION >= 18}TVariant.{$IFEND}AsInt({$IF COMPILERVERSION < 18}var AVar: TVariant{$IFEND}): Integer;
begin
  {$IF COMPILERVERSION < 18}with AVar do {$IFEND}
  if (_type <> DVT_INT) then
    Result := 0
  else
    CopyMemory(@Result, _Data, SizeOf(Integer));
end;

function {$IF COMPILERVERSION >= 18}TVariant.{$IFEND}AsFloat({$IF COMPILERVERSION < 18}var AVar: TVariant{$IFEND}): Single;
begin
  {$IF COMPILERVERSION < 18}with AVar do {$IFEND}
  if (_type <> DVT_FLOAT) then
    Result := 0.
  else
    CopyMemory(@Result, _Data, SizeOf(Single));
end;

function {$IF COMPILERVERSION >= 18}TVariant.{$IFEND}AsBool({$IF COMPILERVERSION < 18}var AVar: TVariant{$IFEND}): Boolean;
begin
  {$IF COMPILERVERSION < 18}with AVar do {$IFEND}
  if (_type <> DVT_BOOL) then
    Result := False
  else
    Result := not (PInteger(_Data)^ = 0);
end;

function {$IF COMPILERVERSION >= 18}TVariant.{$IFEND}AsPointer({$IF COMPILERVERSION < 18}var AVar: TVariant{$IFEND}): Pointer;
begin
  {$IF COMPILERVERSION < 18}with AVar do {$IFEND}
  if (_type <> DVT_POINTER) then
    Result := nil
  else
    Result := _Data;
end;

procedure {$IF COMPILERVERSION >= 18}TVariant.{$IFEND}GetData({$IF COMPILERVERSION < 18}var AVar: TVariant;{$IFEND}out pData: Pointer; out uiDataSize: Cardinal);
begin
  {$IF COMPILERVERSION < 18}with AVar do {$IFEND}
  if (_type <> DVT_DATA) then
  begin
    pData := nil;
    uiDataSize := 0;
  end
  else
  begin
    GetMem(_Data, uiDataSize + SizeOf(Integer));
    CopyMemory(@uiDataSize, _Data, SizeOf(Integer));
    GetMem(pData, uiDataSize);
    CopyMemory(pData, Pointer(Integer(_Data) + SizeOf(Integer)), uiDataSize);
  end;
end;

function {$IF COMPILERVERSION >= 18}TVariant.{$IFEND}GetType({$IF COMPILERVERSION < 18}var AVar: TVariant{$IFEND}): E_DGLE_VARIANT_TYPE;
begin
  Result := {$IF COMPILERVERSION < 18}AVar.{$IFEND}_type;
end;

{$IF COMPILERVERSION >= 20}
class operator TVariant.Implicit(AVar: TVariant): Integer;
begin
  Result := AVar.AsInt;
end;

class operator TVariant.Implicit(AVar: TVariant): Single;
begin
  Result := AVar.AsFloat;
end;

class operator TVariant.Implicit(AVar: TVariant): Boolean;
begin
  Result := AVar.AsBool;
end;
class operator TVariant.Implicit(AVar: TVariant): Pointer;
begin
  Result := AVar.AsPointer;
end;
{$IFEND}

begin
end.
