
// ================================================
//      Defined LoadOuts:
// ================================================
// *    gear_box - Role Selection Box
// *    a_box - Attachment Box
// *    misc_box - Misc Box
// *    med_box - Medical Box
// *    small_box - Small ammo box (Squad)
// *    big_box - Big ammo box (Platoon)
// *
// ================================================
// *
// *    AUTHOR: GuzzenVonLidl
// *
// *    Description:
// *        Handles all the items in the boxes
// *
// *    Usage:
// *        [_cargo,["gear_box","west"],[false,true]] call GOL_Fnc_GearCargo;
// *        [this,["small_box","west"],[true]] call GOL_Fnc_GearHandler;
// *
// *    Parameters:
// *    0: ObjNull: -   Object
// *    1: Array:  -   LoadOut
// *        0: String:  -   LoadOut
// *        1: String:  -   Side, Only accepts west,east & independent and its is not case sensitive
// *    2: Array:   -   Moveable (Optinal)
// *        0: Boolean: -   Moveable (Default: True)
// *        1: Boolean: -   AllowDamage (Default: False)
// *        2: Boolean: -   Allow gear to be assigend to a vehicle (Default: False)
// *
// *    Returning Value:
// *        Gives a vehicle / box the proper gear it should have
// *
// ====================================================================================

    private ["_unit","_typeofUnit","_isMan","_isCar","_isTank","_camo","_captivity","_Color","_boxConfigs","_item","_DebugName","_nightTime","_AllowNVG","_weaponCamo","_camoflage","_state","_factionValue","_factionScript","_map","_compass","_watch","_gps","_bino","_rangefinder","_laser","_nvg","_toolkit","_IRStrobe","_radio152","_radio1000a","_cTab","_Android","_microDAGR","_HelmetCam","_mapTools","_kestrel","_barrel","_earplugs","_cables","_demoCharge","_satchelCharge","_clacker","_defusalKit","_FAKBig","_FAKSmall","_bandage","_bandagePacking","_bandageElastic","_morph","_epi","_blood","_grenade","_grenademini","_flashBang","_smokegrenadeW","_smokegrenadeG","_smokegrenadeR","_smokegrenadeY","_smokegrenadeP","_chemG","_chemR","_chemY","_chemB","_handFlareG","_handFlareR","_handFlareW","_handFlareY","_glHE","_glsmokeW","_glsmokeG","_glsmokeR","_glsmokeY","_glsmokeP","_glsmokeB","_glsmokeO","_glflareW","_glflareG","_glflareR","_glflareY","_glflareIR","_pistol","_pistol_mag","_secondaryPistol","_rifle","_rifle_mag","_rifle_mag_tr","_primaryRifle","_rifleGL","_rifleGL_mag","_rifleGL_mag_tr","_primaryRifleGL","_rifleALT","_rifleALT_mag","_rifleALT_mag_tr","_primaryRifleALT","_carbine","_carbine_mag","_carbine_mag_tr","_primaryCarbine","_LMG","_LMG_mag","_LMG_mag_tr","_primaryLMG","_LAT","_LATmag","_MAT","_MATmag1","_MATmag2","_baseHelmet","_baseUniform","_baseVest","_baseGlasses","_pilotHelmet","_pilotUniform","_pilotVest","_crewHelmet","_crewVest","_bagRifleman","_bagAG","_radioAirBackpack","_radioBackpack","_secondaryAttachments","_primaryAttachments","_cargo","_param1","_gearbox","_side","_cargoArray","_isVehicle","_ACE_standard","_ACE_Advanced","_standard","_Supplies"];

    if !(isServer) exitWith {false};
    waitUntil {sleep 0.1; time > 1};

    _cargo = [_this, 0, objNull, [objNull]] call BIS_fnc_param;
    _param1 = [_this, 1] call BIS_fnc_param;
    _gearbox = toLower ([_param1, 0, "small_box", [""]] call bis_fnc_param);
    _side = toLower ([_param1, 1, "west", [""]] call bis_fnc_param);
    _cargoArray = [_this, 2, [true,true], [[]]] call BIS_fnc_param;
    _isVehicle = _cargo isKindOf "AllVehicles";
    if !(_isVehicle) Then {
        if !(_cargoArray select 0) then {  // Enable Move Object
            [_cargo, false] call ACE_Dragging_fnc_setCarryable;
            [_cargo, false] call ACE_Dragging_fnc_setDraggable;
            _cargo enableRopeAttach false;
        };
    };

    if ((_cargoArray select 1)) then {  // Can be destroyed
        _cargo allowDamage true;
    } else {
        _cargo allowDamage false;
    };

//  ====================================================================================

    switch (_side) do {
        case "west": {
            [] call compile preprocessFileLineNumbers ("Gear\Factions\Classes\" + GOL_Faction_West +".sqf");
        };
        case "east": {
            [] call compile preprocessFileLineNumbers ("Gear\Factions\Classes\" + GOL_Faction_East +".sqf");
        };
        case "indep": {
            [] call compile preprocessFileLineNumbers ("Gear\Factions\Classes\" + GOL_Faction_Indep +".sqf");
        };
        default {
            diag_log "Error in GearCargo faction";
        };
    };

//  ====================================================================================

    _ACE_standard = [
//      [ClassName, Gearbox,Extra Supplies,Standard Supplies],
        [_bandage, 100,75,40],
        [_morph, 100,50,20]
    ];

    _ACE_Advanced = [
        [_epi, 100,20],
        [_blood, 100,10]
    ];

    _standard = [
        [_glHE, 50,50,20],
        [_glsmokeY, 50,20,10],
        [_glflareW, 50,10,5],
        [_grenade, 50,30,20],
        [_grenademini, 50,30,20],
        [_smokegrenadeY, 50,30,20],
        [_smokegrenadeG, 50,10,5]
    ];

    _Supplies = {
        if (GOL_Gear_Extra) Then {
            { [_cargo, (_x select 0), (_x select 2)] call GOL_Fnc_AddObjectsCargo; } forEach _standard;
            { [_cargo, (_x select 0), (_x select 2)] call GOL_Fnc_AddObjectsCargo; } forEach _ACE_standard;
            { [_cargo, (_x select 0), (_x select 2)] call GOL_Fnc_AddObjectsCargo; } forEach _ACE_Advanced;
        } else {
            { [_cargo, (_x select 0), (_x select 3)] call GOL_Fnc_AddObjectsCargo; } forEach _standard;
            { [_cargo, (_x select 0), (_x select 3)] call GOL_Fnc_AddObjectsCargo; } forEach _ACE_standard;
        };
    };

    ClearWeaponCargoGlobal _cargo;
    ClearMagazineCargoGlobal _cargo;
    ClearItemCargoGlobal _cargo;
    ClearBackpackCargoGlobal _cargo;

//  Inventory
//  ====================================================================================
    switch (_gearbox) do {

        case "gear_box": {      //  Spawn Box

            [[[_cargo], {
                (_this select 0) addAction ["Platoon > Actual"," [player,'pl'] call GOL_Fnc_GearHandler; ",nil,1,false,false,"","((_target distance _this) < 5)"];
                (_this select 0) addAction ["Platoon > Forward Air Controller"," [player,'fac'] call GOL_Fnc_GearHandler; ",nil,1,false,false,"","((_target distance _this) < 5)"];
                (_this select 0) addAction ["Squad > Squad Leader"," [player,'sl'] call GOL_Fnc_GearHandler; ",nil,1,false,false,"","((_target distance _this) < 5)"];
                (_this select 0) addAction ["Squad > Fire Team Leader"," [player,'ftl'] call GOL_Fnc_GearHandler; ",nil,1,false,false,"","((_target distance _this) < 5)"];
                (_this select 0) addAction ["Squad > Rifleman"," [player,'r'] call GOL_Fnc_GearHandler; ",nil,1,false,false,"","((_target distance _this) < 5)"];
                (_this select 0) addAction ["Squad > Grenadier"," [player,'g'] call GOL_Fnc_GearHandler; ",nil,1,false,false,"","((_target distance _this) < 5)"];
                (_this select 0) addAction ["Squad > Asst. Gunner"," [player,'ag'] call GOL_Fnc_GearHandler; ",nil,1,false,false,"","((_target distance _this) < 5)"];
                (_this select 0) addAction ["Squad > Automatic Rifleman"," [player,'ar'] call GOL_Fnc_GearHandler; ",nil,1,false,false,"","((_target distance _this) < 5)"];
                (_this select 0) addAction ["Echo > Pilot"," [player,'p'] call GOL_Fnc_GearHandler; ",nil,1,false,false,"","((_target distance _this) < 5)"];
            }], "bis_fnc_call", true, true] call BIS_fnc_MP;

            { [_cargo, (_x select 0), (_x select 1)] call GOL_Fnc_AddObjectsCargo; } forEach _standard;
            [_cargo, _radio152, 50] call GOL_Fnc_AddObjectsCargo;
            [_cargo, _radio1000a, 50] call GOL_Fnc_AddObjectsCargo;
        };

        case "a_box": { //  Attachment Box

            // CCO
            [_cargo, "optic_Aco", 50] call GOL_Fnc_AddObjectsCargo;
            [_cargo, "optic_ACO_grn", 50] call GOL_Fnc_AddObjectsCargo;
            [_cargo, "FHQ_optic_AC11704", 50] call GOL_Fnc_AddObjectsCargo;
            [_cargo, "FHQ_optic_MicroCCO", 50] call GOL_Fnc_AddObjectsCargo;
            [_cargo, "FHQ_optic_AIM", 50] call GOL_Fnc_AddObjectsCargo;
            [_cargo, "FHQ_optic_HWS", 50] call GOL_Fnc_AddObjectsCargo;
//            [_cargo, "rhsusf_acc_eotech_552", 50] call GOL_Fnc_AddObjectsCargo;
            [_cargo, "rhsusf_acc_compm4", 50] call GOL_Fnc_AddObjectsCargo;

            // Items
            [_cargo, "ACE_muzzle_mzls_H", 50] call GOL_Fnc_AddObjectsCargo;
            [_cargo, "ACE_muzzle_mzls_B", 50] call GOL_Fnc_AddObjectsCargo;
            [_cargo, "ACE_muzzle_mzls_L", 50] call GOL_Fnc_AddObjectsCargo;
            [_cargo, "GVL_X2000_point", 50] call GOL_Fnc_AddObjectsCargo;
        };

        case "misc_box": {  //  Misc Box
            [_cargo, _bino, 50] call GOL_Fnc_AddObjectsCargo;
            [_cargo, _toolkit, 50] call GOL_Fnc_AddObjectsCargo;
            [_cargo, _demoCharge, 50] call GOL_Fnc_AddObjectsCargo;
            [_cargo, _satchelCharge, 50] call GOL_Fnc_AddObjectsCargo;

            [_cargo, _radio152, 50] call GOL_Fnc_AddObjectsCargo;
            [_cargo, _radio1000a, 50] call GOL_Fnc_AddObjectsCargo;
            [_cargo, _Android, 50] call GOL_Fnc_AddObjectsCargo;

            [_cargo, _mapTools, 50] call GOL_Fnc_AddObjectsCargo;
            [_cargo, _kestrel, 50] call GOL_Fnc_AddObjectsCargo;
            [_cargo, _IRStrobe, 50] call GOL_Fnc_AddObjectsCargo;
            [_cargo, _earplugs, 50] call GOL_Fnc_AddObjectsCargo;
            [_cargo, _clacker, 50] call GOL_Fnc_AddObjectsCargo;
            [_cargo, _defusalKit, 50] call GOL_Fnc_AddObjectsCargo;
            [_cargo, _cables, 100] call GOL_Fnc_AddObjectsCargo;
            [_cargo, _flashBang, 50] call GOL_Fnc_AddObjectsCargo;
            [_cargo, _barrel, 50] call GOL_Fnc_AddObjectsCargo;
        };

        case "med_box": {   //  Medical Box
            [_cargo, _bandage, 50] call GOL_Fnc_AddObjectsCargo;
            [_cargo, _morph, 50] call GOL_Fnc_AddObjectsCargo;
            [_cargo, _epi, 50] call GOL_Fnc_AddObjectsCargo;
            [_cargo, _blood, 50] call GOL_Fnc_AddObjectsCargo;
        };

        case "small_box":   {   //  Small Box
            [_cargo, _pistol_mag, 10] call GOL_Fnc_AddObjectsCargo;
            [_cargo, _rifle_mag, 32] call GOL_Fnc_AddObjectsCargo;
            [_cargo, _rifleGL_mag, 30] call GOL_Fnc_AddObjectsCargo;
            [_cargo, _carbine_mag, 5] call GOL_Fnc_AddObjectsCargo;
            [_cargo, _LMG_mag_tr, 12] call GOL_Fnc_AddObjectsCargo;

            [_cargo, _LAT, 3] call GOL_Fnc_AddObjectsCargo;
            [_cargo, _LATmag, 3] call GOL_Fnc_AddObjectsCargo;

            [_cargo, _demoCharge, 4] call GOL_Fnc_AddObjectsCargo;
            [_cargo, _satchelCharge, 2] call GOL_Fnc_AddObjectsCargo;

            [] call _Supplies;
        };

        case "big_box": {   //  Big Box
            [_cargo, _pistol_mag, 20] call GOL_Fnc_AddObjectsCargo;
            [_cargo, _rifle_mag, 60] call GOL_Fnc_AddObjectsCargo;
            [_cargo, _rifleGL_mag, 50] call GOL_Fnc_AddObjectsCargo;
            [_cargo, _carbine_mag, 10] call GOL_Fnc_AddObjectsCargo;
            [_cargo, _LMG_mag_tr, 24] call GOL_Fnc_AddObjectsCargo;

            [_cargo, _LAT, 6] call GOL_Fnc_AddObjectsCargo;
            [_cargo, _LATmag, 8] call GOL_Fnc_AddObjectsCargo;

            [_cargo, _demoCharge, 8] call GOL_Fnc_AddObjectsCargo;
            [_cargo, _satchelCharge, 4] call GOL_Fnc_AddObjectsCargo;

            [] call _Supplies;
        };

    };
