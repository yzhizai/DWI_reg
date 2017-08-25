function out = cfg_dwi_reg_run(job)

dwiFile = job.dwiFile{1};
diffeoFile = job.defFile{1};
bvecFile = job.bvecFile{1};
bvalFile = job.bvalFile{1};

fieldName = fieldnames(job.choice);

switch fieldName{1}
    case 'br1'
        main_final(dwiFile, diffeoFile, bvecFile, bvalFile, []);
    case 'br2'
        paraFile = job.choice.br2.paraFile{1};
        main_final(dwiFile, diffeoFile, bvecFile, bvalFile, paraFile);
end



