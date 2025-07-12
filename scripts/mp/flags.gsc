#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\gametypes\_hud_message;

#define ffa getdvar("g_gametype") == "dm"
#define gg getdvar("g_gametype") == "gun"

initflags()
{
    mapname = getDvar("mapname");
    switch(mapname)
    {
        case "mp_dockside":
            level thread cargo();
            break;
        case "mp_drone":
            level thread drone();
            break;
        case "mp_express":
            level thread express();
            break;
        case "mp_raid":
            level thread raid();
            break;
        case "mp_slums":
            level thread slums();
            break;
        case "mp_village":
            level thread standoff();
            break;
        case "mp_turbine":
            level thread turbine();
            break;
        case "mp_socotra":
            level thread yemen();
            break;
        case "mp_nuketown_2020":
            level thread nuketown();
            break;
        case "mp_downhill":
            level thread downhill();
            break;
        case "mp_mirage":
            level thread mirage();
            break;
        case "mp_hydro":   
            level thread hydro();
            break;
        case "mp_skate":
            level thread grind();
            break;
        case "mp_concert":
            level thread encore();
            break;
        case "mp_magma":
            level thread magma();
            break;
        case "mp_vertigo":
            level thread vertigo();
            break;
        case "mp_studio":
            level thread studio();
            break;
        case "mp_uplink":
            level thread uplink();
            break;
        case "mp_bridge":
            level thread detour();
            break;
        case "mp_castaway":
            level thread cove();
            break;
        case "mp_paintball":
            level thread rush();
            break;
        case "mp_dig":
            level thread dig();
            break;
        case "mp_frostbite":
            level thread frost();
            break;
        case "mp_pod":  
            level thread pod();
            break;
        case "mp_takeoff":
            level thread takeoff();
            break;
            
        default:
            break;
           
    }
}

cargo()
{
    oom((-1525.27, 2223.68, -67.875), (-4366.78, 3098.57, -65.875));
    oom((-1252.64, 152.565, -67.875), (57.8124, 7972.11, 407.012));
    oom((281.584, 3400.67, -67.875), (-746.526, 5363.53, 228.125));
    oom((-54.1407, 1413.4, -100.875), (3424.74, -5075.4, 365.398));
    level addcrate("mp_dockside", (57.8124, 7972.11, 407.012));
    level addcrate("mp_dockside", (3424.74, -5075.4, 365.398));
}

drone()
{
    oom((-1828.21, -1355.32, 80.125), (-4475.76, -13808.4, 483.824));
    oom((1209.34, 2850.77, 308.227), (-383.109, 8699.64, 628.681));
    oom((-19.3959, 262.898, 113.125), (-13433.6, 1571.56, 80.125));
}

express()
{
    oom((2065.43, 672.099, -119.875), (2835.98, 1009.33, 76.125));
    oom((81.5771, 2054.81, -15.6859), (-118.031, 2306.42, 141.784));
    oom((1932.07, -821.555, -119.875), (2178.78, -953.398, 75.0592));
    oom((-472, -1116, -39), (-3269, -3461, 375));
    oom((2322, 2, -120), (4489, 208, 395));
    level addcrate("mp_express",(4489, 208, 395));
    level addcrate("mp_express",(-3269, -3461, 375));
}

raid()
{
    oom((4303.68, 4121.77, 30.125), (6830, 4403, 767)); // Raid Road OOM
}

slums()
{
    oom((495.109, 2064.27, 576.125), (1823.31, 1780.59, 1008.13)); //main oom 1
    oom((724.288, -3456.36, 511.384), (895.938, -4450.34, 1134.1)); //main oom 2
}

standoff()
{
    oom((-1545.64, 122.031, 8.125), (-4309.31, 17882, 3701.87)); //narnia
    oom((-1521.58, -2497.42, 7.67665), (-55.6689, -4234.37, 386.158)); //barn
    oom((1596.01, -586.898, 8.125), (1588.53, -4327.57, 356.935)); //light pole

    level addcrate("mp_village", (-55.6689, -4234.37, 386.158)); //barn
    level addcrate("mp_village", (1588.53, -4327.57, 356.935)); //light pole
}

turbine()
{
    oom((-451.95, -1483.98, 162.428), (-1141, -3353, 674)); // Turbine OOM
    oom((-771.828, 2586.18, 308.143), (-496.636, 6061.38, 711.659));
    oom((613.404, 4328.18, -169.324), (2078.43, 6648.67, 108.704));
    oom((1384.48, 1812.86, -15.1224), (-1443.23, -4748.53, 3287.52));
	oom((-200.688, 3167.76, 465.732), (2972.67, 6600, 3287.77));
    level addplatform("mp_turbine", (2972.67, 6600, 3287.77), 3, 3);
	level addplatform("mp_turbine", (-1443.23, -4748.53, 3287.52), 3, 3);
    level addcrate("mp_turbine", (-1141, -3353, 674));
}

yemen()
{
    oom((-1150.22, -79.7476, 195.669), (715.533, 2955.53, 1188));
}

nuketown()
{
    oom((28.678, -564.446, -66.9508), (-1511.33, -1254.81, 66.425));
    oom((-1844.93, 401.3, -61.875), (7163.95, -4944.31, 2520.87));
    oom((-968.977, -160.111, -61.9793), (-4704.89, -8789.66, 3251.38));
    level addcrate("mp_nuketown_2020", (7163.95, -4944.31, 2520.87));
    level addcrate("mp_nuketown_2020", (-4704.89, -8789.66, 3251.38));
}

downhill()
{
    oom((168.452, -2840.21, 1047.23), (168.452, -2950.21, 1047.23));
    oom((-787.209, -69.5974, 1040.12), (-2663, -178, 1976));
    oom((2936.42, -175.496, 915.982), (3285, -132, 1272));
    level addcrate("mp_downhill",(-2663, -178, 1976));
    level addcrate("mp_downhill",(3285, -132, 1272));
}

mirage()
{
    oom((-2676.59, 882.482, -51.0892), (-2936.57, 944.85, 117.685));
    oom((3008.36, 1306.74, 54.6458), (3081.64, 1306.89, 102.824));
}

hydro()
{
    oom((1997.22, 147.565, 84.5813), (3481.85, 2651.46, 216.125)); //Side 1
    oom((-2094.38, 120.127, 84.8019), (-3685.96, 2555.78, 256.125)); //Side 2
    oom((-30.5131, -263.556, 239.024), (8162.52, 22554.2, 8043.84)); //Middle
    oom((-69.6409, -1147.36, 312.125), (-1702.08, 23462, 3895.44));
    level addcrate("mp_hydro", (-1702.08, 23462, 3895.44));
}

grind()
{
    oom((896.358, 910.359, 164.125), (5926.99, 2038.25, 1309.69));
    level addplatform("mp_skate", (5853.65, 2058.69, 1293.81), 1, 3);
    oom((816.043, -1687.86, 136.125), (883, -3024, 550));
    level addcrate("mp_skate",(883, -3024, 550));
    oom((2841.29, -188.373, 164.125), (6529.06, -525.865, 892.166));
    level addcrate("mp_skate",(6529.06, -525.865, 892.166));
    oom((-2475.36, -828.359, 256.125), (-5483.72, -4751.68, 2078.96));
    level addcrate("mp_skate", (-5483.72, -4751.68, 2078.96));
    oom((1997.92, -1024.63, 165.058), (4422.22, -2134.56, 448.907));
}

encore()
{
    oom((2019.52, 2390.59, 24.125), (1701.87, 5240.53, 32.125));
    oom((2148.36, 956.359, 24.125), (2533.8, 1486.81, 0.161159));
    oom((-2341.36, 421.532, -70.7808), (-2861.91, 468.705, -69.4947));
    oom((-1114, -478, -60), (-1945, -8110, -820));
    oom((-705, -2870, -24), (1195, 5435, 313));
    oom((-2341.36, -6.07946, -71.875), (-4750, 889, 506)); 
    oom((-2341.36, -464.214, -71.875), (-12244, -1328, 359));
    oom((1410.26, -169.011, -23.875), (16403, 5262, 5461));
    level addcrate( "mp_concert",(1195, 5435, 313));
    level addcrate( "mp_concert",(-1945, -8110, -822));
    level addcrate( "mp_concert",(-4757, 901, 473));
    level addcrate( "mp_concert",(-4750, 889, 506));
    level addcrate( "mp_concert",(-12244, -1328, 359));
    level addcrate( "mp_concert",(16403, 5262, 5461));
}

magma()
{
    oom((-1697.09, -150.475, -495.875), (-3484, 904, 667));
    oom((215.553, 930.501, -389.158), (779, 1417, 1338));
    level addcrate("mp_magma",(-3484, 904, 667));
    level addcrate("mp_magma",(779, 1417, 1338));
}

vertigo()
{
    oom((893.517, 6.48486, 104.125), (4196.11, 546.896, 1856.13)); // OOM Middle
    oom((-2034.98, -1.62018, -84.875), (-2610.74, -160.659, 624.125)); // Heli Pad
    oom((260.948, 3241.49, -20.875), (4198.72, 3205.14, -319.875));
    oom((-153.614, -3087.43, -35.875), (4205.15, -2372.53, -319.875));
    oom((712.717, -1223.14, 9.82775), (3790, -1056, -64.3747));
    oom((-1112.19, 1246.33, 12.1038), (-10738, 336, 538));
    level addcrate("mp_vertigo", (3790, -1056, -64.3747));
    level addcrate("mp_vertigo", (-10738, 336, 538));
}

studio()
{
    oom((120.61, -866.516, -127.875), (537.286, -1202.98, 218.297)); //normal out of map
    oom((1383.64, 2538.36, -48.7516), (3450.57, 4842.98, 4657.08)); //narnia
    oom((1083.26, -137.666, -21.875), (1467.02, -182.529, 129.125)); //shed
    oom((-388.359, -351.359, -123.875), (-2350.2, -1720.89, 860.747)); //outside studio oom
    level addplatform("mp_studio", (-4362.72, -1720.8, 882.367), 1, 33);
    oom((-717.83, -874.209, -127.875), (72.2104, -3699.09, 889.693)); //other outside studio oom
    level addplatform("mp_studio", (74.756, -5706.22, 884.568), 33, 1);
    oom(( 2112.36, 2234.45, -39.875), (4680.21, 4172.93, 473.429));
    level addplatform("mp_studio", (4238.45, 3682.46, 457.554), 19, 14);
    oom((2680.36, 1522.59, -35.875), (3571.7, 1551.71, -43.875));
    oom((-186.63, 2536.36, -46.875), (-1793.79, 3786.61, 884.741));
    level addcrate("mp_studio", (-1793.79, 3786.61, 884.741));
}

uplink()
{
    oom((3629.06, -3393.89, 352.125), (4210.97, -7084.61, 2184.13)); 
    oom((2942.39, 2056.32, 288.125), (2490.72, 3259.63, 179.532));
    oom((3777.52, -2392.25, 404.05), (5794.15, -2190, 2105.05));
    oom((2461.86, -2587.29, 352.125), (1657, -4139, 671));
    oom((1688, -383, 112), (4527, -270, 1036));
    level addcrate("mp_turbine",(4527, -270, 1036));
    level addcrate("mp_uplink",(1657, -4139, 671));
}

detour()
{
    oom((-2973.57, -698.824, -57.5285), (-3370.15, -695.976, 223.125));
    oom((-2986.63, -365.17, -61.3895), (-15020.2, -5.889, -3.602));
    oom((2728.31, 508.124, 0.125), (12114.9, -3.07917, 7.0364));
    oom((-1328.77, -878.359, -86.3772), (-17300.7, -7385.69, 1034.06)); //gospel's request
    level addplatform("mp_bridge", (-17300.7, -7385.69, 1034.06), 11, 1);
}

cove()
{
    oom((191.686, -1242.88, 137.665), (3053, -16992, 498));
    oom((-1287, 529, 180), (4698, 1878, 995));
    level addcrate("mp_castaway", (4698, 1878, 995));
    level addplatform("mp_castaway", (2952.57, -17044.8, 493.357), 3, 3);
}

rush()
{
    oom((-1185.1, 1138.12, 20.7078), (-1607.9, 269.699, 241.125));
    oom((-2083.4, 301.465, -7.27876), (-1607.9, 269.699, 241.125));
    oom((-2109.63, -1480.67, -20.3812), (-1590.99, -1037.95, 241.125));
    oom((650.598, -2400.17, -5.875), (-4304, 1359, 589));
    oom((212.852, 1988.42, 2.2839), (-3494, 2244, 237));
    oom((942.359, -834.314, 188.125), (2120, -2029, 343));
    level addcrate("mp_paintball", (-4304, 1359, 589));
    level addcrate("mp_paintball", (-3494, 2244, 237));
    level addcrate("mp_paintball", (2120, -2029, 343));
}

dig()
{
    oom((-1811.19, 427.461, 80.125), (-3786, 1905, 588));
    oom((1100.36, -145.417, 120.125), (1139.64, -142.565, 121.125));
    oom((-1021.09, -1750.7, 72.125), (-903, -1995, 531));
    oom((2406.62, -396.359, 296.125), (6093, -257, 1860));
    level addcrate("mp_dig", (-3786, 1905, 585));
    level addcrate("mp_dig", (-903, -1995, 531));
    level addcrate("mp_dig", (6093, -257, 1860));
}

frost()
{
    oom((-1968.99, -1188.74, 1.09923), (-1667, -3561, 832));
    oom((2712, 162, 4), (5340, 596, 721));
    oom((671.641, 1023.64, 4.19765), (78, 5279, 832));
    level addcrate("mp_frostbite", (5340, 596, 721));
}

pod()
{
    oom((-1902.09, 2239.73, 483.217), (-2002.61, 2440.38, 480.562));
    oom((608.684, 697.977, 309.012), (3549.31, 3045.41, 1994.13)); //main tower
    oom((1212, 31, 251), (6111, 1310, 1643));
    oom((1553, -52, 439), (-4684, -1941, 1143));
    oom((-1774.38, 422.109, 431.181), (-2856, 3701, 1010));
    oom((743.015, -2015.7, 373.891), (3016, -2216, 866));
    oom((3548.58, 3128.52, 750.35), (3549.31, 3045.41, 1994.13)); //return flag to main tower
    level addcrate("mp_pod",(-4684, -1941, 1145));
    level addcrate("mp_pod",(6111, 1310, 1645));
    level addcrate("mp_pod",(-2856, 3701, 1010));
    level addcrate("mp_pod",(3016, -2216, 866));
}

takeoff()
{
    oom((-347.863, 4400.36, 32.125), (-371.394, 5144.58, 115.426));
    oom((-1022.5, 2494.49, -55.875), (-1500.43, 2495.62, -47.875));
    oom((2003, 1817, -0), (2799, 2055, 302));
    oom((-1726, -219, -0), (-4663, 251, 582));
    level addcrate("mp_takeoff",(2799, 2055, 302));
    level addcrate("mp_takeoff",(-4663, 251, 582));
}

oom(enter, exit)
{
    enf = spawnentity("script_model", "mp_flag_allies_1", enter, (0, 0, 0));
    exf = spawnentity("script_model", "mp_flag_allies_1", exit, (0, 0, 0));
    level thread fthink(enf, exf);
}

fthink(enf, exf)
{
    level endon("game_ended");
    for(;;)
    {
        foreach(player in level.players)
        {
            if(isonlast(player))
            {
                if(distance(player.origin, enf.origin) < 25)
                {
                    player setorigin(exf.origin + vectorscale(anglestoforward((0, player.angles[1], 0)), 30));
                    exf hide();
                }
            }
        }
        wait 0.1;
    }
}

spawnentity(eclass, model, origin, angle, solid)
{
    if(!isdefined(model) || !isstring(model))
        return undefined;
    
    entity = spawn(eclass, origin);
    if(!isdefined(entity))
        return undefined;
    
    entity.angles = angle;
    entity setmodel(model);

    if(!isdefined(level.entities))
        level.entities = [];
    
    if(!isdefined(level.amountofentities))
        level.amountofentities = 0;
    
    level.entities[level.amountofentities] = entity;
    level.amountofentities++;

    if(isdefined(solid) && solid)
        entity notsolid();
    
    return entity;
}

isonlast(player)
{
    return player scripts\mp\utils::isonlast();
}

addplatform(map, origin, width, length)
{
    if(level.script != map) 
        return;
    platform = [];    
    for(e=0;e<width;e++) for(a=0;a<length;a++)
    {
        platform[platform.size] = spawn("script_model", origin + (a*64,e*64,0)); 
        platform[platform.size-1] setModel("collision_clip_64x64x10"); 
    }
    return platform; 
}

addplatform2(map, origin, width, length)
{
    if(level.script != map) 
        return;
    platform = [];    
    for(e=0;e<width;e++) for(a=0;a<length;a++)
    {
        platform[platform.size] = spawn("script_model", origin + (a*64,e*64,0)); 
        platform[platform.size-1] setModel("t6_wpn_supply_drop_trap"); 
    }
    return platform; 
}

addcrate(map, origin)
{
    if(level.script != map)
        return;
    platform = spawn("script_model", origin);
    platform setmodel("collision_clip_64x64x10");
    return platform;
}