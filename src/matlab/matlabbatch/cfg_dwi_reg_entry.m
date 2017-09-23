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

paraFile = cfg_files;
paraFile.name = 'para file:';
paraFile.tag = 'paraFile';
paraFile.filter = {'mat'};
paraFile.num = [0, 1];
paraFile.help = {'choose the parameter file', ...
    'The .mat file should contains a variable called ''bmatrix''',...
    'bmatrix = bval_bvec_to_matrix(bval, bvec, [2, 1, 3], [1, 1, 1])'};

branch1 = cfg_entry;
branch1.name = 'individual q-space';
branch1.tag = 'br1';
branch1.strtype = 's';
branch1.num = [1, Inf];
branch1.val = {'individual q-space'};
branch1.help = {'Transform individual datasets to their own q-space'};

branch2 = cfg_branch;
branch2.name = 'united q-space';
branch2.tag = 'br2';
branch2.val = {paraFile};
branch2.help = {'Transform individual datasets to united q-space'};

choice = cfg_choice;
choice.name = 'q-space type';
choice.tag = 'choice';
choice.values = {branch1, branch2};
choice.help = {'choose the proper q-space'};

dwi_reg = cfg_exbranch;
dwi_reg.name = 'DWIs registration';
dwi_reg.tag = 'cfg_dwi_reg_entry';
dwi_reg.val = {dwiFile, defFile, bvalFile, bvecFile, choice};
dwi_reg.prog = @cfg_dwi_reg_run;
dwi_reg.help = {'This module is used to regiter DWIs straigtforward'};


