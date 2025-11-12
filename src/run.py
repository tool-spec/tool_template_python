import os
from datetime import datetime as dt

from json2args import get_parameter
from json2args.data import get_data
from json2args.logger import logger

# parse parameters
kwargs = get_parameter()
data = get_data(as_dict=True)

# check if a toolname was set in env
toolname = os.environ.get('TOOL_RUN', 'foobar').lower()

# switch the tool
if toolname == 'foobar':
    # RUN the tool here and create the output in /out
    logger.info('This toolbox does not include any tool. Did you run the template?\n')
    
    # write parameters to STDOUT.log
    logger.info(kwargs)

    for name, ds in data.items():
        logger.info(f"\n### {name}")
        logger.info(ds)
    

# In any other case, it was not clear which tool to run
else:
    raise AttributeError(f"[{dt.now().isocalendar()}] Either no TOOL_RUN environment variable available, or '{toolname}' is not valid.\n")