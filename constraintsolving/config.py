class SolverConfig:
    def __init__(self):
        #self.projectdir = 'facebook_react'
        #self.projectdir = 'eclipse_orion'
        self.projectdir = 'ampproject_amphtml'
        # constraint config
        self.constraints_output_dir = 'constraints/{0}'.format(self.projectdir)
        self.constraints_constant_C = 0.75

        # solve config
        self.lambda_const = 0.1
        self.trials = 1
        self.known_samples_ratio = 0.1


        # metric config

        if self.projectdir == 'ampproject_amphtml':
            self.dirprefix="C:/Users/saika/projects/ql/constraintsolving/databases/ampproject_amphtml_b5aa393/src/"
        elif self.projectdir == 'eclipse_orion':
            self.dirprefix="C:/Users/saika/projects/ql/constraintsolving/databases/eclipse_orion.client_js_srcVersion_9ef167/eclipse_orion.client_9ef1675/src/"

        self.trainingsizes=[self.known_samples_ratio]

        # only events above this threshold score will be predicted as src/snk/sans
        self.thresholds = [0.9]









