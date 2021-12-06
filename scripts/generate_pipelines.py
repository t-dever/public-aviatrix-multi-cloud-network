import os
from ruamel.yaml import YAML
from os.path import isfile, realpath, isdir

root_path = os.path.dirname(realpath(__name__))

environments = ['dev', 'lab']
yaml=YAML()

def update_transit_pipeline(pipeline_file, cloud_provider, regions):
    stream = open(pipeline_file, 'r')
    data = yaml.load(stream)
    for stage in data['stages']:
        if stage['template'] == "templates/stages/transits.yml":
            if cloud_provider == "azure":
                stage['parameters']['azureRegions'] = regions
    print(data)
    with open(pipeline_file, 'w') as f:
        f.write(yaml.dump(data, f))
        f.close()

def update_spoke_pipeline(pipeline_file, env, cloud_provider, regions):
    terraform_path = f"{root_path}/terraform/{env}/{cloud_provider}"
    combined_spokes = []
    for region in regions:
        spoke_path = f"{terraform_path}/{region}/spokes"
        if isdir(spoke_path):
            spoke_params = {
                'csp': cloud_provider,
                'region': region,
                'spokes': []
            }
            spokes = os.listdir(spoke_path)
            for spoke in spokes:
                spoke_params['spokes'].append(spoke)
            combined_spokes.append(spoke_params)
    print(combined_spokes)
    stream = open(pipeline_file, 'r')
    data = yaml.load(stream)
    for stage in data['stages']:
        if stage['template'] == "templates/stages/spokes.yml":
            stage['parameters']['spokes'] = combined_spokes
    with open(pipeline_file, 'w') as f:
        f.write(yaml.dump(data, f))
        f.close()

for env in environments:
    pipeline = f"{root_path}/pipelines/{env}.pipeline.yml"
    terraform_path = f"{root_path}/terraform/{env}"
    azure_path = f"{terraform_path}/azure"
    if isdir(azure_path):
        azure_regions = os.listdir(azure_path)
        update_transit_pipeline(pipeline, 'azure', azure_regions)
        update_spoke_pipeline(pipeline, env, 'azure', azure_regions)
