function out = cfg_dwi_reg_run(job)

dwiFile = job.dwiFile{1};
diffeoFile = job.defFile{1};
bvecFile = job.bvecFile{1};
bvalFile = job.bvalFile{1};

main_final(dwiFile, diffeoFile, bvecFile, bvalFile);

