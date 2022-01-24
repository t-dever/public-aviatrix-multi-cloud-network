import os
from ruamel.yaml import YAML, comments
from os.path import isfile, realpath, isdir, exists
from io import StringIO
from copy import deepcopy

root_path = os.path.dirname(realpath(__name__))

environments = ['dev', 'lab']
yaml=YAML()
yaml.indent(mapping=2, sequence=2, offset=0)
# yaml.representer.ignore_aliases = lambda *data: True

def object_to_yaml_str(obj, options=None):
    if options == None: options = {}
    string_stream = StringIO()
    yaml.dump(obj, string_stream, **options)
    output_str = string_stream.getvalue()
    string_stream.close()
    return output_str

def get_regions(terraform_path, csp):
    file_path = f"{terraform_path}/{csp}"
    if isdir(file_path):
        regions = os.listdir(file_path)
        return regions
    else:
        return None

def update_pipeline(pipeline_file, env, terraform_path, azure_regions=None, aws_regions=None):
    stream = open(pipeline_file, 'r')
    data = yaml.load(stream)
    for index, stage in enumerate(data['stages']):
        # Update Transits Object
        if stage['template'] == "templates/stages/transits.yml":
            combined_transits = []
            if azure_regions:
                for region in azure_regions:
                    combined_transits.append(
                        {
                            'csp': 'azure',
                            'region': region
                        })
            stage['parameters']['transits'] = combined_transits
        # Update Spokes Object
        if stage['template'] == "templates/stages/spokes.yml":
            data['stages'][index].yaml_set_start_comment('\n')
            combined_spokes = []
            # Update Azure Spokes
            if azure_regions:
                for region in azure_regions:
                    spoke_path = f"{terraform_path}/azure/{region}/spokes"
                    if isdir(spoke_path):
                        spoke_params = {
                            'csp': 'azure',
                            'region': region,
                            'spokes': []
                        }
                        spokes = os.listdir(spoke_path)
                        for spoke in spokes:
                            if exists(f"{spoke_path}/{spoke}/terragrunt.hcl"):
                                spoke_params['spokes'].append(spoke)
                        combined_spokes.append(spoke_params)
            stage['parameters']['spokes'] = combined_spokes
    data = object_to_yaml_str(data)

    # Write transit and spoke data to pipeline file
    with open(pipeline_file, 'w') as f:
        f.write(data)
        f.close()

for env in environments:
    pipeline = f"{root_path}/pipelines/{env}.pipeline.yml"
    terraform_path = f"{root_path}/terragrunt/{env}/network"
    azure_regions = get_regions(terraform_path, 'azure')
    if isfile(pipeline):
        update_pipeline(pipeline, env, terraform_path, azure_regions=azure_regions)
