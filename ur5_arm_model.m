% Dynamics Fall 2015: Final Project
% Robot arm model
% Amanda Sutherland + Franz Schneider 
% taken from http://folk.ntnu.no/ragazzon/publication_files/project_thesis.pdf

function ur5_arm_model
clc; clear all; close all;

%setting up initial angles
q1_init = 0 ; 
q2_init = 0 ;
q3_init = 0 ;
q4_init = 0 ;
q5_init = 0 ;
q6_init = 0 ;

%setting up initial velocities
Dq1_init = 0 ; 
Dq2_init = 0 ;
Dq3_init = 0 ;
Dq4_init = 0 ; 
Dq5_init = 0 ;
Dq6_init = 0 ;

%setting up initial conditions
g = 9.81 ;

%% Run ODE
    initial = [q1_init, Dq1_init, q2_init, Dq2_init, q3_init, Dq3_init, q4_init, ...
        Dq4_init, q5_init, Dq5_init, q6_init, Dq6_init];
    t_span = 0:0.025:15;
    options = odeset('RelTol', 1e-5);
    [tout, res] = ode45(@arm_calculate, t_span, initial, options);

%% ODE function
    function zout = arm_calculate(t,Z)
        %unpack variables 
        q1 = Z(1);
        Dq1  = Z(2);
        q2 = Z(3);
        Dq2  = Z(4);
        q3 = Z(5);
        Dq3  = Z(6);
        q4 = Z(7);
        Dq4  = Z(8);
        q5 = Z(9);
        Dq5  = Z(10);
        q6 = Z(11);
        Dq6  = Z(12);

        %The expression for the elements of M,C,g are copied from Maple, and state ...
        %derivatives have been redefined
        m11 = cos(q5) * 0.291736320000000014e-2 + cos((2 * q2)) * 0.413642134999999911e0 + ...
        cos((2 * q2) + 0.2e1 * q5) * (-0.162630325872825665e-18) + cos((2 * q2) - 0.2e1 ...
        * q5) * (-0.162630325872825665e-18) + cos((2 * q4)) * ...
        (-0.433680868994201774e-18) + cos((2 * q2 + 2 * q4)) * 0.433680868994201774e-18 ...
        + cos((2 * q3 + 2 * q4)) * 0.433680868994201774e-18 + cos(0.2e1 * q5 + (2 * q4) ...
        + (2 * q3) + (2 * q2)) * (-0.132212075305000016e-3) + cos(-0.2e1 * q5 + (2 * q4) ...
        + (2 * q3) + (2 * q2)) * (-0.132212075305000016e-3) + cos(0.2e1 * q5) * ...
        0.264424150609999706e-3 + cos((2 * q4 + 2 * q3 + 2 * q2)) * ...
        (-0.462956163999961659e-5) + cos(q5 + (2 * q4) + (2 * q3) + (2 * q2)) * ...
        0.813151629364128326e-19 + cos(-q5 + (2 * q4) + (2 * q3) + (2 * q2)) * ...
        0.813151629364128326e-19 + sin((q4 + q3 + 2 * q2)) * (-0.777807799999999990e-2) ...
        + sin((q4 + q3)) * (-0.777807799999999990e-2) + sin(q5 + q4 + q3 + (2 * q2)) * ...
        0.284376000000000030e-2 + sin(-q5 + q4 + q3 + (2 * q2)) * ...
        (-0.284376000000000030e-2) + sin(q5 + q4 + q3) * 0.284376000000000030e-2 + ...
        sin(-q5 + q4 + q3) * (-0.284376000000000030e-2) + 0.578636171160119894e0 + ...
        cos((2 * q2) + (2 * q4) - q5) * (-0.271050543121376109e-19) + cos((2 * q3) + (2 ...
        * q4) + q5) * 0.271050543121376109e-19 + cos((2 * q4) + q5) * ...
        0.271050543121376109e-19 + cos((2 * q2) + (2 * q4) + q5) * ...
        (-0.271050543121376109e-19) + cos((2 * q3 + 2 * q2)) * 0.225799867760000036e-1 + ...
        cos((2 * q3) + (2 * q4) - q5) * 0.271050543121376109e-19 + cos((2 * q4) - q5) * ...
        0.271050543121376109e-19;

        m12 = cos((q2 - 2 * q5 - q4 - q3)) * 0.325260651745651330e-18 + cos((2 * q5 + q4 + ...
        q3 + q2)) * (-0.264424150609999706e-3) + cos((q5 + q4 + q3 + q2)) * ...
        (-0.729340800000000036e-3) + sin((q5 + q2)) * 0.284376000000000030e-2 + sin((-q5 ...
        + q2)) * 0.284376000000000030e-2 + cos((-2 * q5 + q4 + q3 + q2)) * ...
        0.264424150610000032e-3 + cos((-q5 + q4 + q3 + q2)) * 0.729340800000000036e-3 + ...
        sin(q2) * 0.267177490999999989e0 + cos((q4 + q3 + q2)) * 0.202230028000000006e-2;

        m13 = cos(q4 + q3 + q2) * 0.202230028000000006e-2 + cos(q5 + q4 + q3 + q2) * ...
        (-0.729340800000000036e-3) + cos(-0.2e1 * q5 + q4 + q3 + q2) * ...
        0.264424150610000032e-3 + cos(-q5 + q4 + q3 + q2) * 0.729340800000000036e-3 + ...
        cos(0.2e1 * q5 + q4 + q3 + q2) * (-0.264424150610000032e-3);

        m14 = cos(q4 + q3 + q2) * 0.202230028000000006e-2 + cos(q5 + q4 + q3 + q2) * ...
        (-0.729340800000000036e-3) + cos(-0.2e1 * q5 + q4 + q3 + q2) * ...
        0.264424150610000032e-3 + cos(-q5 + q4 + q3 + q2) * 0.729340800000000036e-3 + ...
        cos(0.2e1 * q5 + q4 + q3 + q2) * (-0.264424150610000032e-3);

        m15 = sin(-q5 + q2) * 0.284376000000000030e-2 + cos(q4 + q3 + q2) * ...
        (-0.201419266993000008e-2) + cos(-q5 + q4 + q3 + q2) * ...
        (-0.729340800000000036e-3) + cos(q5 + q4 + q3 + q2) * (-0.729340800000000036e-3) ...
        + sin(q5 + q2) * (-0.284376000000000030e-2);

        m16 = -0.6087959740e-4 * cos(-q5 + q4 + q3 + q2) + 0.6087959740e-4 * cos(q5 + q4 + ...
        q3 + q2);

        m21 = sin(q2) * 0.267177490999999989e0 + cos(q4 + q3 + q2) * ...
        0.202230028000000006e-2 + cos(-(2 * q5) + q4 + q3 + q2) * ...
        0.264424150610000032e-3 + sin(q5 + q2) * 0.284376000000000030e-2 + sin(-q5 + q2) ...
        * 0.284376000000000030e-2 + cos((2 * q5) + q4 + q3 + q2) * ...
        (-0.264424150610000032e-3) + cos(-q5 + q4 + q3 + q2) * 0.729340800000000036e-3 + ...
        cos(q5 + q4 + q3 + q2) * (-0.729340800000000036e-3);

        m22 = sin(-q5 + q4 + q3) * (-0.568752000000000060e-2) + sin(q4 + q3) * ...
        (-0.155561560000000015e-1) + 0.885518424388219927e0 + cos(0.2e1 * q5) * ...
        (-0.528848301220000063e-3) + sin(q5 + q4 + q3) * 0.568752000000000060e-2;

        m23 = cos((2 * q5)) * (-0.528848301220000063e-3) + sin((-q5 + q4 + q3)) * ...
        (-0.284376000000000030e-2) + sin((q5 + q4 + q3)) * 0.284376000000000030e-2 + ...
        0.496708343882199949e-1 + sin((q4 + q3)) * (-0.777807799999999903e-2);

        m24 = sin(q5 + q4 + q3) * 0.284376000000000030e-2 + cos(0.2e1 * q5) * ...
        (-0.528848301220000063e-3) + sin(q4 + q3) * (-0.777807799999999903e-2) + sin(-q5 ...
        + q4 + q3) * (-0.284376000000000030e-2) + 0.291008553822000044e-2;

        m25 = sin(-q5 + q4 + q3) * 0.284376000000000030e-2 + sin(q5 + q4 + q3) * ...
        0.284376000000000030e-2;

        m26 = 0.1217591948e-3 * cos(q5);

        m31 = cos(q4 + q3 + q2) * 0.202230028000000006e-2 + cos(q5 + q4 + q3 + q2) * ...
        (-0.729340800000000036e-3) + cos(-0.2e1 * q5 + q4 + q3 + q2) * ...
        0.264424150610000032e-3 + cos(-q5 + q4 + q3 + q2) * 0.729340800000000036e-3 + ...
        cos(0.2e1 * q5 + q4 + q3 + q2) * (-0.264424150610000032e-3); %end page 1

        m32 = sin(-q5 + q4 + q3) * (-0.284376000000000030e-2) + cos(0.2e1 * q5) * ...
        (-0.528848301220000063e-3) + sin(q4 + q3) * (-0.777807800000000077e-2) + ...
        0.496708343882199949e-1 + sin(q5 + q4 + q3) * 0.284376000000000030e-2;

        m33 = 0.496708343882199949e-1 + cos((2 * q5)) * (-0.528848301220000063e-3);

        m34 = 0.291008553822000044e-2 + cos((2 * q5)) * (-0.528848301220000063e-3);

        m35 = 0.0e0;

        m36 = 0.1217591948e-3 * cos(q5);

        m41 = cos(q4 + q3 + q2) * 0.202230028000000006e-2 + cos(q5 + q4 + q3 + q2) * ...
        (-0.729340800000000036e-3) + cos(-0.2e1 * q5 + q4 + q3 + q2) * ...
        0.264424150610000032e-3 + cos(-q5 + q4 + q3 + q2) * 0.729340800000000036e-3 + ...
        cos(0.2e1 * q5 + q4 + q3 + q2) * (-0.264424150610000032e-3);

        m42 = sin(-q5 + q4 + q3) * (-0.284376000000000030e-2) + sin(q5 + q4 + q3) * ...
        0.284376000000000030e-2 + cos(0.2e1 * q5) * (-0.528848301220000063e-3) + sin(q4 ...
        + q3) * (-0.777807800000000077e-2) + 0.291008553822000044e-2;

        m43 = 0.291008553822000001e-2 + cos((2 * q5)) * (-0.528848301220000063e-3);

        m44 = 0.291008553822000044e-2 + cos((2 * q5)) * (-0.528848301220000063e-3);

        m45 = 0.0e0;

        m46 = 0.1217591948e-3 * cos(q5);

        m51 = sin(-q5 + q2) * 0.284376000000000030e-2 + cos(q5 + q4 + q3 + q2) * ...
        (-0.729340800000000036e-3) + sin(q5 + q2) * (-0.284376000000000030e-2) + cos(q4 ...
        + q3 + q2) * (-0.201419266993999990e-2) + cos(-q5 + q4 + q3 + q2) * ...
        (-0.729340800000000036e-3);

        m52 = sin(-q5 + q4 + q3) * 0.284376000000000030e-2 + sin(q5 + q4 + q3) * ...
        0.284376000000000030e-2;

        m53 = 0.0e0;

        m54 = 0.0e0;

        m55 = 0.201419266993000008e-2;

        m56 = 0.0e0;

        m61 = -0.6087959740e-4 * cos(-q5 + q4 + q3 + q2) + 0.6087959740e-4 * cos(q5 + q4 + ...
        q3 + q2);

        m62 = 0.1217591948e-3 * cos(q5);

        m63 = 0.1217591948e-3 * cos(q5);

        m64 = 0.1217591948e-3 * cos(q5);

        m65 = 0.0e0;

        m66 = 0.1217591948e-3;

        g1 = 0;

        g2 = g * sin(-q5 + q4 + q3 + q2) * 0.669120000000000045e-2 + cos(q2) * g * ...
        (-0.237166999999999994e1) + g * sin(q5 + q4 + q3 + q2) * ...
        (-0.669120000000000045e-2) + sin(q4 + q3 + q2) * g * 0.183013599999999992e-1;

        g3 = g * sin(q5 + q4 + q3 + q2) * (-0.669120000000000045e-2) + sin(q4 + q3 + q2) * ...
        g * 0.183013599999999992e-1 + g * sin(-q5 + q4 + q3 + q2) * 0.669120000000000045e-2;

        g4 = g * sin(q5 + q4 + q3 + q2) * (-0.669120000000000045e-2) + sin(q4 + q3 + q2) * ...
        g * 0.183013599999999992e-1 + g * sin(-q5 + q4 + q3 + q2) * 0.669120000000000045e-2;

        g5 = g * sin(-q5 + q4 + q3 + q2) * (-0.669120000000000045e-2) + g * sin(q5 + q4 + ...
        q3 + q2) * (-0.669120000000000045e-2);

        g6 = 0.0e0;

        cdq1 = 0.5000000000e-14 * Dq3 * Dq6 * sin((2 * q6 + q4 + q3 + q2 - q5)) + ...
        0.2500000000e-14 * Dq3 * Dq6 * sin((-2 * q6 + q4 + q3 + q2 + 2 * q5)) - ...
        0.2500000000e-14 * Dq1 * Dq6 * sin((-2 * q6 + 2 * q4 + 2 * q3 + 2 * q2 - q5)) - ...
        0.2500000000e-14 * Dq1 * Dq6 * sin((2 * q6 + q5)) - 0.2500000000e-14 * Dq1 * Dq6 ...
        * sin((-2 * q6 + 2 * q4 + 2 * q3 + 2 * q2 + q5)) - 0.5000000000e-14 * Dq1 * Dq6 ...
        * sin((2 * q4 + 2 * q3 + 2 * q2)) + 0.5000000000e-14 * Dq1 * Dq6 * sin((-2 * q6 ...
        + 2 * q4 + 2 * q3 + 2 * q2)) + Dq1 * Dq2 * cos((q5 + q4 + q3 + 2 * q2)) * ...
        0.568752000000000060e-2 + Dq1 * Dq2 * cos((-q5 + q4 + q3 + 2 * q2)) * ...
        (-0.568752000000000060e-2) + Dq1 * Dq2 * cos((q5 + q4 + q3)) * ...
        (-0.433680868994201774e-18) + Dq1 * Dq2 * sin((2 * q2 + 2 * q5)) * ...
        0.499999889581881352e-13 + Dq1 * Dq2 * sin((2 * q2)) * (-0.827284270000549826e0) ...
        + Dq1 * Dq2 * sin((2 * q5 + 2 * q4 + 2 * q3 + 2 * q2)) * 0.264424150710000009e-3 ...
        + Dq1 * Dq2 * sin((2 * q3)) * 0.499999347480795109e-12 + Dq1 * Dq2 * sin((2 * q4 ...
        + 2 * q3 + 2 * q2)) * 0.925912333000003529e-5 + Dq1 * Dq2 * sin((2 * q3 + 2 * ...
        q4)) * 0.499999347480795109e-13 + Dq1 * Dq2 * sin((2 * q2 - 2 * q5)) * ...
        (-0.499996908025907016e-13) + Dq1 * Dq2 * sin((2 * q3 + 2 * q2)) * ...
        (-0.451599735515000045e-1) + Dq1 * Dq2 * sin((2 * q3 + 2 * q4 - 2 * q5)) * ...
        0.499999889581881352e-13 + Dq1 * Dq2 * sin((2 * q3 + 2 * q4 + 2 * q5)) * ...
        (-0.499999889581881352e-13) + Dq1 * Dq2 * cos((-q5 + q4 + q3)) * ...
        0.433680868994201774e-18 + Dq1 * Dq2 * sin((-2 * q5 + 2 * q4 + 2 * q3 + 2 * q2)) ...
        * 0.264424150710000009e-3 + Dq1 * Dq2 * cos((q4 + q3)) * ...
        0.173472347597680709e-17 + Dq1 * Dq2 * cos((q4 + q3 + 2 * q2)) * ...
        (-0.155561559999999998e-1) + Dq1 * Dq3 * sin((2 * q3 + 2 * q4)) * ...
        (-0.499998805379708866e-13) + Dq1 * Dq3 * sin((2 * q2 - 2 * q5)) * ...
        0.499999889581881352e-13 + Dq1 * Dq3 * sin((2 * q3 + 2 * q4 - 2 * q5)) * ...
        (-0.499999889581881352e-13) + Dq1 * Dq3 * sin((2 * q2 + 2 * q4 + 2 * q5)) * ...
        0.135525271560688054e-19 + Dq1 * Dq3 * sin((2 * q4 + 2 * q5)) * ...
        (-0.135525271560688054e-19) + Dq1 * Dq3 * sin((2 * q4 - 2 * q5))...
        * (-0.135525271560688054e-19) + Dq1 * Dq3 * sin((2 * q2 + 2 * q4 - 2 * q5)) * ...
        0.135525271560688054e-19 + Dq1 * Dq3 * sin((2 * q2 + 2 * q3 - 2 * q5)) * ...
        (-0.135525271560688054e-19) + Dq1 * Dq3 * sin((2 * q3 - 2 * q5)) * ...
        0.135525271560688054e-19 + Dq1 * Dq3 * sin((2 * q3 + 2 * q5)) * ...
        0.135525271560688054e-19 + Dq1 * Dq3 * sin((2 * q2 + 2 * q3 + 2 * q5)) * ...
        (-0.135525271560688054e-19) + Dq1 * Dq3 * sin((2 * q2 + 2 * q4)) * ...
        (-0.542101086242752217e-19) + Dq1 * Dq3 * sin((2 * q4)) * ...
        0.542101086242752217e-19 + Dq1 * Dq3 * sin((2 * q2)) * 0.500016694715554877e-13 ...
        + Dq1 * Dq3 * sin((2 * q3 + 2 * q2)) * (-0.451599735520000004e-1) + Dq1 * Dq3 * ...
        sin((2 * q4 + 2 * q3 + 2 * q2)) * 0.925912332999998108e-5 + Dq1 * Dq3 * cos((q4 ...
        + q3 + 2 * q2)) * (-0.777807799999999903e-2) + Dq1 * Dq3 * cos((-q5 + q4 + q3 + ...
        2 * q2)) * (-0.284376000000000030e-2) + Dq1 * Dq3 * sin((-2 * q5 + 2 * q4 + 2 * ...
        q3 + 2 * q2)) * 0.264424150709999955e-3 + Dq1 * Dq3 * sin((2 * q5 + 2 * q4 + 2 * ...
        q3 + 2 * q2)) * 0.264424150659999966e-3 + Dq1 * Dq3 * cos((q5 + q4 + q3 + 2 * ...
        q2)) * 0.284376000000000030e-2 + Dq1 * Dq4 * cos((-q5 + q4 + q3 + 2 * q2)) * ...
        (-0.284376000000000030e-2) - 0.6087959740e-4 * Dq4 * Dq6 * sin((q5 + q4 + q3 + ...
        q2)) - 0.6087959740e-4 * Dq6 * Dq5 * sin((-q5 + q4 + q3 + q2)) - 0.6087959740e-4 ...
        * Dq6 * Dq5 * sin((q5 + q4 + q3 + q2)) + Dq1 * Dq4 * sin((-2 * q5 + 2 * q4 + 2 * ...
        q3 + 2 * q2)) * 0.264424150784999966e-3 + Dq1 * Dq4 * sin((2 * q3 + 2 * q4 - 2 * ...
        q5)) * (-0.124999999500524650e-12) + Dq1 * Dq4 * sin((2 * q5 + 2 * q4 + 2 * q3 + ...
        2 * q2)) * 0.264424150709999955e-3 + Dq1 * Dq4 * sin((2 * q2 + 2 * q3 - 2 * q5)) ...
        * (-0.135525271560688054e-19) + Dq1 * Dq4 * sin((2 * q3 - 2 * q5)) * ...
        0.135525271560688054e-19 + Dq1 * Dq4 * sin((2 * q4 + 2 * q3 + 2 * q2)) * ...
        0.925912357999992587e-5 + Dq1 * Dq4 * sin((2 * q3 + 2 * q4)) * ...
        (-0.199999955832752541e-12) + Dq1 * Dq4 * sin((2 * q2)) * ...
        0.199999955832752541e-12 + Dq1 * Dq4 * cos((q5 + q4 + q3 + 2 * q2)) * ...
        0.284376000000000030e-2 + Dq1 * Dq4 * cos((q4 + q3 + 2 * q2)) ...
        * (-0.777807799999999903e-2) + Dq1 * Dq4 * sin((2 * q3 + 2 * q4 + 2 * q5)) * ...
        0.499999889581881352e-13 + Dq1 * Dq4 * sin((2 * q2 + 2 * q5)) * ...
        (-0.499999889581881352e-13) + Dq1 * Dq4 * sin((2 * q2 - 2 * q5)) * ...
        0.124999999500524650e-12 + Dq1 * Dq4 * sin((2 * q2 + 2 * q4 - 2 * q5)) * ...
        0.135525271560688054e-19 + Dq1 * Dq4 * sin((2 * q4 - 2 * q5)) * ...
        (-0.135525271560688054e-19) + Dq1 * Dq5 * sin((2 * q5 + 2 * q4 + 2 * q3 + 2 * ...
        q2)) * 0.264424150660000021e-3 + Dq1 * Dq5 * sin((-2 * q5 + 2 * q4 + 2 * q3 + 2 ...
        * q2)) * (-0.264424150660000021e-3) + Dq1 * Dq5 * cos((-q5 + q4 + q3 + 2 * q2)) ...
        * 0.284376000000000030e-2 + Dq1 * Dq5 * cos((q5 + q4 + q3 + 2 * q2)) * ...
        0.284376000000000030e-2 + Dq1 * Dq5 * sin(q5) * (-0.291736320000000014e-2) + Dq1 ...
        * Dq3 * cos((q4 + q3)) * (-0.777807799999999903e-2) + Dq1 * Dq3 * cos((q5 + q4 + ...
        q3)) * 0.284376000000000030e-2 + Dq1 * Dq3 * cos((-q5 + q4 + q3)) * ...
        (-0.284376000000000030e-2) + Dq1 * Dq4 * cos((q4 + q3)) * ...
        (-0.777807799999999903e-2) + Dq1 * Dq4 * cos((q5 + q4 + q3)) * ...
        0.284376000000000030e-2 + Dq1 * Dq4 * cos((-q5 + q4 + q3)) * ...
        (-0.284376000000000030e-2) + Dq1 * Dq5 * cos((q5 + q4 + q3)) * ...
        0.284376000000000030e-2 + Dq1 * Dq5 * cos((-q5 + q4 + q3)) * ...
        0.284376000000000030e-2 + Dq1 * sin((2 * q5)) * Dq2 * ...
        (-0.298155597433513719e-18) + Dq1 * Dq5 * sin((2 * q5)) * ...
        (-0.528848301320000041e-3) - 0.5000000000e-14 * Dq1 * Dq6 * sin((2 * q6)) + Dq1 ...
        * Dq3 * sin((2 * q5)) * 0.499999889581881352e-13 + Dq1 * Dq4 * sin((2 * q5)) * ...
        0.750000105423365149e-13 + 0.2500000000e-14 * Dq1 * Dq6 * sin((-2 * q6 + q5)) + ...
        Dq2 * Dq3 * sin((2 * q5 + q4 + q3 + q2)) * 0.528848301319999933e-3 + Dq2 * Dq3 * ...
        sin((q2 - q3 + q4 + 2 * q5)) * 0.271050543121376109e-19 + Dq2 * Dq3 * sin((q2 + ...
        q3 - q4 + 2 * q5)) * (-0.271050543121376109e-19) + Dq2 * Dq3 * sin((q4 + q3 + ...
        q2))...
        * (-0.404460056000000012e-2) + Dq2 * Dq3 * sin((-q5 + q4 + q3 + q2)) * ...
        (-0.145868160000000007e-2) + Dq2 * Dq3 * sin((q5 + q4 + q3 + q2)) * ...
        0.145868160000000007e-2 + Dq2 * Dq3 * sin((q2 - q3 + q4 - 2 * q5)) * ...
        (-0.271050543121376109e-19) + Dq2 * Dq3 * sin((q2 + q3 - q4 - 2 * q5)) * ...
        0.271050543121376109e-19 + Dq2 * Dq3 * sin((-2 * q5 + q4 + q3 + q2)) * ...
        (-0.528848301319999933e-3) + Dq2 * Dq4 * sin((q5 + q4 + q3 + q2)) * ...
        0.145868160000000007e-2 + Dq2 * Dq4 * sin((-q5 + q4 + q3 + q2)) * ...
        (-0.145868160000000007e-2) + Dq2 * Dq4 * sin((-2 * q5 + q4 + q3 + q2)) * ...
        (-0.528848301320000041e-3) + Dq2 * Dq4 * sin((2 * q5 + q4 + q3 + q2)) * ...
        0.528848301320000041e-3 + Dq2 * Dq4 * sin((q4 + q3 + q2)) * ...
        (-0.404460056000000012e-2) + Dq2 * Dq5 * sin((-2 * q5 + q4 + q3 + q2)) * ...
        0.528848301245000030e-3 + Dq2 * Dq5 * sin((q5 + q4 + q3 + q2)) * ...
        0.145868160000000007e-2 + Dq2 * Dq5 * sin((-q5 + q4 + q3 + q2)) * ...
        0.145868160000000007e-2 + Dq2 * Dq5 * sin((2 * q5 + q4 + q3 + q2)) * ...
        0.528848301245000030e-3 + Dq2 * Dq5 * sin((q4 + q3 + q2)) * ...
        0.201419267009000013e-2 - 0.5000000000e-14 * Dq2 * Dq6 * sin((-2 * q5 + q4 + q3 ...
        + q2)) - 0.6087959740e-4 * Dq2 * Dq6 * sin((q5 + q4 + q3 + q2)) + ...
        0.6087959740e-4 * Dq2 * Dq6 * sin((-q5 + q4 + q3 + q2)) - 0.5000000000e-14 * Dq2 ...
        * Dq6 * sin((2 * q5 + q4 + q3 + q2)) - 0.1000000000e-13 * Dq2 * Dq6 * sin((q4 + ...
        q3 + q2)) + 0.2500000000e-14 * Dq3 * Dq6 * sin((-2 * q5 + q4 + q3 + q2)) + ...
        0.2500000000e-14 * Dq3 * Dq6 * sin((2 * q5 + q4 + q3 + q2)) + Dq3 * Dq4 * ...
        sin((q2 + q3 - q4 - 2 * q5)) * (-0.271050543121376109e-19) + Dq3 * Dq4 * sin((q2 ...
        - q3 + q4 + 2 * q5)) * (-0.271050543121376109e-19) + Dq3 * Dq4 * sin((q2 - 2 * ...
        q5 - q4 - q3)) * (-0.542101086242752217e-19) + Dq3 * Dq4 * sin((q2 + q3 - q4 + 2 ...
        * q5)) ...
        * 0.271050543121376109e-19 + Dq3 * Dq4 * sin((q2 - q3 + q4 - 2 * q5)) * ...
        0.271050543121376109e-19 + Dq3 * Dq4 * sin((q2 + 2 * q5 - q4 - q3)) * ...
        0.542101086242752217e-19 + Dq3 * Dq5 * sin((q2 + 2 * q5 - q4 - q3)) * ...
        0.625000268553166372e-13 + Dq3 * Dq5 * sin((q2 - 2 * q5 - q4 - q3)) * ...
        0.625000268553166372e-13 + Dq3 * Dq5 * sin((-q3 - q4 + q2)) * ...
        0.125000053710633274e-12 + 0.2500000000e-14 * Dq3 * Dq6 * sin((2 * q6 + q4 + q3 ...
        + q2 - 2 * q5)) + 0.2500000000e-14 * Dq3 * Dq6 * sin((2 * q6 + q4 + q3 + q2)) + ...
        Dq3 * Dq5 * sin((q4 + q3 + q2)) * 0.201419267021500040e-2 + Dq3 * Dq5 * sin((2 * ...
        q5 + q4 + q3 + q2)) * 0.528848301307500057e-3 + Dq3 * Dq5 * sin((-2 * q5 + q4 + ...
        q3 + q2)) * 0.528848301307500057e-3 - 0.5000000000e-14 * Dq3 * Dq6 * sin((-2 * ...
        q6 + q4 + q3 + q2 + q5)) + Dq3 * Dq4 * sin((2 * q5 + q4 + q3 + q2)) * ...
        0.528848301319999933e-3 + Dq3 * Dq4 * sin((-2 * q5 + q4 + q3 + q2)) * ...
        (-0.528848301319999933e-3) + Dq3 * Dq4 * sin((q4 + q3 + q2)) * ...
        (-0.404460056000000012e-2) + 0.6087959740e-4 * Dq3 * Dq6 * sin((-q5 + q4 + q3 + ...
        q2)) - 0.6087959740e-4 * Dq3 * Dq6 * sin((q5 + q4 + q3 + q2)) + 0.5000000000e-14 ...
        * Dq3 * Dq6 * sin((q4 + q3 + q2)) + 0.2500000000e-14 * Dq3 * Dq6 * sin((-2 * q6 ...
        + q4 + q3 + q2)) + Dq3 * Dq4 * sin((q5 + q4 + q3 + q2)) * ...
        0.145868160000000007e-2 + Dq3 * Dq4 * sin((-q5 + q4 + q3 + q2)) * ...
        (-0.145868160000000007e-2) + Dq3 * Dq5 * sin((-q5 + q4 + q3 + q2)) * ...
        0.145868160000000007e-2 + Dq3 * Dq5 * sin((q5 + q4 + q3 + q2)) * ...
        0.145868160000000007e-2 + Dq4 * Dq5 * sin((-q5 + q4 + q3 + q2)) * ...
        0.145868160000000007e-2 + Dq4 * Dq5 * sin((q2 - 2 * q5 - q4 - q3)) * ...
        0.750000105423365149e-13 + Dq4 * Dq5 * sin((q4 + q3 + q2)) * ...
        0.201419266993999990e-2 + Dq4 * Dq5 * sin((2 * q5 + q4 + q3 + q2)) * ...
        0.528848301320000041e-3 + Dq4 * Dq5 * sin((q2 + 2 * q5 - q4 - q3))...
        * 0.750000105423365149e-13 + Dq4 * Dq5 * sin((q5 + q4 + q3 + q2)) * ...
        0.145868160000000007e-2 + Dq4 * Dq5 * sin((-q3 - q4 + q2)) * ...
        (-0.150000021084673030e-12) + Dq4 * Dq5 * sin((-2 * q5 + q4 + q3 + q2)) * ...
        0.528848301320000041e-3 - 0.2500000000e-14 * Dq4 * Dq6 * sin((-2 * q6 + q4 + q3 ...
        + q2 + 2 * q5)) - 0.2500000000e-14 * Dq4 * Dq6 * sin((2 * q6 + q4 + q3 + q2)) - ...
        0.2500000000e-14 * Dq4 * Dq6 * sin((-2 * q6 + q4 + q3 + q2)) - 0.2500000000e-14 ...
        * Dq4 * Dq6 * sin((2 * q6 + q4 + q3 + q2 - 2 * q5)) + 0.5000000000e-14 * Dq4 * ...
        Dq6 * sin((q4 + q3 + q2)) + 0.5000000000e-14 * Dq4 * Dq6 * sin((-2 * q6 + q4 + ...
        q3 + q2 + q5)) + 0.2500000000e-14 * Dq4 * Dq6 * sin((-2 * q5 + q4 + q3 + q2)) - ...
        0.5000000000e-14 * Dq4 * Dq6 * sin((2 * q6 + q4 + q3 + q2 - q5)) + ...
        0.2500000000e-14 * Dq4 * Dq6 * sin((2 * q5 + q4 + q3 + q2)) + 0.6087959740e-4 * ...
        Dq4 * Dq6 * sin((-q5 + q4 + q3 + q2)) + Dq4 ^ 2 * sin((q2 + 2 * q5 - q4 - q3)) * ...
        0.271050543121376109e-19 + Dq4 ^ 2 * sin((q2 + q3 - q4 - 2 * q5)) * ...
        (-0.135525271560688054e-19) + Dq4 ^ 2 * sin((q2 - q3 + q4 + 2 * q5)) * ...
        (-0.135525271560688054e-19) + Dq4 ^ 2 * sin((2 * q5 + q4 + q3 + q2)) * ...
        0.264424150659999966e-3 + Dq4 ^ 2 * sin((q2 - 2 * q5 - q4 - q3)) * ...
        (-0.271050543121376109e-19) + Dq4 ^ 2 * sin((q2 + q3 - q4 + 2 * q5)) * ...
        0.135525271560688054e-19 + Dq4 ^ 2 * sin((q2 - q3 + q4 - 2 * q5)) * ...
        0.135525271560688054e-19 + Dq4 ^ 2 * sin((-2 * q5 + q4 + q3 + q2)) * ...
        (-0.264424150659999966e-3) + Dq4 ^ 2 * sin((q4 + q3 + q2)) * ...
        (-0.202230028000000006e-2) + Dq4 ^ 2 * sin((q5 + q4 + q3 + q2)) * ...
        0.729340800000000036e-3 + Dq4 ^ 2 * sin((-q5 + q4 + q3 + q2)) * ...
        (-0.729340800000000036e-3) + Dq5 ^ 2 * sin((-q5 + q4 + q3 + q2)) * ...
        (-0.729340800000000036e-3) + Dq5 ^ 2 * cos((q5 + q2)) * ...
        (-0.284376000000000030e-2) + Dq5 ^ 2 * sin((q5 + q4 + q3 + q2)) ...
        * 0.729340800000000036e-3 + Dq5 ^ 2 * cos((-q5 + q2)) * (-0.284376000000000030e-2) ...
        + Dq3 ^ 2 * sin((q2 - q3 + q4 + 2 * q5)) * 0.135525271560688054e-19 + Dq3 ^ 2 * ...
        sin((-2 * q5 + q4 + q3 + q2)) * (-0.264424150659999966e-3) + Dq3 ^ 2 * sin((2 * ...
        q5 + q4 + q3 + q2)) * 0.264424150659999966e-3 + Dq3 ^ 2 * sin((q4 + q3 + q2)) * ...
        (-0.202230028000000006e-2) + Dq3 ^ 2 * sin((q2 + q3 - q4 - 2 * q5)) * ...
        0.135525271560688054e-19 + Dq3 ^ 2 * sin((q5 + q4 + q3 + q2)) * ...
        0.729340800000000036e-3 + Dq3 ^ 2 * sin((-q5 + q4 + q3 + q2)) * ...
        (-0.729340800000000036e-3) + Dq3 ^ 2 * sin((q2 + q3 - q4 + 2 * q5)) * ...
        (-0.135525271560688054e-19) + Dq3 ^ 2 * sin((q2 - q3 + q4 - 2 * q5)) * ...
        (-0.135525271560688054e-19) + Dq2 ^ 2 * sin((q2 + 2 * q5 - q4 - q3)) * ...
        0.271050543121376109e-19 + Dq2 ^ 2 * sin((-2 * q5 + q4 + q3 + q2)) * ...
        (-0.264424150659999966e-3) + Dq2 ^ 2 * sin((q4 + q3 + q2)) * ...
        (-0.202230028000000006e-2) + Dq2 ^ 2 * sin((q2 - 2 * q5 - q4 - q3)) * ...
        0.325260651745651330e-18 + Dq2 ^ 2 * cos((-q5 + q2)) * 0.284376000000000030e-2 + ...
        Dq2 ^ 2 * cos((q5 + q2)) * 0.284376000000000030e-2 + Dq2 ^ 2 * sin((2 * q5 + q4 ...
        + q3 + q2)) * 0.264424150659999641e-3 + Dq2 ^ 2 * sin((q2 + q3 - q4 - 2 * q5)) * ...
        (-0.135525271560688054e-19) + Dq2 ^ 2 * sin((q2 - q3 + q4 + 2 * q5)) * ...
        (-0.135525271560688054e-19) + Dq2 ^ 2 * sin((q2 + q3 - q4 + 2 * q5)) * ...
        0.135525271560688054e-19 + Dq2 ^ 2 * sin((q2 - q3 + q4 - 2 * q5)) * ...
        0.135525271560688054e-19 + Dq2 ^ 2 * cos(q2) * 0.267177490999999989e0 + Dq2 ^ 2 ...
        * sin((q5 + q4 + q3 + q2)) * 0.729340800000000036e-3 + Dq2 ^ 2 * sin((-q5 + q4 + ...
        q3 + q2)) * (-0.729340800000000036e-3) + Dq1 ^ 2 * sin((q2 + q3 - q4 + 2 * q5)) ...
        * (-0.338813178901720136e-19) + Dq1 ^ 2 * sin((q2 - q3 + q4 - 2 * q5)) * ...
        (-0.338813178901720136e-19) + Dq1 ^ 2 * sin((q2 - 2 * q5 - q4 - q3)) * ...
        0.243945488809238498e-18 + Dq1 ^ 2 * sin((q2 - q3 + q4 + 2 * q5)) * ...
        0.338813178901720136e-19 + Dq1 ^ 2 * sin((q2 + q3 - q4 - 2 * q5)) * ...
        0.338813178901720136e-19 + Dq1 ^ 2 * cos((2 * q3 + 2 * q4 - q5 + q2)) ...
        * 0.542101086242752217e-19 + Dq1 ^ 2 * sin((q2 + 2 * q5 - q4 - q3)) * ...
        (-0.271050543121376109e-19) + Dq1 ^ 2 * cos(q2) * 0.277555756156289135e-16 + Dq1 ...
        ^ 2 * sin((3 * q2 - 2 * q5 + q4 + q3)) * 0.948676900924816380e-19 + Dq1 ^ 2 * ...
        sin((3 * q2 + 2 * q5 + q4 + q3)) * 0.271050543121376109e-19 + Dq1 ^ 2 * sin((3 * ...
        q2 + 3 * q3 + 3 * q4 - q5)) * 0.271050543121376109e-19 + Dq1 ^ 2 * cos((3 * q2 + ...
        q5 + 2 * q4 + 2 * q3)) * 0.542101086242752217e-19 + Dq1 ^ 2 * cos((3 * q2 - q5 + ...
        2 * q4 + 2 * q3)) * 0.542101086242752217e-19 + Dq1 ^ 2 * cos((2 * q3 + 2 * q4 + ...
        q5 + q2)) * 0.542101086242752217e-19 + Dq1 ^ 2 * sin((3 * q2 + 3 * q3 + 3 * q4 + ...
        q5)) * (-0.271050543121376109e-19) + Dq1 ^ 2 * sin((3 * q2 + q3 + 3 * q4 + 2 * ...
        q5)) * (-0.338813178901720136e-20) + Dq1 ^ 2 * sin((q2 + q3 + 3 * q4 + 2 * q5)) ...
        * 0.338813178901720136e-20 + Dq1 ^ 2 * sin((3 * q2 + 3 * q3 + 3 * q4 + 2 * q5)) ...
        * 0.101643953670516041e-19 + Dq1 ^ 2 * sin((q2 + 3 * q3 + 3 * q4 + 2 * q5)) * ...
        0.338813178901720136e-20 + Dq1 ^ 2 * sin((3 * q2 + 3 * q3 + q4 + 2 * q5)) * ...
        0.677626357803440271e-20 + Dq1 ^ 2 * sin((q2 + 3 * q3 + q4 + 2 * q5)) * ...
        (-0.677626357803440271e-20) + Dq1 ^ 2 * sin((-2 * q5 + q4 + q3 + q2)) * ...
        0.149077798716756860e-18 + Dq1 ^ 2 * sin((2 * q5 + q4 + q3 + q2)) * ...
        (-0.216840434497100887e-18) + Dq1 ^ 2 * cos((-q5 + q2)) * ...
        0.216840434497100887e-18 + Dq1 ^ 2 * cos((q5 + q2)) * 0.216840434497100887e-18;

        cdq2 = Dq1 ^ 2 * sin((2 * q4 + 2 * q3 + 2 * q2)) * (-0.462956153999997749e-5) + Dq1 ...
        ^ 2 * cos((-q5 + q4 + q3 + 2 * q2)) * 0.284376000000000030e-2 + Dq1 ^ 2 * ...
        cos((q5 + q4 + q3 + 2 * q2)) * (-0.284376000000000030e-2) + Dq1 ^ 2 * cos((-q5 + ...
        q4 + q3)) * 0.216840434497100887e-18 + Dq1 ^ 2 * cos((q5 + q4 + q3)) * ...
        (-0.216840434497100887e-18) + Dq1 ^ 2 * cos((q4 + q3 + 2 * q2)) * ...
        0.777807799999999990e-2 + Dq1 ^ 2 * cos((q4 + q3)) * 0.867361737988403547e-18 + ...
        Dq2 ^ 2 * cos((q4 + q3)) * 0.173472347597680709e-17 + 0.2e-12 * Dq1 * Dq2 * ...
        sin((q4 + q3 + q2)) - 0.2e-12 * Dq1 * Dq3 * sin((q4 + q3 + q2)) + 0.1e-12 * Dq1 ...
        * sin((q4 + q3 + q2)) * Dq4 + Dq1 ^ 2 * sin((2 * q2)) * 0.413642134999999911e0 + ...
        Dq5 ^ 2 * cos((-q5 + q4 + q3)) * (-0.284376000000000030e-2) + Dq5 ^ 2 * cos((q5 ...
        + q4 + q3)) * 0.284376000000000030e-2 + Dq3 ^ 2 * cos((q4 + q3)) * ...
        (-0.777807799999999903e-2) + Dq3 ^ 2 * cos((q5 + q4 + q3)) * ...
        0.284376000000000030e-2 + Dq3 ^ 2 * cos((-q5 + q4 + q3)) * ...
        (-0.284376000000000030e-2) + Dq4 ^ 2 * cos((q4 + q3)) * ...
        (-0.777807799999999903e-2) + Dq4 ^ 2 * cos((q5 + q4 + q3)) * ...
        0.284376000000000030e-2 + Dq4 ^ 2 * cos((-q5 + q4 + q3)) * ...
        (-0.284376000000000030e-2) + Dq1 * Dq5 * cos((q5 + q2)) * ...
        0.568752000000000060e-2 + Dq1 * Dq5 * cos((-q5 + q2)) * ...
        (-0.568752000000000060e-2) + Dq2 * Dq3 * cos((q4 + q3)) * ...
        (-0.155561559999999981e-1) + Dq2 * Dq3 * cos((q5 + q4 + q3)) * ...
        0.568752000000000060e-2 + Dq2 * Dq3 * cos((-q5 + q4 + q3)) * ...
        (-0.568752000000000060e-2) + Dq2 * Dq4 * cos((q4 + q3)) * ...
        (-0.155561559999999981e-1) + Dq2 * Dq4 * cos((q5 + q4 + q3)) * ...
        0.568752000000000060e-2 ...
        + Dq2 * Dq4 * cos((-q5 + q4 + q3)) * (-0.568752000000000060e-2) + Dq2 * Dq5 * ...
        cos((q5 + q4 + q3)) * 0.568752000000000060e-2 + Dq2 * Dq5 * cos((-q5 + q4 + q3)) ...
        * 0.568752000000000060e-2 + Dq3 * Dq4 * cos((q4 + q3)) * ...
        (-0.155561559999999981e-1) + Dq3 * Dq4 * cos((q5 + q4 + q3)) * ...
        0.568752000000000060e-2 + Dq3 * Dq4 * cos((-q5 + q4 + q3)) * ...
        (-0.568752000000000060e-2) + Dq3 * Dq5 * cos((q5 + q4 + q3)) * ...
        0.568752000000000060e-2 + Dq3 * Dq5 * cos((-q5 + q4 + q3)) * ...
        0.568752000000000060e-2 + Dq4 * Dq5 * cos((q5 + q4 + q3)) * ...
        0.568752000000000060e-2 + Dq4 * Dq5 * cos((-q5 + q4 + q3)) * ...
        0.568752000000000060e-2 + Dq1 ^ 2 * sin((2 * q3 + 2 * q2)) * ...
        0.225799867799999984e-1 - 0.1217591948e-3 * sin(q5) * Dq6 * Dq5 + Dq1 * Dq5 * ...
        sin((q4 + q3 + q2)) * (-0.201419266984000003e-2) + Dq1 * Dq5 * sin((2 * q5 + q4 ...
        + q3 + q2)) * 0.528848301320000041e-3 + Dq1 * Dq5 * sin((-2 * q5 + q4 + q3 + ...
        q2)) * 0.528848301320000041e-3 + 0.5000000000e-14 * Dq1 * Dq6 * sin((-2 * q6 + ...
        q4 + q3 + q2 - q5)) - 0.5000000000e-14 * Dq1 * Dq6 * sin((-2 * q6 + q4 + q3 + q2 ...
        + q5)) - 0.1000000000e-13 * Dq2 * Dq6 * sin((2 * q5)) + Dq2 * Dq5 * sin((2 * ...
        q5)) * 0.105769660249000006e-2 + Dq3 * Dq5 * sin((2 * q5)) * ...
        0.105769660274000017e-2 + 0.5000000000e-14 * Dq3 * Dq6 * sin((-2 * q6 + 2 * q5)) ...
        + 0.5000000000e-14 * Dq3 * Dq6 * sin((2 * q6)) + 0.5000000000e-14 * Dq3 * Dq6 * ...
        sin((2 * q5)) + Dq4 * Dq5 * sin((2 * q5)) * 0.105769660279000010e-2 - ...
        0.5000000000e-14 * Dq4 * Dq6 * sin((-2 * q6 + 2 * q5)) - 0.5000000000e-14 * Dq4 ...
        * Dq6 * sin((2 * q6)) + 0.5000000000e-14 * Dq4 * Dq6 * sin((2 * q5)) + 0.2e-12 * ...
        Dq1 * Dq2 * sin((2 * q5 + q4 + q3 + q2)) - 0.2e-12 * Dq1 * Dq3 * sin((-2 * q5 + ...
        q4 + q3 + q2)) - 0.5e-12 * Dq1 * Dq4 * sin((-2 * q5 + q4 + q3 + q2)) - ...
        0.6087959740e-4 * Dq1 * Dq6 * sin((-q5 + q4 + q3 + q2)) + 0.6087959740e-4 * Dq1 ...
        * Dq6 * sin((q5 + q4 + q3 + q2)) + Dq1 ^ 2 * sin((-2 * q5 + 2 * q4 + 2 * q3 + 2 ...
        * q2)) * (-0.132212075330000010e-3) + Dq1 ^ 2 * sin((2 * q5 + 2 * q4 + 2 * q3 + ...
        2 * q2)) * (-0.132212075330000010e-3);

        cdq3 = Dq1 ^ 2 * sin((2 * q4 + 2 * q3 + 2 * q2)) * (-0.462956153999999104e-5) + Dq1 ...
        ^ 2 * cos((-q5 + q4 + q3 + 2 * q2)) * 0.142188000000000015e-2 + Dq1 ^ 2 * ...
        cos((q5 + q4 + q3 + 2 * q2)) * (-0.142188000000000015e-2) + Dq1 ^ 2 * cos((-q5 + ...
        q4 + q3)) * 0.142188000000000015e-2 + Dq1 ^ 2 * cos((q5 + q4 + q3)) * ...
        (-0.142188000000000015e-2) + Dq2 ^ 2 * cos((-q5 + q4 + q3)) * ...
        0.284376000000000030e-2 + Dq2 ^ 2 * cos((q5 + q4 + q3)) * ...
        (-0.284376000000000030e-2) + Dq1 ^ 2 * cos((q4 + q3 + 2 * q2)) * ...
        0.388903900000000038e-2 + Dq1 ^ 2 * cos((q4 + q3)) * 0.388903900000000038e-2 + ...
        Dq2 ^ 2 * cos((q4 + q3)) * 0.777807800000000077e-2 - 0.3e-12 * Dq1 * sin((q4 + ...
        q3 + q2)) * Dq4 + 0.2257998678e-1 * Dq1 ^ 2 * sin((2 * q3 + 2 * q2)) - ...
        0.1217591948e-3 * sin(q5) * Dq6 * Dq5 + Dq1 * Dq5 * sin((q4 + q3 + q2)) * ...
        (-0.201419266984000046e-2) + Dq1 * Dq5 * sin((2 * q5 + q4 + q3 + q2)) * ...
        0.528848301320000041e-3 + Dq1 * Dq5 * sin((-2 * q5 + q4 + q3 + q2)) * ...
        0.528848301320000149e-3 + 0.5000000000e-14 * Dq1 * Dq6 * sin((-2 * q6 + q4 + q3 ...
        + q2 - q5)) - 0.5000000000e-14 * Dq1 * Dq6 * sin((-2 * q6 + q4 + q3 + q2 + q5)) ...
        - 0.1000000000e-13 * Dq2 * Dq6 * sin((2 * q5)) + Dq2 * Dq5 * sin((2 * q5)) * ...
        0.105769660249000006e-2 + Dq3 * Dq5 * sin((2 * q5)) * 0.105769660249000006e-2 + ...
        0.5000000000e-14 * Dq3 * Dq6 * sin((-2 * q6 + 2 * q5)) + 0.5000000000e-14 * Dq3 ...
        * Dq6 * sin((2 * q6)) + 0.5000000000e-14 * Dq3 * Dq6 * sin((2 * q5)) + Dq4 * Dq5 ...
        * sin((2 * q5)) * 0.105769660274000017e-2 - 0.5000000000e-14 * Dq4 * Dq6 * ...
        sin((-2 * q6 + 2 * q5)) - 0.5000000000e-14 * Dq4 * Dq6 * sin((2 * q6)) + ...
        0.5000000000e-14 * Dq4 * Dq6 * sin((2 * q5)) - 0.5e-12 * Dq1 * Dq2 * sin((-2 * ...
        q5 + q4 + q3 + q2)) + 0.1e-12 * Dq1 * Dq2 * sin((2 * q5 + q4 + q3 + q2)) + ...
        0.1e-12 * Dq1 * Dq4 * sin((2 * q5 + q4 + q3 + q2)) - 0.2e-12 * Dq1 * Dq4 * ...
        sin((-2 * q5 + q4 + q3 + q2)) - 0.6087959740e-4 * Dq1 * Dq6 * sin((-q5 + q4 + q3 ...
        + q2)) + 0.6087959740e-4 * Dq1 * Dq6 * sin((q5 + q4 + q3 + q2)) + Dq1 ^ 2 * ...
        sin((-2 * q5 + 2 * q4 + 2 * q3 + 2 * q2)) * (-0.132212075330000010e-3) + Dq1 ^ 2 ...
        * sin((2 * q5 + 2 * q4 + 2 * q3 + 2 * q2)) * (-0.132212075330000010e-3);

        cdq4 = Dq1 ^ 2 * sin((2 * q4 + 2 * q3 + 2 * q2)) * (-0.462956153999999104e-5) + Dq1 ...
        ^ 2 * cos((-q5 + q4 + q3 + 2 * q2)) * 0.142188000000000015e-2 + Dq1 ^ 2 * ...
        cos((q5 + q4 + q3 + 2 * q2)) * (-0.142188000000000015e-2) + Dq1 ^ 2 * cos((-q5 + ...
        q4 + q3)) * 0.142188000000000015e-2 + Dq1 ^ 2 * cos((q5 + q4 + q3)) * ...
        (-0.142188000000000015e-2) + Dq2 ^ 2 * cos((-q5 + q4 + q3)) * ...
        0.284376000000000030e-2 + Dq2 ^ 2 * cos((q5 + q4 + q3)) * ...
        (-0.284376000000000030e-2) + Dq1 ^ 2 * cos((q4 + q3 + 2 * q2)) * ...
        0.388903900000000038e-2 + Dq1 ^ 2 * cos((q4 + q3)) * 0.388903900000000038e-2 + ...
        Dq2 ^ 2 * cos((q4 + q3)) * 0.777807800000000077e-2 - 0.3e-12 * Dq1 * sin((q4 + ...
        q3 + q2)) * Dq4 - 0.1217591948e-3 * sin(q5) * Dq6 * Dq5 + Dq1 * Dq5 * sin((q4 + ...
        q3 + q2)) * (-0.201419266984000046e-2) + Dq1 * Dq5 * sin((2 * q5 + q4 + q3 + ...
        q2)) * 0.528848301320000041e-3 + Dq1 * Dq5 * sin((-2 * q5 + q4 + q3 + q2)) * ...
        0.528848301320000149e-3 + 0.5000000000e-14 * Dq1 * Dq6 * sin((-2 * q6 + q4 + q3 ...
        + q2 - q5)) - 0.5000000000e-14 * Dq1 * Dq6 * sin((-2 * q6 + q4 + q3 + q2 + q5)) ...
        - 0.1000000000e-13 * Dq2 * Dq6 * sin((2 * q5)) + Dq2 * Dq5 * sin((2 * q5)) * ...
        0.105769660249000006e-2 + Dq3 * Dq5 * sin((2 * q5)) * 0.105769660249000006e-2 + ...
        0.5000000000e-14 * Dq3 * Dq6 * sin((-2 * q6 + 2 * q5)) + 0.5000000000e-14 * Dq3 ...
        * Dq6 * sin((2 * q6)) + 0.5000000000e-14 * Dq3 * Dq6 * sin((2 * q5)) + Dq4 * Dq5 ...
        * sin((2 * q5)) * 0.105769660274000017e-2 - 0.5000000000e-14 * Dq4 * Dq6 * ...
        sin((-2 * q6 + 2 * q5)) - 0.5000000000e-14 * Dq4 * Dq6 * sin((2 * q6)) + ...
        0.5000000000e-14 * Dq4 * Dq6 * sin((2 * q5)) - 0.5e-12 * Dq1 * Dq2 * sin((-2 * ...
        q5 + q4 + q3 + q2)) + 0.1e-12 * Dq1 * Dq2 * sin((2 * q5 + q4 + q3 + q2)) + ...
        0.1e-12 * Dq1 * Dq4 * sin((2 * q5 + q4 + q3 + q2)) - 0.2e-12 * Dq1 * Dq4 * ...
        sin((-2 * q5 + q4 + q3 + q2)) - 0.6087959740e-4 * Dq1 * Dq6 * sin((-q5 + q4 + q3 ...
        + q2)) + 0.6087959740e-4 * Dq1 * Dq6 * sin((q5 + q4 + q3 + q2)) + Dq1 ^ 2 * ...
        sin((-2 * q5 + 2 * q4 + 2 * q3 + 2 * q2)) * (-0.132212075330000010e-3) + Dq1 ^ 2 ...
        * sin((2 * q5 + 2 * q4 + 2 * q3 + 2 * q2)) * (-0.132212075330000010e-3);

        cdq5 = Dq1 ^ 2 * cos((-q5 + q4 + q3 + 2 * q2)) * (-0.142188000000000015e-2) + Dq1 ^ ...
        2 * cos((q5 + q4 + q3 + 2 * q2)) * (-0.142188000000000015e-2) + Dq1 ^ 2 * ...
        cos((-q5 + q4 + q3)) * (-0.142188000000000015e-2) + Dq1 ^ 2 * cos((q5 + q4 + ...
        q3)) * (-0.142188000000000015e-2) + Dq2 ^ 2 * cos((-q5 + q4 + q3)) * ...
        (-0.284376000000000030e-2) + Dq2 ^ 2 * cos((q5 + q4 + q3)) * ...
        (-0.284376000000000030e-2) + Dq1 * Dq2 * sin((q4 + q3 + q2)) * ...
        0.201419266993999990e-2 + Dq1 * Dq3 * sin((q4 + q3 + q2)) * ...
        0.201419266993999990e-2 + Dq1 * sin((q4 + q3 + q2)) * Dq4 * ...
        0.201419266993999990e-2 + sin(q5) * Dq1 ^ 2 * 0.145868160000000007e-2 + Dq1 * ...
        Dq2 * cos((-q5 + q2)) * 0.568752000000000060e-2 + Dq1 * Dq2 * cos((q5 + q2)) * ...
        (-0.568752000000000060e-2) + Dq3 ^ 2 * sin((2 * q5)) * ...
        (-0.528848301320000041e-3) + Dq4 ^ 2 * sin((2 * q5)) * ...
        (-0.528848301320000041e-3) + Dq1 * Dq2 * sin((-2 * q5 + q4 + q3 + q2)) * ...
        (-0.528848301319999933e-3) + Dq1 * Dq2 * sin((2 * q5 + q4 + q3 + q2)) * ...
        (-0.528848301320000041e-3) + Dq1 * Dq3 * sin((-2 * q5 + q4 + q3 + q2)) * ...
        (-0.528848301320000041e-3) + Dq1 * Dq3 * sin((2 * q5 + q4 + q3 + q2)) * ...
        (-0.528848301320000041e-3) + Dq1 * Dq4 * sin((2 * q5 + q4 + q3 + q2)) * ...
        (-0.528848301320000041e-3) + Dq1 * Dq4 * sin((-2 * q5 + q4 + q3 + q2)) * ...
        (-0.528848301319999933e-3) + 0.6087959740e-4 * Dq1 * Dq6 * sin((-q5 + q4 + q3 + ...
        q2)) + 0.6087959740e-4 * Dq1 * Dq6 * sin((q5 + q4 + q3 + q2)) + 0.1e-13 * Dq1 * ...
        Dq6 * sin((q4 + q3 + q2)) - 0.1e-13 * Dq1 * Dq6 * sin((-2 * q6 + q4 + q3 + q2)) ...
        + Dq2 * Dq3 * sin((2 * q5)) * (-0.105769660264000008e-2) + Dq2 * Dq4 * sin((2 * ...
        q5)) * (-0.105769660264000008e-2) + 0.1217591948e-3 * Dq2 * Dq6 * sin(q5) + Dq3 ...
        * Dq4 * sin((2 * q5)) * (-0.105769660264000008e-2) + 0.1217591948e-3 * Dq3 * Dq6 ...
        * sin(q5) + 0.1e-13 * Dq3 * Dq6 * sin((-2 * q6 + q5)) + 0.1217591948e-3 * Dq6 * ...
        Dq4 * sin(q5) - 0.1e-13 * Dq6 * Dq4 * sin((-2 * q6 + q5)) + Dq1 ^ 2 * sin((-2 * ...
        q5 + 2 * q4 + 2 * q3 + 2 * q2)) * 0.132212075330000010e-3 + Dq1 ^ 2 * sin((2 * ...
        q5)) * 0.264424150660000021e-3 + Dq1 ^ 2 * sin((2 * q5 + 2 * q4 + 2 * q3 + 2 * ...
        q2)) * (-0.132212075330000010e-3) + Dq2 ^ 2 * sin((2 * q5)) * ...
        (-0.528848301319999933e-3);

        cdq6 = -0.6087959740e-4 * Dq1 * Dq2 * sin(q5 + q4 + q3 + q2) + 0.6087959740e-4 * ...
        Dq1 * Dq2 * sin(-q5 + q4 + q3 + q2) - 0.6087959740e-4 * Dq1 * Dq3 * sin(q5 + q4 ...
        + q3 + q2) + 0.6087959740e-4 * Dq1 * Dq3 * sin(-q5 + q4 + q3 + q2) - ...
        0.6087959740e-4 * Dq1 * Dq4 * sin(q5 + q4 + q3 + q2) + 0.6087959740e-4 * Dq1 * ...
        Dq4 * sin(-q5 + q4 + q3 + q2) - 0.6087959740e-4 * Dq5 * Dq1 * sin(-q5 + q4 + q3 ...
        + q2) - 0.6087959740e-4 * Dq5 * Dq1 * sin(q5 + q4 + q3 + q2) - 0.1217591948e-3 * ...
        Dq5 * sin(q5) * Dq4 - 0.1217591948e-3 * Dq5 * sin(q5) * Dq2 - 0.1217591948e-3 * ...
        Dq5 * sin(q5) * Dq3;

        % Setting up the matrices
        % Inertia Matrix
        M = [m11 m12 m13 m14 m15 m16; m21 m22 m23 m24 m25 m26;m31 m32 m33 m34 m35 m36;m41 ...
        m42 m43 m44 m45 m46;m51 m52 m53 m54 m55 m56;m61 m62 m63 m64 m65 m66] ;
        %
        G = [g1;g2;g3;g4;g5;g6] ;
        % Coriolis and centripedal acceleration matrix
        CDq = [cdq1;cdq2;cdq3;cdq4;cdq5;cdq6] ;
        % define torques
        if t <= 9.8
            K = 1-0.1*t ;
        else
            K = 0.02;
        end
        tau = -K .* [Dq1;Dq2;Dq3;Dq4;Dq5;Dq6] ;
        % determine acceleration
        ddot_q = inv(M)*(tau - G - CDq) ;
        zout = [Dq1; ddot_q(1); Dq2; ddot_q(2); Dq3; ddot_q(3); Dq4; ddot_q(4);...
            Dq5; ddot_q(5); Dq6; ddot_q(6)] ;

    end 

    figure(1)
    hold on
    plot(tout, res(:, 1), 'k')
    plot(tout, res(:, 3), 'm')
    plot(tout, res(:, 5), 'c')
    plot(tout, res(:, 7), 'r')
    plot(tout, res(:, 9), 'g')
    plot(tout, res(:, 11), 'b')
    axis([0, 15, -2, 3]) 
    xlabel('time (s)')
    ylabel('joint angle (radians)')
    title('Joint Angles over time')
    legend('q1','q2','q3','q4','q5','q6')
    
    figure(2)
    hold on
    plot(tout, res(:, 2), 'k')
    plot(tout, res(:, 4), 'm')
    plot(tout, res(:, 6), 'c')
    plot(tout, res(:, 8), 'r')
    plot(tout, res(:, 10), 'g')
    plot(tout, res(:, 12), 'b')
    axis([0, 15, -10, 10]) 
    xlabel('time (s)')
    ylabel('joint velocities (radians/second)')
    title('Joint Velocities over time')
    legend('Dq1','Dq2','Dq3','Dq4','Dq5','Dq6')
    
end 
