import sys
import json
import subprocess
import os
from pathlib import Path

inFile = sys.argv[1]
outFile = sys.argv[2]
profile = json.load(open("build-profile.json5"))
config = profile["app"]["signingConfigs"][0]["material"]
basePath = Path(config["certpath"]).parent
keyPwd = subprocess.check_output(
    ["node", "sign.js", basePath.absolute(), config["keyPassword"]], encoding="utf-8"
).strip()
keystorePwd = subprocess.check_output(
    ["node", "sign.js", basePath.absolute(), config["storePassword"]], encoding="utf-8"
).strip()
cmdline = f"java -jar /Applications/DevEco-Studio.app/Contents/sdk/default/openharmony/toolchains/lib/hap-sign-tool.jar sign-app -keyAlias {config['keyAlias']} -signAlg {config['signAlg']} -mode localSign -appCertFile {config['certpath']} -profileFile {config['profile']} -inFile {inFile} -keystoreFile {config['storeFile']} -outFile {outFile} -keyPwd {keyPwd} -keystorePwd {keystorePwd}"
print(cmdline)
os.system(cmdline)
