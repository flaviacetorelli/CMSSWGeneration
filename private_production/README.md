### Environment settings
Log on `lxplus6` firstly, then clone this repository:
~~~
git clone git@github.com:flaviacetorelli/CMSSWGeneration.git
cd CMSSWGeneration/private_production/eft/2018
~~~
But before setting environment, do:
~~~
voms-proxy-init --voms cms -rfc
~~~
### Install the run_generic_tarball_wget.sh 
To catch tarball > 120 MB from web repository.
~~~
cmsrel CMSSW_10_2_6
cd CMSSW_10_2_6/src/
cmsenv
git-cms-addpkg GeneratorInterface/LHEInterface
cp /afs/cern.ch/user/f/fcetorel/public/run_generic_tarball_wget.sh ./GeneratorInterface/LHEInterface/data/
~~~
Now comipile:
~~~
scram b
~~~
Then you can run the environment setting file `env2018.sh`:
~~~
cd ../../
source env2018.sh
~~~
Then you will have related cfg files for each step and related CMSSW.

### Submit crab jobs
Now you are able to submit crab jobs for each step. In order to get NANOAODSIM, we need 5 steps.
But first, open SMP-RunIIFall18wmLHEGS-00048_1_cfg_BSM.py (same for INT and SM) and redefine the LHEProducer like this:
~~~
process.externalLHEProducer = cms.EDProducer("ExternalLHEProducer",
    args = cms.vstring('https://fcetorel.web.cern.ch/fcetorel/OSWW_RcW_bsm_slc6_amd64_gcc630_CMSSW_9_3_16_tarball.tar.xz'),
    nEvents = cms.untracked.uint32(100),
    numberOfParameters = cms.uint32(1),
    outputFile = cms.string('cmsgrid_final.lhe'),
    scriptName = cms.FileInPath('GeneratorInterface/LHEInterface/data/run_generic_tarball_wget.sh')
)
~~~

And change the string
~~~ 

    args = cms.vstring('https://fcetorel.web.cern.ch/fcetorel/OSWW_RcW_bsm_slc6_amd64_gcc630_CMSSW_9_3_16_tarball.tar.xz'),
~~~ 
with the web location of your gridpack.

1. GEN-SIM
    - How to generate gridpack? Please find [here](https://twiki.cern.ch/twiki/bin/view/Main/Dim6VBSproduction).
    - Check the `config.Site.storageSite`.
    ~~~
    crab submit -c crab_SM_LHE.py
    crab submit -c crab_INT_LHE.py
    crab submit -c crab_BSM_LHE.py
    ~~~
2. GEN-SIM-RAW
    - Use `crab status` to get the outputs of step1,then put behind `config.Data.inputDataset` in crab config files.
    - Check `config.Site.storageSite`.
    ~~~
    crab submit -c crab_SM_Premix_1.py
    crab submit -c crab_INT_Premix_1.py
    crab submit -c crab_BSM_Premix_1.py
    ~~~
3. AODSIM
    - Use `crab status` to get the outputs of step2,then put behind `config.Data.inputDataset` in crab config files.
    - Check `config.Site.storageSite`.
    ~~~
    crab submit -c crab_SM_Premix_2.py
    crab submit -c crab_INT_Premix_2.py
    crab submit -c crab_BSM_Premix_2.py
    ~~~
4. MINIAODSIM
    - Use `crab status` to get the outputs of step3,then put behind `config.Data.inputDataset` in crab config files.
    - Check `config.Site.storageSite`.
    ~~~
    crab submit -c crab_SM_MINIAODSIM.py
    crab submit -c crab_INT_MINIAODSIM.py
    crab submit -c crab_BSM_MINIAODSIM.py
    ~~~
5. NANOAODSIM
    - Use `crab status` to get the outputs of step4,then put behind `config.Data.inputDataset` in crab config files.
    - Check `config.Site.storageSite`.
    ~~~
    crab submit -c crab_SM_NANOAODSIM.py
    crab submit -c crab_INT_NANOAODSIM.py
    crab submit -c crab_BSM_NANOAODSIM.py
    ~~~
Be aware that each step need specific version of CMSSW, which could be found in env2018.sh, so always do cmsenv in the appropriate CMSSW folder before running. 
