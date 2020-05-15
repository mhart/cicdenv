import json

from . import env, packer_dir, workspace
from ..terraform.driver import TerraformDriver
from ...commands.types.target import Target

# Supported packer sub-commands
packer_commands = [
    'validate',
    'build',
    'console',
]


class PackerDriver(object):
    def __init__(self, settings, flags=[]):
        self.settings = settings
        self.flags = flags
        
        self.envVars = env()

        self.runner = self.settings.runner(cwd=packer_dir, envVars=self.envVars)

    def _tf_outputs(self, component, keys):
        target = Target(component, 'main')
        outputs = TerraformDriver(self.settings, target).outputs()
        return [outputs[key] for key in keys]

    def _get_variables(self):
        (vpc_id, subnet_ids)  = self._tf_outputs('kops/shared',     ('vpc_id', 'public_subnet_ids'))
        (key_id, account_ids) = self._tf_outputs('packer',          ('key_id', 'allowed_account_ids'))
        (apt_repo_bucket)     = self._tf_outputs('shared/apt-repo', ('apt_repo_bucket'))
        return [
            f'--vpc_id={vpc_id}',
            f'--subnet_id={subnet_ids[0]}',
            f'--key_id={key_id}',
            f'--account_ids={account_ids}',
            f'--apt_repo_bucket={apt_repo_bucket}',
        ]

    def _run_packer(self, command):
        #vars = self._get_variables()
        #command_line = ['packer', command] + vars + ['ubuntu-18-04.json']
        #self.runner.run(command_line)
        pass

    def __getattr__(self, name):
        if name in packer_commands:
            def _func():
                self._run_packer(name)
            return _func