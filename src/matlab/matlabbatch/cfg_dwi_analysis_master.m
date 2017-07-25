function cfg = cfg_dwi_analysis_master
dwi_reg = cfg_repeat;
dwi_reg.name = 'DWI registration';
dwi_reg.tag = 'dwi_reg';
dwi_reg.values = {cfg_dwi_reg_entry};
dwi_reg.forcestruct = true;
dwi_reg.help = {'This module is used to register dwi images'};

cfg = cfg_repeat;
cfg.name = 'DWI Analysis';
cfg.tag = 'dwi_analysis';
cfg.values = {dwi_reg};
cfg.forcestruct = true;
cfg.help = {'This module is used to analyze dwi images'};