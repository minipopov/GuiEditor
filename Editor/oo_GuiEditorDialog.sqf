#include "..\oop.h"

CLASS("oo_GuiEditorDialog")

	PUBLIC VARIABLE("code", "GuiObject");
	PUBLIC UI_VARIABLE("display", "DisplayChild");
	

	
	PUBLIC FUNCTION("code","constructor") { 
		MEMBER("GuiObject", _this);
	};

	PUBLIC FUNCTION("","openGeneralCfgDialog") {
		if!(createDialog "GuiEditorGeneralCfg") exitWith{
			hint "Failed to open generalCfg";
		};
		private _helper = ["new", (findDisplay 5001)] call oo_HelperGui;
		["setString", [1400 , "getDisplayName" call MEMBER("GuiObject", nil)]] call _helper;
		["setString", [1401 , "getIDD" call MEMBER("GuiObject", nil)]] call _helper;

		["setAction", [1601, format["'openGeneralCfgDialogValid' call %1;",_self]]] call _helper;
		["setAction", [1600, "closeDialog 0;"] ] call _helper;
	};

	PUBLIC FUNCTION("","openGeneralCfgDialogValid") {
		private _helper = ["new", (findDisplay 5001)] call oo_HelperGui;
		private _name = ["getString", 1400] call _helper;
		private _idd = ["getScalar", 1401] call _helper;
		_name = ["stringReplace", [_name, " ", ""]] call _helper;

		["setIDD", _idd] call MEMBER("GuiObject", nil);
		["setDisplayName", _name] call MEMBER("GuiObject", nil);
		closeDialog 0;
	};

	PUBLIC FUNCTION("","openCtrlCreateDialog") {
		disableSerialization;
		private _child = (findDisplay 4500) createDisplay "RscDisplayEmpty";
		MEMBER("DisplayChild", _child);
		private _control = _child ctrlCreate["RscBackgroundGUIDark", -1];
		_control ctrlSetPosition [safezoneX+safezoneW*0.25, safezoneY+safezoneH*0.25, safezoneW*0.5, safezoneH*0.5];
		_control ctrlCommit 0;

		private _topBar = _child ctrlCreate["TopBar", -1];
		_topBar ctrlSetText "Create control on layer";
		_topBar ctrlSetPosition [safezoneX+safezoneW*0.25, safezoneY+safezoneH*0.25, safezoneW*0.5, safezoneH*0.02];
		_topBar ctrlCommit 0;

		private _listBox = _child ctrlCreate["OOP_Listbox", 10];
		_listBox ctrlSetPosition[
			safezoneX+safezoneW*0.3, safezoneY+safezoneH*0.3, safezoneW*0.4, safezoneH*0.4
		];
		_listBox ctrlCommit 0;

		{
			_listBox lbAdd _x;
			_listBox lbSetData[_forEachIndex, _x];
		} forEach OOP_GuiEditor_ListControl;

		private _closeBtn = _child ctrlCreate["OOP_Button", -1];
		_closeBtn ctrlSetText "Fermer";
		_closeBtn buttonSetAction "closeDialog 0;";
		_closeBtn ctrlSetPosition [
			safezoneX+safezoneW*0.4, safezoneY+safezoneH*0.71, safezoneW*0.05, safezoneH*0.03
		];
		_closeBtn ctrlCommit 0;

		private _valideBtn = _child ctrlCreate["OOP_Button", -1];
		_valideBtn ctrlSetText "Valider";

		_valideBtn buttonSetAction format["'valideCtrlCreateDialog' call %1", _self];
		_valideBtn ctrlSetPosition [
			safezoneX+safezoneW*0.5, safezoneY+safezoneH*0.71, safezoneW*0.05, safezoneH*0.03
		];
		_valideBtn ctrlCommit 0;
	};

	PUBLIC FUNCTION("","valideCtrlCreateDialog") {
		disableSerialization;
		private _listBox = (findDisplay -1) displayCtrl 10;
		private _s = _listBox lbData (lbCurSel _listBox);
		["ctrlCreate", _s] call MEMBER("GuiObject", nil);
		closeDialog 0;
	};

	PUBLIC FUNCTION("","openCfgCtrlDialog") {
		disableSerialization;
		if!(createDialog "GuiEditorDisplay") exitWith{
			hint "Can't create dialog empty";
		};
		private _child = findDisplay 5000;
		MEMBER("DisplayChild", _child);

		private _selCtrl = "getSelCtrl" call MEMBER("GuiObject", nil);

		private _control = _child ctrlCreate["RscBackgroundGUIDark", -1];
		_control ctrlSetPosition [safezoneX+safezoneW*0.25, safezoneY+safezoneH*0.25, safezoneW*0.5, safezoneH*0.5];
		_control ctrlCommit 0;

		private _topBar = _child ctrlCreate["TopBar", -1];
		_topBar ctrlSetText format["Config your control:%1", "getType" call _selCtrl];
		_topBar ctrlSetPosition [safezoneX+safezoneW*0.25, safezoneY+safezoneH*0.25, safezoneW*0.5, safezoneH*0.02];
		_topBar ctrlCommit 0;
		
		private _helperControl = ["new", _child] call oo_HelperControl;
		["setLineSpaceY", safezoneH*0.011 ] call _helperControl;
	
		private _posCtrlGroup = [safezoneX+safezoneW*0.37, safezoneY+safezoneH*0.30, safezoneW*0.4, safezoneH*0.35];

		private _btnStyle = _child ctrlCreate["OOP_Button", 5];
		_btnStyle ctrlSetText "Style";
		_btnStyle buttonSetAction "{((findDisplay 5000) displayCtrl _x) ctrlShow false;}forEach[500,501,502,503,504,505,506,507]; ((findDisplay 5000) displayCtrl 500) ctrlShow true;";
		_btnStyle ctrlSetPosition[safezoneX+safezoneW*0.25, safezoneY+safezoneH*0.30, safezoneW*0.10,safezoneH*0.02];
		_btnStyle ctrlCommit 0;
		private _ctrlGroupStyle = _child ctrlCreate["OOP_SubLayer", 500];
		_ctrlGroupStyle ctrlSetPosition _posCtrlGroup;
		_ctrlGroupStyle ctrlCommit 0;

		["setTarget", _ctrlGroupStyle] call _helperControl;
		["setPos", [0,0, safezoneH*0.02] ] call _helperControl;
		private _editCtrl = ["createTextInput", ["IDControl :", safezoneW*0.08, safezoneW*0.21, 10]] call _helperControl;
		_editCtrl ctrlSetText format["%1", ("getID" call _selCtrl)];
		_editCtrl = ["createTextInput", ["Name :", safezoneW*0.08, safezoneW*0.21, 19]] call _helperControl;
		_editCtrl ctrlSetText ("getName" call _selCtrl);
		_editCtrl = ["createTextInput", ["Text :", safezoneW*0.08, safezoneW*0.21, 11]] call _helperControl;
		_editCtrl ctrlSetText ("getText" call _selCtrl);
		_editCtrl = ["createTextInput", ["Background Color :", safezoneW*0.08, safezoneW*0.21, 12]] call _helperControl;
		_editCtrl ctrlSetText format["%1", ("getBackgroundColor" call _selCtrl)];
		_editCtrl = ["createTextInput", ["Text Color :", safezoneW*0.08, safezoneW*0.21, 13]] call _helperControl;
		_editCtrl ctrlSetText format["%1", ("getTextColor" call _selCtrl)];
		_editCtrl = ["createTextInput", ["Foreground Color :", safezoneW*0.08, safezoneW*0.21, 14]] call _helperControl;
		_editCtrl ctrlSetText format["%1", ("getForegroundColor" call _selCtrl)];
		_editCtrl = ["createTextInput", ["Tooltip :", safezoneW*0.08, safezoneW*0.21, 15]] call _helperControl;
		_editCtrl ctrlSetText ("getTooltip" call _selCtrl);
		_editCtrl = ["createTextInput", ["Tooltip Color Box :", safezoneW*0.08, safezoneW*0.21, 16]] call _helperControl;
		_editCtrl ctrlSetText format["%1", ("getTooltipColorBox" call _selCtrl)];
		_editCtrl = ["createTextInput", ["Tooltip Color Shade :", safezoneW*0.08, safezoneW*0.21, 17]] call _helperControl;
		_editCtrl ctrlSetText format["%1", ("getTooltipColorShade" call _selCtrl)];
		_editCtrl = ["createTextInput", ["Tooltip Color Text :", safezoneW*0.08, safezoneW*0.21, 18]] call _helperControl;
		_editCtrl ctrlSetText format["%1", ("getTooltipColorText" call _selCtrl)];

		private _btnGen = _child ctrlCreate["OOP_Button", 5];
		_btnGen ctrlSetText "Gen Event";
		_btnGen buttonSetAction "{((findDisplay 5000) displayCtrl _x) ctrlShow false;}forEach[500,501,502,503,504,505,506,507]; ((findDisplay 5000) displayCtrl 501) ctrlShow true;";
		_btnGen ctrlSetPosition[safezoneX+safezoneW*0.25, safezoneY+safezoneH*0.33, safezoneW*0.10,safezoneH*0.02];
		_btnGen ctrlCommit 0;
		private _ctrlGroupGen = _child ctrlCreate["OOP_SubLayer", 501];
		_ctrlGroupGen ctrlSetPosition _posCtrlGroup;
		_ctrlGroupGen ctrlShow false;
		_ctrlGroupGen ctrlCommit 0;
		["setTarget", _ctrlGroupGen] call _helperControl;
		["setPos", [0,0, safezoneH*0.02]] call _helperControl;
		["setMode", 1] call _helperControl;
		["setLineSpaceX", 0] call _helperControl;
		"resetCountControlRow" call _helperControl;
		["setMaxControlRow", 3] call _helperControl;

		{
			private _ctrl = ["createTextCheckbox", [_x, safezoneW*0.12, safezoneW*0.015]] call _helperControl;
			if(["getEventState", _x] call _selCtrl)then{
				_ctrl cbSetChecked true;
			};
			_ctrl ctrlAddEventHandler["CheckedChanged", format["['setEvent', ['%1', (_this select 1)]] call %2", _x, _selCtrl]];
		} forEach ["Init", "onDestroy", "onLoad", "onUnload", "onSetFocus", "onKillFocus", "onTimer", "onCanDestroy"];
		
		private _btnEvent = _child ctrlCreate["OOP_Button", 5];
		_btnEvent ctrlSetText "Mouse Event";
		_btnEvent buttonSetAction "{((findDisplay 5000) displayCtrl _x) ctrlShow false;}forEach[500,501,502,503,504,505,506,507]; ((findDisplay 5000) displayCtrl 502) ctrlShow true;";
		_btnEvent ctrlSetPosition[safezoneX+safezoneW*0.25, safezoneY+safezoneH*0.36, safezoneW*0.10,safezoneH*0.02];
		_btnEvent ctrlCommit 0;
		private _ctrlGroupEvent = _child ctrlCreate["OOP_SubLayer", 502];
		_ctrlGroupEvent ctrlSetPosition _posCtrlGroup;
		_ctrlGroupEvent ctrlShow false;
		_ctrlGroupEvent ctrlCommit 0;
		["setTarget", _ctrlGroupEvent] call _helperControl;
		["setPos", [0,0, safezoneH*0.02]] call _helperControl;
		"resetCountControlRow" call _helperControl;
		{
			private _ctrl = ["createTextCheckbox", [_x, safezoneW*0.12, safezoneW*0.015]] call _helperControl;
			if(["getEventState", _x] call _selCtrl)then{
				_ctrl cbSetChecked true;
			};
			_ctrl ctrlAddEventHandler["CheckedChanged", format["['setEvent', ['%1', (_this select 1)]] call %2", _x, _selCtrl]];
		} forEach ["onMouseButtonDown","onMouseButtonUp","onMouseButtonClick","onMouseButtonDblClick","onMouseMoving","onMouseHolding","onMouseZChanged","onButtonDblClick","onButtonDown","onButtonUp","onButtonClick","onMouseEnter","onMouseExit"];

		private _btnKey = _child ctrlCreate["OOP_Button", 5];
		_btnKey ctrlSetText "Keyboard Event";
		_btnKey buttonSetAction "{((findDisplay 5000) displayCtrl _x) ctrlShow false;}forEach[500,501,502,503,504,505,506,507]; ((findDisplay 5000) displayCtrl 503) ctrlShow true;";
		_btnKey ctrlSetPosition[safezoneX+safezoneW*0.25, safezoneY+safezoneH*0.39, safezoneW*0.10,safezoneH*0.02];
		_btnKey ctrlCommit 0;
		private _ctrlGRoupKeyboard = _child ctrlCreate["OOP_SubLayer", 503];
		_ctrlGRoupKeyboard ctrlSetPosition _posCtrlGroup;
		_ctrlGRoupKeyboard ctrlShow false;
		_ctrlGRoupKeyboard ctrlCommit 0;
		["setTarget", _ctrlGRoupKeyboard] call _helperControl;
		["setPos", [0,0, safezoneH*0.02]] call _helperControl;
		"resetCountControlRow" call _helperControl;

		{
			private _ctrl = ["createTextCheckbox", [_x, safezoneW*0.12, safezoneW*0.015]] call _helperControl;
			if(["getEventState", _x] call _selCtrl)then{
				_ctrl cbSetChecked true;
			};
			_ctrl ctrlAddEventHandler["CheckedChanged", format["['setEvent', ['%1', (_this select 1)]] call %2", _x, _selCtrl]];
		} forEach ["onKeyDown","onKeyUp","onChar","onIMEChar","onIMEComposition","onJoystickButton"];

		private _btnLB = _child ctrlCreate["OOP_Button", 5];
		_btnLB ctrlSetText "LB Event";
		_btnLB buttonSetAction "{((findDisplay 5000) displayCtrl _x) ctrlShow false;}forEach[500,501,502,503,504,505,506,507]; ((findDisplay 5000) displayCtrl 504) ctrlShow true;";
		_btnLB ctrlSetPosition [safezoneX+safezoneW*0.25, safezoneY+safezoneH*0.42, safezoneW*0.10,safezoneH*0.02];
		_btnLB ctrlCommit 0;
		private _ctrlGroupLB = _child ctrlCreate["OOP_SubLayer", 504];
		_ctrlGroupLB ctrlSetPosition _posCtrlGroup;
		_ctrlGroupLB ctrlShow false;
		_ctrlGroupLB ctrlCommit 0;
		["setTarget", _ctrlGroupLB] call _helperControl;
		["setPos", [0,0, safezoneH*0.02]] call _helperControl;
		"resetCountControlRow" call _helperControl;

		{
			private _ctrl = ["createTextCheckbox", [_x, safezoneW*0.12, safezoneW*0.015]] call _helperControl;
			if(["getEventState", _x] call _selCtrl)then{
				_ctrl cbSetChecked true;
			};
			_ctrl ctrlAddEventHandler["CheckedChanged", format["['setEvent', ['%1', (_this select 1)]] call %2", _x, _selCtrl]];
		} forEach ["onLBSelChanged","onLBListSelChanged","onLBDblClick","onLBDrag","onLBDragging","onLBDrop"];
				
		private _btnTree = _child ctrlCreate["OOP_Button", 5];
		_btnTree ctrlSetText "LB Event";
		_btnTree buttonSetAction "{((findDisplay 5000) displayCtrl _x) ctrlShow false;}forEach[500,501,502,503,504,506,507]; ((findDisplay 5000) displayCtrl 505) ctrlShow true;";
		_btnTree ctrlSetPosition[safezoneX+safezoneW*0.25, safezoneY+safezoneH*0.45, safezoneW*0.10,safezoneH*0.02];
		_btnTree ctrlCommit 0;
		private _ctrlGroupTree = _child ctrlCreate["OOP_SubLayer", 505];
		_ctrlGroupTree ctrlSetPosition _posCtrlGroup;
		_ctrlGroupTree ctrlShow false;
		_ctrlGroupTree ctrlCommit 0;
		["setTarget", _ctrlGroupTree] call _helperControl;
		["setPos", [0,0, safezoneH*0.02]] call _helperControl;
		"resetCountControlRow" call _helperControl;

		{
			private _ctrl = ["createTextCheckbox", [_x, safezoneW*0.12, safezoneW*0.015]] call _helperControl;
			if(["getEventState", _x] call _selCtrl)then{
				_ctrl cbSetChecked true;
			};
			_ctrl ctrlAddEventHandler["CheckedChanged", format["['setEvent', ['%1', (_this select 1)]] call %2", _x, _selCtrl]];
		} forEach ["onTreeSelChanged","onTreeLButtonDown","onTreeDblClick","onTreeExpanded","onTreeCollapsed","onTreeMouseMove","onTreeMouseHold","onTreeMouseExit"];

		private _btnTB = _child ctrlCreate["OOP_Button", 5];
		_btnTB ctrlSetText "Tool/Check box Event";
		_btnTB buttonSetAction "{((findDisplay 5000) displayCtrl _x) ctrlShow false;}forEach[500,501,502,503,504,505,506,507]; ((findDisplay 5000) displayCtrl 506) ctrlShow true;";
		_btnTB ctrlSetPosition[safezoneX+safezoneW*0.25, safezoneY+safezoneH*0.48, safezoneW*0.10,safezoneH*0.02];
		_btnTB ctrlCommit 0;
		private _ctrlGroupToolbox = _child ctrlCreate["OOP_SubLayer", 506];
		_ctrlGroupToolbox ctrlSetPosition _posCtrlGroup;
		_ctrlGroupToolbox ctrlShow false;
		_ctrlGroupToolbox ctrlCommit 0;
		["setTarget", _ctrlGroupToolbox] call _helperControl;
		["setPos", [0,0, safezoneH*0.02]] call _helperControl;
		"resetCountControlRow" call _helperControl;

		{
			private _ctrl = ["createTextCheckbox", [_x, safezoneW*0.12, safezoneW*0.015]] call _helperControl;
			if(["getEventState", _x] call _selCtrl)then{
				_ctrl cbSetChecked true;
			};
			_ctrl ctrlAddEventHandler["CheckedChanged", format["['setEvent', ['%1', (_this select 1)]] call %2", _x, _selCtrl]];
		} forEach ["onToolBoxSelChanged","onChecked","onCheckedChanged","onCheckBoxesSelChanged"];

		private _btnOther = _child ctrlCreate["OOP_Button", 5];
		_btnOther ctrlSetText "Other...";
		_btnOther buttonSetAction "{((findDisplay 5000) displayCtrl _x) ctrlShow false;}forEach[500,501,502,503,504,505,506,507]; ((findDisplay 5000) displayCtrl 507) ctrlShow true;";
		_btnOther ctrlSetPosition[safezoneX+safezoneW*0.25, safezoneY+safezoneH*0.51, safezoneW*0.10,safezoneH*0.02];
		_btnOther ctrlCommit 0;
		private _ctrlGroupOther = _child ctrlCreate["OOP_SubLayer", 507];
		_ctrlGroupOther ctrlSetPosition _posCtrlGroup;
		_ctrlGroupOther ctrlShow false;
		_ctrlGroupOther ctrlCommit 0;
		["setTarget", _ctrlGroupOther] call _helperControl;
		["setPos", [0,0, safezoneH*0.02]] call _helperControl;
		"resetCountControlRow" call _helperControl;
		{
			private _ctrl = ["createTextCheckbox", [_x, safezoneW*0.12, safezoneW*0.015]] call _helperControl;
			if(["getEventState", _x] call _selCtrl)then{
				_ctrl cbSetChecked true;
			};
			_ctrl ctrlAddEventHandler["CheckedChanged", format["['setEvent', ['%1', (_this select 1)]] call %2", _x, _selCtrl]];
		} forEach ["onHTMLLink","onSliderPosChanged","onObjectMoved","onMenuSelected","onDraw","onVideoStopped"];

		private _closeBtn = _child ctrlCreate["OOP_Button", -1];
		_closeBtn ctrlSetText "Fermer";
		_closeBtn buttonSetAction "closeDialog 0;";
		_closeBtn ctrlSetPosition [
			safezoneX+safezoneW*0.4, safezoneY+safezoneH*0.71, safezoneW*0.05, safezoneH*0.03
		];
		_closeBtn ctrlCommit 0;

		private _valideBtn = _child ctrlCreate["OOP_Button", -1];
		_valideBtn ctrlSetText "Valider";
		_valideBtn buttonSetAction format["'valideCfgCtrlDialog' call %1", _self];
		_valideBtn ctrlSetPosition [
			safezoneX+safezoneW*0.5, safezoneY+safezoneH*0.71, safezoneW*0.05, safezoneH*0.03
		];
		_valideBtn ctrlCommit 0;
	};

	PUBLIC FUNCTION("","valideCfgCtrlDialog") {
		private _helper = ["new", MEMBER("DisplayChild", nil)] call oo_HelperGui;
		private _selCtrl = "getSelCtrl" call MEMBER("GuiObject", nil);

		private _newID = ["getScalar", 10] call _helper;
		if (_newID < 0) exitWith {
			hint "ID can't be negative";	
		};
		
		if (["isUsedID", [_newID, [_selCtrl]]] call MEMBER("GuiObject", nil)) exitWith {
			hint "ID already used";
			["setString", [10,"getID" call _selCtrl]] call _helper;
		};

		["setID", _newID] call _selCtrl;
		["setText", ["getString", 11] call _helper] call _selCtrl;
		["setBackgroundColor", ["getColor", 12] call _helper] call _selCtrl;
		["setTextColor", ["getColor", 13] call _helper] call _selCtrl;
		["setForegroundColor", ["getColor", 14] call _helper] call _selCtrl;
		["setTooltip", ["getString", 15] call _helper] call _selCtrl;
		["setTooltipColorBox", ["getColor", 16] call _helper] call _selCtrl;
		["setTooltipColorShade", ["getColor", 17] call _helper] call _selCtrl;
		["setTooltipColorText", ["getColor", 18] call _helper] call _selCtrl;
		["setName", ["getString", 19] call _helper] call _selCtrl;

		closeDialog 0;
	};
ENDCLASS;