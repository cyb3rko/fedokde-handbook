import json
import os
import sys

DEST_PATH = "/etc/firefox/policies/"
DEST_FILE = "policies.json"


def is_json(raw):
    try:
        json.loads(raw)
    except ValueError:
        return False
    return True


if len(sys.argv) < 2:
    print("Usage: install.py <file>")
    exit(1)

file_name = sys.argv[1]
if not os.path.isfile(sys.argv[1]):
    print("'" + file_name + "' is not a file")
    exit(1)

if not os.path.isdir(DEST_PATH):
    print("Destination dir not found:")
    print(DEST_PATH)
    exit(1)

file_path = "./" + file_name
with open(file_path, 'r') as f:
    data = f.read()
    if not is_json(data):
        print("'" + file_name + "' is containing invalid json")
        exit(1)

with open(DEST_PATH + DEST_FILE, 'w') as f:
    f.write(data)

print("Installation complete")
