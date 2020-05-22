from os import path
import subprocess

from ..aws import DEFAULT_REGION
from . import (varfile_dir, backend_config, ami_config, 
    parse_variable_comments_tf, parse_tfvars)
from . import dynamodb

def is_workspaced(component_dir):
    # Sniff the backend.tf to determine if target is a workspaced state
    with open(path.join(component_dir, 'backend.tf'), 'r') as backend:
        if 'workspace_key_prefix' in backend.read():
            return True
        else:
            return False


def resolve_variable_opts(component_dir, workspace):
    # Load variables.tf
    var_opts = []
    vars = parse_variable_comments_tf(path.join(component_dir, 'variables.tf'))  # name -> tfvar {source}
    
    # locate values from {terraform/*.tfvars, data sources}
    values = {}
    values[path.basename(backend_config)] = parse_tfvars(backend_config)
    values[path.basename(ami_config)] = parse_tfvars(ami_config)
    for name, source in vars.items():
        if source.startswith('dynamodb['):  # DynamoDB item scan: `dynamodb[<table>][<field>]`
            var_opts.append('-var')
            var_opts.append(f'{name}={dynamodb.get_items(source, workspace, DEFAULT_REGION)}')
        elif source in values:  # Individual bindings
            var_opts.append('-var')
            var_opts.append(f'{name}={values[source][name]}')
        else:  # Other global variables should be single value for file bindings
            var_opts.append('-var-file')
            var_opts.append(path.join(varfile_dir, source))
    return var_opts
