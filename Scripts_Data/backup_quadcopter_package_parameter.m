% Parameters for quadcopter_package_delivery (Octaquad, 22 kg)
% Copyright 2021-2025 The MathWorks, Inc.

planex = 12.5;
planey = 8.5;
planedepth = 0.2;

battery_capacity = 450;

%% Material Property
rho_pla = 1.25;

drone_mass = 22;

%% Package ground contact properties
% pkgGrndStiff  = 1000;
% pkgGrndDamp   = 300;
% pkgGrndTransW = 1e-3;
pkgGrndStiff  = 1e4;
pkgGrndDamp   = 1e3;
pkgGrndTransW = 1e-4;

%% Package parameters
pkgSize = [2 1 1]*0.14;
pkgDensity = 1/(pkgSize(1)*pkgSize(2)*pkgSize(3));

%% Propeller parameters (CORRECTED from motor test data)
propeller.diameter = 0.5588;   % m (22 in)
propeller.Kthrust  = 0.074;    % Ct (was 2.5 — 34x too high!)
propeller.Kdrag    = 0.0036;   % Cq (was 0.51 — 140x too high!)

air_rho            = 1.225;
air_temperature    = 273+25;
wind_speed         = 0;

%% Leg parameters
drone_leg.Extr_Data = flipud([...
    0     0;
    0.5   0;
    1    -1;
    0.98 -1;
    0.5  -0.02;
   -0.5  -0.02;
   -0.98 -1;
   -1    -1;
   -0.5   0].*[1 1]*0.15);
drone_leg.width = 0.01;

%% Motor parameters (CORRECTED from HV6215-210KV datasheet)
qc_motor.max_torque     = 3.68;    % N*m (100% throttle, from test data)
qc_motor.max_power      = 3750;    % W
qc_motor.time_const     = 0.03;    % sec (was 0.07 — too sluggish for BLDC)
qc_motor.efficiency     = 88;      % %
qc_motor.efficiency_spd = 2931;    % rpm (peak eff at 32% throttle)
qc_motor.efficiency_trq = 0.56;    % N*m (at peak efficiency)
qc_motor.rotor_damping  = 5e-4;    % N*m/(rad/s)

qc_max_power = qc_motor.max_power;

Motor.Throttle_pct  = [32 33 36 39 42 45 48 51 54 57 60 63 66 69 72 75 78 81 84 87 90 100]';
Motor.Thrust_g      = [2117 2174 2562 3007 3484 3974 4465 4950 5429 5902 6374 6853 7345 7858 8398 8969 9573 10208 10866 11535 12197 13879]';
Motor.Current_A     = [4.9 5.1 6.3 7.9 9.6 11.6 13.7 15.9 18.3 20.7 23.2 25.9 28.8 31.9 35.3 39.2 43.4 48.1 53.3 58.9 64.7 81.2]';
Motor.Power_W       = [227.3 235.2 291.3 361.6 443.3 534.0 631.4 733.8 840.5 951.5 1067.8 1191.0 1323.3 1467.4 1626.1 1802.2 1997.8 2214.4 2451.9 2707.5 2975.3 3733.4]';
Motor.Speed_RPM     = [2931 2968 3216 3477 3736 3981 4210 4424 4624 4813 4995 5174 5352 5533 5719 5909 6104 6301 6495 6681 6851 7220]';
Motor.Eff_g_per_W   = [9.3 9.2 8.8 8.3 7.9 7.4 7.1 6.7 6.5 6.2 6.0 5.8 5.6 5.4 5.2 5.0 4.8 4.6 4.4 4.3 4.1 3.7]';
Motor.Torque_Nm     = [0.56 0.57 0.67 0.78 0.91 1.03 1.16 1.29 1.41 1.54 1.66 1.79 1.92 2.05 2.20 2.35 2.51 2.68 2.86 3.05 3.23 3.68]';
Motor.Temperature_C = [125 NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN]';

%% Controller parameters — REVISED for 22 kg octaquad
 
% --- Position (much less aggressive) ---
filtM_position = 0.005;
% kp_position    = 1.5;     % was 5 — too aggressive for heavy drone
% kd_position    = 1.0;     % was 2.5
kp_position    = 0.8;     % was 1.5
ki_position    = 0.01;
kd_position    = 1.5;     % was 1.0
filtD_position = 100;
% pos2attitude   = 0.3;     % was 1.5 — CRITICAL: limits max tilt command
pos2attitude   = 0.3;    % was 0.3

% --- Attitude (more derivative damping) ---
filtM_attitude = 0.01;
kp_attitude    = 100;     % was 200 — reduce to prevent oscillation
ki_attitude    = 3;       % was 8 — reduce to prevent windup
kd_attitude    = 80;      % was 50 — INCREASE for more damping
filtD_attitude = 250;
limit_attitude = 200;     % was 300

% --- Yaw ---
filtM_yaw      = 0.01;
filtD_yaw      = 100;
kp_yaw         = 80;      % was 40
ki_yaw         = 2;       % was 2
kd_yaw         = 30;      % was 15
limit_yaw      = 150;     % was 50

% --- Altitude (RETUNED — ki was too high causing overshoot) ---
filtM_altitude = 0.05;
kp_altitude    = 0.5;    % ~17x original 0.27 (mass ratio)
ki_altitude    = 2.5;    % ~17x original 0.07, conservative
% ki_altitude    = 0.1;    % ~17x original 0.07, conservative
kd_altitude    = 8.5;    % ~17x original 0.35
filtD_altitude = 100;
limit_altitude = 150;    % N, max correction above/below hover

% --- Motor speed controller ---
kp_motor       = 0.05;
ki_motor       = 0.001;
kd_motor       = 0;
filtD_motor    = 1000;
filtSpd_motor  = 0.001;
limit_motor    = 0.5;    % was 0.02 — far too restrictive!

%% Drag coefficients
qd_drag.Cd_X  = 0.35;
qd_drag.Cd_Y  = 0.35;
qd_drag.Cd_Z  = 0.6;
qd_drag.Roll  = 0.2;
qd_drag.Pitch = 0.2;
qd_drag.Yaw   = 0.2;
qd_area.YZ    = 2*0.0875;
qd_area.XZ    = 2*0.0900;
qd_area.XY    = 2*0.2560;
qd_area.Roll  = qd_area.XY*2;
qd_area.Pitch = qd_area.XY*2;
qd_area.Yaw   = qd_area.XY;