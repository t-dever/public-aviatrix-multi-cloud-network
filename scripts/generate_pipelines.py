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

for env in environments:
    pipeline = f"{root_path}/pipelines/{env}.pipeline.yml"
    terraform_path = f"{root_path}/terraform/{env}"
    azure_path = f"{terraform_path}/azure"
    if isdir(azure_path):
        azure_regions = os.listdir(azure_path)
        update_transit_pipeline(pipeline, 'azure', azure_regions)
