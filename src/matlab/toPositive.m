function CC = toPositive(AA, BB)

dirToP      = AA - BB;
dirTo0      = AA;
rat_0_and_P = dirTo0./dirToP;
maxV        = min(rat_0_and_P(BB < 0));
CC          = AA - dirToP*maxV;
