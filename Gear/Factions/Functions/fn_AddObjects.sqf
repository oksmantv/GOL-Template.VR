// ================================================================
// *	AUTHOR: GuzzenVonLidl
// *
// *	Description:
// *	A simpler way of adding gear to a unit
// *
// *	Usage:
// *	[_unit, _riflemag, 5] call GOL_Fnc_AddObjects;
// *	[player, "30Rnd_mas_556x45_Stanag", 5] call GOL_Fnc_AddObjects;
// *
// *	Parameters:
// *	0:	String:		Classname of magazines to be added
// *	1:	Unit:		Target that should get the magazines
// *	2:	Number:		Amount of magazines
// *
// ================================================================

	#include "macros.sqf";

	private ["_Group","_item","_number"];
	if (isNil "_unit") then { _unit = player; };
	_Group = [];
	{
		_Group pushBack _x;
	} forEach _this;
	{
		_item = (_x select 0);
		_number = [_x, 1, 1, [0]] call BIS_fnc_param;
		if (([_item] call BIS_fnc_itemType select 0) isEqualTo "Item") then {
			if (([_item] call BIS_fnc_itemType select 1) isEqualTo "Binocular") then {
				_unit addWeapon _item;
			} else {
				ADD_ITEM_PRIORITY_FOREACH(_item,_number);
			};
		};
		if (([_item] call BIS_fnc_itemType select 0) isEqualTo "Magazine") then {
			ADD_ITEM_PRIORITY_FOREACH(_item,_number);
		};

		if (([_item] call BIS_fnc_itemType select 0) isEqualTo "Weapon") then {
			_unit addWeapon _item;
		};
	} forEach _Group;
