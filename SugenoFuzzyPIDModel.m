Kp = 30.0;
Ki = 1.0;
Kd = 1.0;

fis_fpid = sugfis;

fis_fpid = addInput(fis_fpid, [-1 1], 'Name', 'E');
fis_fpid = addInput(fis_fpid, [-1 1], 'Name', 'delE');

fis_fpid = addMF(fis_fpid, 'E', 'trimf', [-1.5 -1 -0.5], 'Name', 'NB');
fis_fpid = addMF(fis_fpid, 'E', 'trimf', [-1 -0.5 0], 'Name', 'NM');
fis_fpid = addMF(fis_fpid, 'E', 'trimf', [-0.5 0 0.5], 'Name', 'Z');
fis_fpid = addMF(fis_fpid, 'E', 'trimf', [0 0.5 1], 'Name', 'PM');
fis_fpid = addMF(fis_fpid, 'E', 'trimf', [0.5 1 1.5], 'Name', 'PB');
fis_fpid = addMF(fis_fpid, 'delE', 'trimf', [-1.5 -1 -0.5], 'Name', 'NB');
fis_fpid = addMF(fis_fpid, 'delE', 'trimf', [-1 -0.5 0], 'Name', 'NM');
fis_fpid = addMF(fis_fpid, 'delE', 'trimf', [-0.5 0 0.5], 'Name', 'Z');
fis_fpid = addMF(fis_fpid, 'delE', 'trimf', [0 0.5 1], 'Name', 'PM');
fis_fpid = addMF(fis_fpid, 'delE', 'trimf', [0.5 1 1.5], 'Name', 'PB');

figure
subplot(1, 2, 1)
plotmf(fis_fpid, 'input', 1)
title('Input 1 for Fuzzy PID')
subplot(1, 2, 2)
plotmf(fis_fpid, 'input', 2)
title('Input 2 for Fuzzy PID')

fis_fpid = addOutput(fis_fpid, [-1 1], 'Name', 'dKp');
fis_fpid = addOutput(fis_fpid, [-1 1], 'Name', 'dKi');
fis_fpid = addOutput(fis_fpid, [-1 1], 'Name', 'dKd');

fis_fpid = addMF(fis_fpid, 'dKp', 'constant', -1, 'Name', 'S');
fis_fpid = addMF(fis_fpid, 'dKp', 'constant', -0.5, 'Name', 'MS');
fis_fpid = addMF(fis_fpid, 'dKp', 'constant', 0, 'Name', 'M');
fis_fpid = addMF(fis_fpid, 'dKp', 'constant', 0.5, 'Name', 'MB');
fis_fpid = addMF(fis_fpid, 'dKp', 'constant', 1, 'Name', 'B');

fis_fpid = addMF(fis_fpid, 'dKi', 'constant', -1, 'Name', 'S');
fis_fpid = addMF(fis_fpid, 'dKi', 'constant', -0.5, 'Name', 'MS');
fis_fpid = addMF(fis_fpid, 'dKi', 'constant', 0, 'Name', 'M');
fis_fpid = addMF(fis_fpid, 'dKi', 'constant', 0.5, 'Name', 'MB');
fis_fpid = addMF(fis_fpid, 'dKi', 'constant', 1, 'Name', 'B');

fis_fpid = addMF(fis_fpid, 'dKd', 'constant', -1, 'Name', 'S');
fis_fpid = addMF(fis_fpid, 'dKd', 'constant', -0.5, 'Name', 'MS');
fis_fpid = addMF(fis_fpid, 'dKd', 'constant', 0, 'Name', 'M');
fis_fpid = addMF(fis_fpid, 'dKd', 'constant', 0.5, 'Name', 'MB');
fis_fpid = addMF(fis_fpid, 'dKd', 'constant', 1, 'Name', 'B');

dKp_rules = [...
    "E==NB & delE==PB => dKp=S"; ...
    "E==NM & delE==PB => dKp=MS"; ...
    "E==Z & delE==PB => dKp=S"; ...
    "E==PM & delE==PB => dKp=MB"; ...
    "E==PB & delE==PB => dKp=B"; ...
    "E==NB & delE==PM => dKp=S"; ...
    "E==NM & delE==PM => dKp=MS"; ...
    "E==Z & delE==PM => dKp=S"; ...
    "E==PM & delE==PM => dKp=MB"; ...
    "E==PB & delE==PM => dKp=B"; ...
    "E==NB & delE==Z => dKp=S"; ...
    "E==NM & delE==Z => dKp=S"; ...
    "E==Z & delE==Z => dKp=S"; ...
    "E==PM & delE==Z => dKp=B"; ...
    "E==PB & delE==Z => dKp=B"; ...
    "E==NB & delE==NM => dKp=S"; ...
    "E==NM & delE==NM => dKp=S"; ...
    "E==Z & delE==NM => dKp=S"; ...
    "E==PM & delE==NM => dKp=MS"; ...
    "E==PB & delE==NM => dKp=B"; ...
    "E==NB & delE==NB => dKp=S"; ...
    "E==NM & delE==NB => dKp=S"; ...
    "E==Z & delE==NB => dKp=S"; ...
    "E==PM & delE==NB => dKp=MS"; ...
    "E==PB & delE==NB => dKp=B"; ...
    ];

dKi_rules = [...
    "E==NB & delE==PB => dKi=MS"; ...
    "E==NM & delE==PB => dKi=MS"; ...
    "E==Z & delE==PB => dKi=S"; ...
    "E==PM & delE==PB => dKi=MB"; ...
    "E==PB & delE==PB => dKi=B"; ...
    "E==NB & delE==PM => dKi=MS"; ...
    "E==NM & delE==PM => dKi=S"; ...
    "E==Z & delE==PM => dKi=S"; ...
    "E==PM & delE==PM => dKi=M"; ...
    "E==PB & delE==PM => dKi=B"; ...
    "E==NB & delE==Z => dKi=S"; ...
    "E==NM & delE==Z => dKi=S"; ...
    "E==Z & delE==Z => dKi=S"; ...
    "E==PM & delE==Z => dKi=MB"; ...
    "E==PB & delE==Z => dKi=B"; ...
    "E==NB & delE==NM => dKi=S"; ...
    "E==NM & delE==NM => dKi=S"; ...
    "E==Z & delE==NM => dKi=S"; ...
    "E==PM & delE==NM => dKi=B"; ...
    "E==PB & delE==NM => dKi=B"; ...
    "E==NB & delE==NB => dKi=S"; ...
    "E==NM & delE==NB => dKi=S"; ...
    "E==Z & delE==NB => dKi=S"; ...
    "E==PM & delE==NB => dKi=MS"; ...
    "E==PB & delE==NB => dKi=B"; ...
    ];

dKd_rules = [...
    "E==NB & delE==PB => dKd=S"; ...
    "E==NM & delE==PB => dKd=MS"; ...
    "E==Z & delE==PB => dKd=B"; ...
    "E==PM & delE==PB => dKd=B"; ...
    "E==PB & delE==PB => dKd=S"; ...
    "E==NB & delE==PM => dKd=MS"; ...
    "E==NM & delE==PM => dKd=MS"; ...
    "E==Z & delE==PM => dKd=B"; ...
    "E==PM & delE==PM => dKd=MB"; ...
    "E==PB & delE==PM => dKd=S"; ...
    "E==NB & delE==Z => dKd=M"; ...
    "E==NM & delE==Z => dKd=M"; ...
    "E==Z & delE==Z => dKd=B"; ...
    "E==PM & delE==Z => dKd=MB"; ...
    "E==PB & delE==Z => dKd=S"; ...
    "E==NB & delE==NM => dKd=MB"; ...
    "E==NM & delE==NM => dKd=M"; ...
    "E==Z & delE==NM => dKd=B"; ...
    "E==PM & delE==NM => dKd=S"; ...
    "E==PB & delE==NM => dKd=S"; ...
    "E==NB & delE==NB => dKd=B"; ...
    "E==NM & delE==NB => dKd=MB"; ...
    "E==Z & delE==NB => dKd=B"; ...
    "E==PM & delE==NB => dKd=S"; ...
    "E==PB & delE==NB => dKd=S"; ...
    ];
rules = [dKp_rules dKi_rules dKd_rules]
fis_fpid = addRule(fis_fpid, rules)

figure
gensurf(fis_fpid)
title('Control surface for Fuzzy PID')