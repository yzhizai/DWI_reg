function dwi_reg = cfg_dwi_reg_entry

dwiFile      = cfg_files;
dwiFile.name = 'Diffusion Images:';
dwiFile.tag = 'dwiFile';
dwiFile.filter = {'nii'};
dwiFile.num = [0, 1];
dwiFile.help = {'Choose the diffusion images', ...
    'This module just support file suffixed with ''nii'''};

defFile = cfg_files;
defFile.name = 'Deformation Field:';
defFile.tag = 'defFile';
defFile.filter = {'^y_.*'};
defFile.num = [0, 1];
defFile.help = {'Choose the deformation file', ...
    'this file should be prefixed with ''y_'''};

bvecFile = cfg_files;
bvecFile.name = 'bvec:';
bvecFile.tag = 'bvecFile';
bvecFile.filter = {'bvec'};
bvecFile.num = [0, 1];
bvecFile.help = {'Choose the bvec file'};

bvalFile = cfg_files;
bvalFile.name = 'bval:';
bvalFile.tag = 'bvalFile';
bvalFile.filter = {'bval'};
bvalFile.num = [0, 1];
bvalFile.help = {'Choose the bval file'};

dwi_reg = cfg_exbranch;
dwi_reg.name = 'DWIs registration';
dwi_reg.tag = 'cfg_dwi_reg_entry';
dwi_reg.val = {dwiFile, defFile, bvecFile, bvalFile};
dwi_reg.prog = @cfg_dwi_reg_run;
dwi_reg.help = {'This module is used to regiter DWIs straigtforward'};


