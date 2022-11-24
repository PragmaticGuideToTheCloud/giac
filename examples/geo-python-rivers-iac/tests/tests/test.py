import pytest
import re
import subprocess


def load_file_list():
    with open(f"tests/dirs.txt") as f:
        lines = f.readlines()
    result = []
    for line in lines:
        result.append(line.rstrip(" \n\r"))
    return result


dir_list = load_file_list()


@pytest.fixture(params=dir_list)
def next_dir(request):
    return request.param


def test_iac_terraform(next_dir):
    dir = f"../{next_dir}"
    command = ['terragrunt', 'plan', '-lock=false']
    process = subprocess.run(command, cwd=dir, capture_output=True, text=True)
    assert process.returncode == 0

    infra_matches_config = re.search("Your infrastructure matches the configuration", process.stdout)
    assert infra_matches_config is not None

    terraform_will_perform = re.search("Terraform will perform the following actions", process.stdout)
    assert terraform_will_perform is None

    objects_changed_outside = re.search("Objects have changed outside of Terraform", process.stdout)
    assert objects_changed_outside is None
