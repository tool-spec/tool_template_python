import os
import sys

from parameters import get_data, get_logger, get_parameters

params = get_parameters()
data = get_data()
logger = get_logger()

toolname = os.environ.get("TOOL_RUN", "foobar").lower()

logger.info("start", "Starting tool run", tool=toolname)
logger.info(
    "input-loaded",
    "Loaded validated parameters and data paths",
    tool=toolname,
    parameter_count=len(vars(params)),
    data_keys=sorted(data.keys()),
)

if toolname == "foobar":
    sys.stderr.write("This toolbox does not include any tool. Did you run the template?\n")
    sys.stderr.write(f"{vars(params)}\n")

    for name, path in data.items():
        sys.stderr.write(f"\n### {name}: {path}\n")

    logger.info("finished", "Template run finished successfully", tool=toolname)
else:
    logger.error("error", "Requested tool is not implemented in the template", tool=toolname)
    raise AttributeError(f"Either no TOOL_RUN environment variable available, or '{toolname}' is not valid.\n")
