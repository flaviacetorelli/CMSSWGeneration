from CRABClient.UserUtilities import config, getUsernameFromSiteDB
config = config()

config.General.requestName = 'VBS_OSWW_BSM_NANOAODSIM'
config.General.workArea = 'crab_projects'
config.General.transferOutputs = True
config.General.transferLogs = False

config.JobType.pluginName = 'Analysis'
config.JobType.psetName = 'SMP-RunIIAutumn18NanoAODv5-00100_1_cfg.py'
config.JobType.numCores = 2
#config.JobType.maxMemoryMB = 6000

config.Data.inputDataset = '/Bulk/jixiao-VBS_SSWW_BSM_MINIAODSIM_NEW-8c47adb282cd21f1ab3845923e388b14/USER'
config.Data.inputDBS = 'phys03'
config.Data.splitting = 'FileBased'
config.Data.unitsPerJob = 1
config.Data.outLFNDirBase = '/store/user/%s/eft2018' % (getUsernameFromSiteDB())
config.Data.publication = True
config.Data.outputDatasetTag = 'VBS_OSWW_BSM_NANOAODSIM'


config.Site.storageSite = 'T2_CH_CERN'
