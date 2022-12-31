#!/bin/bash

md2cf --host "https://YOUR.CONFLUENCE.com/rest/api" --insecure  --message ${ENV_MESSAGE} --token ${ENV_TOKEN} --space TTF --page-id ${ENV_PAGEID} ${ENV_README_PATH}