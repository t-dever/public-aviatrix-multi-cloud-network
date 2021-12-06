import os
import yaml
import json
from os.path import isfile

def load_yaml(file_path):
    with open(file_path, "r") as f:
        try:
            data = yaml.safe_load(f)
        except yaml.YAMLError as exc:
            print(exc)
        f.close()
    return data

cwd = os.getcwd()
print(f"Current Directory is: {cwd}")
pipeline_path = f"{cwd}/pipelines"

pipeline_files = []
for file in os.listdir(pipeline_path):
    file_path = f"{pipeline_path}/{file}"
    if isfile(file_path):
        pipeline_files.append(file_path)

print(pipeline_files)

for pipeline in pipeline_files:
    file_name = pipeline.split('/')[-1]
    environment = file_name.split('.')[0]
    yaml_data = load_yaml(pipeline)
    for stage in yaml_data['stages']:
        if stage['template'] == "templates/stages/transits.yml":
            transit_stage = stage
            azure_regions = transit_stage['parameters']['azureRegions']
            print(azure_regions)
