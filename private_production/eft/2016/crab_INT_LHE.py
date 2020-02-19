from CRABClient.UserUtilities import config, getUsernameFromSiteDB
config = config()

config.General.requestName = 'VBS_SSWW_INT_LHE'
config.General.workArea = 'crab_projects'
config.General.transferOutputs = True
config.General.transferLogs = False

config.JobType.pluginName = 'PrivateMC'
config.JobType.psetName = 'SMP-RunIISummer15wmLHEGS-00006_1_cfg_INT.py'
config.JobType.inputFiles = ['/eos/user/j/jixiao/eft/2016/SSWW_RcW_int_slc6_amd64_gcc630_CMSSW_9_3_16_tarball.tar.xz']

config.Data.outputPrimaryDataset = 'Bulk'
config.Data.splitting = 'EventBased'
config.Data.unitsPerJob = 200
NJOBS = 250  # This is not a configuration parameter, but an auxiliary variable that we use in the next line.
config.Data.totalUnits = config.Data.unitsPerJob * NJOBS
config.Data.outLFNDirBase = '/store/user/%s/eft_2016' % (getUsernameFromSiteDB())
config.Data.publication = True
config.Data.outputDatasetTag = 'VBS_SSWW_INT_LHE'

config.Site.storageSite = 'T2_CN_Beijing'
