#!/bin/bash

# refer to: https://cms-pdmv.cern.ch/mcm/chained_requests?contains=SMP-RunIIAutumn18NanoAODv6-00054&page=0&shown=15
echo '>>>>>>>>>>>>> set environment for GENSIM'
export SCRAM_ARCH=slc6_amd64_gcc700
source /cvmfs/cms.cern.ch/cmsset_default.sh
if [ -r CMSSW_10_2_6/src ] ; then 
 echo release CMSSW_10_2_6 already exists
else
scram p CMSSW CMSSW_10_2_6
fi
cd CMSSW_10_2_6/src
eval `scram runtime -sh`

curl -s --insecure https://cms-pdmv.cern.ch/mcm/public/restapi/requests/get_fragment/SMP-RunIIFall18wmLHEGS-00048 --retry 2 --create-dirs -o Configuration/GenProduction/python/SMP-RunIIFall18wmLHEGS-00048-fragment.py 
[ -s Configuration/GenProduction/python/SMP-RunIIFall18wmLHEGS-00048-fragment.py ] || exit $?;

scram b
cd ../../
seed=$(($(date +%s) % 100 + 1))
cmsDriver.py Configuration/GenProduction/python/SMP-RunIIFall18wmLHEGS-00048-fragment.py --fileout file:SMP-RunIIFall18wmLHEGS-00048.root --mc --eventcontent RAWSIM,LHE --datatier GEN-SIM,LHE --conditions 102X_upgrade2018_realistic_v11 --beamspot Realistic25ns13TeVEarly2018Collision --step LHE,GEN,SIM --geometry DB:Extended --era Run2_2018 --python_filename SMP-RunIIFall18wmLHEGS-00048_1_cfg.py --no_exec --customise Configuration/DataProcessing/Utils.addMonitoring --customise_commands process.RandomNumberGeneratorService.externalLHEProducer.initialSeed="int(${seed})" -n 114 || exit $? ; 

cp SMP-RunIIFall18wmLHEGS-00048_1_cfg.py SMP-RunIIFall18wmLHEGS-00048_1_cfg_SM.py
cp SMP-RunIIFall18wmLHEGS-00048_1_cfg.py SMP-RunIIFall18wmLHEGS-00048_1_cfg_INT.py
cp SMP-RunIIFall18wmLHEGS-00048_1_cfg.py SMP-RunIIFall18wmLHEGS-00048_1_cfg_BSM.py

sed "s/^.*args = cms.vstring(.*$/    args = cms.vstring('..\/OSWW_SMlimit_slc6_amd64_gcc630_CMSSW_9_3_16_tarball.tar.xz'),/" -i SMP-RunIIFall18wmLHEGS-00048_1_cfg_SM.py
sed "s/^.*args = cms.vstring(.*$/    args = cms.vstring('..\/OSWW_RcW_int_slc6_amd64_gcc630_CMSSW_9_3_16_tarball.tar.xz'),/" -i SMP-RunIIFall18wmLHEGS-00048_1_cfg_INT.py
sed "s/^.*args = cms.vstring(.*$/    args = cms.vstring('..\/OSWW_RcW_bsm_slc6_amd64_gcc630_CMSSW_9_3_16_tarball.tar.xz'),/" -i SMP-RunIIFall18wmLHEGS-00048_1_cfg_BSM.py

echo '>>>>>>>>>>>>> set environment for Premix'
export SCRAM_ARCH=slc6_amd64_gcc700
source /cvmfs/cms.cern.ch/cmsset_default.sh
if [ -r CMSSW_10_2_6/src ] ; then 
 echo release CMSSW_10_2_6 already exists
else
scram p CMSSW CMSSW_10_2_6
fi
cd CMSSW_10_2_6/src
eval `scram runtime -sh`


scram b
cd ../../
cmsDriver.py step1 --fileout file:SMP-RunIIAutumn18DRPremix-00006_step1.root  --pileup_input "dbs:/Neutrino_E-10_gun/RunIISummer17PrePremix-PUAutumn18_102X_upgrade2018_realistic_v15-v1/GEN-SIM-DIGI-RAW" --mc --eventcontent PREMIXRAW --datatier GEN-SIM-RAW --conditions 102X_upgrade2018_realistic_v15 --step DIGI,DATAMIX,L1,DIGI2RAW,HLT:@relval2018 --procModifiers premix_stage2 --nThreads 4 --geometry DB:Extended --datamix PreMix --era Run2_2018 --python_filename SMP-RunIIAutumn18DRPremix-00006_1_cfg.py --no_exec --customise Configuration/DataProcessing/Utils.addMonitoring -n 2626 || exit $? ; 

cmsDriver.py step2 --filein file:SMP-RunIIAutumn18DRPremix-00006_step1.root --fileout file:SMP-RunIIAutumn18DRPremix-00006.root --mc --eventcontent AODSIM --runUnscheduled --datatier AODSIM --conditions 102X_upgrade2018_realistic_v15 --step RAW2DIGI,L1Reco,RECO,RECOSIM,EI --procModifiers premix_stage2 --nThreads 4 --era Run2_2018 --python_filename SMP-RunIIAutumn18DRPremix-00006_2_cfg.py --no_exec --customise Configuration/DataProcessing/Utils.addMonitoring -n 2626 || exit $? ; 

echo '>>>>>>>>>>>>> set environment for MINIAODSIM'
export SCRAM_ARCH=slc6_amd64_gcc700
source /cvmfs/cms.cern.ch/cmsset_default.sh
if [ -r CMSSW_10_2_6/src ] ; then 
 echo release CMSSW_10_2_6 already exists
else
scram p CMSSW CMSSW_10_2_6
fi
cd CMSSW_10_2_6/src
eval `scram runtime -sh`


scram b
cd ../../
cmsDriver.py step1 --filein "dbs:/WWJJToLNuLNu_EWK_noTop_13TeV-madgraph-pythia8/RunIIAutumn18MiniAOD-102X_upgrade2018_realistic_v15_ext1-v1/MINIAODSIM" --fileout file:SMP-RunIIAutumn18MiniAOD-00006.root --mc --eventcontent MINIAODSIM --runUnscheduled --datatier MINIAODSIM --conditions 102X_upgrade2018_realistic_v15 --step PAT --nThreads 4 --geometry DB:Extended --era Run2_2018 --python_filename SMP-RunIIAutumn18MiniAOD-00006_1_cfg.py --no_exec --customise Configuration/DataProcessing/Utils.addMonitoring -n 8597 || exit $? ; 

echo '>>>>>>>>>>>>> set environment for NANOAODSIM'

export SCRAM_ARCH=slc6_amd64_gcc700
source /cvmfs/cms.cern.ch/cmsset_default.sh
if [ -r CMSSW_10_2_18/src ] ; then 
 echo release CMSSW_10_2_18 already exists
else
scram p CMSSW CMSSW_10_2_18
fi
cd CMSSW_10_2_18/src
eval `scram runtime -sh`


scram b
cd ../../
cmsDriver.py step1 --filein "dbs:/WWJJToLNuLNu_EWK_noTop_13TeV-madgraph-pythia8/RunIIAutumn18MiniAOD-102X_upgrade2018_realistic_v15_ext1-v1/MINIAODSIM" --fileout file:SMP-RunIIAutumn18NanoAODv6-00054.root  --mc --eventcontent NANOAODSIM --datatier NANOAODSIM --conditions 102X_upgrade2018_realistic_v20 --step NANO --nThreads 2 --era Run2_2018,run2_nanoAOD_102Xv1 --python_filename SMP-RunIIAutumn18NanoAODv6-00054_1_cfg.py --no_exec --customise Configuration/DataProcessing/Utils.addMonitoring -n 10000 || exit $? ; 
sed '/process.NANOAODSIMoutput = cms.OutputModule("NanoAODOutputModule",/a\    fakeNameForCrab =cms.untracked.bool(True),' -i SMP-RunIIAutumn18NanoAODv6-00054_1_cfg.py
