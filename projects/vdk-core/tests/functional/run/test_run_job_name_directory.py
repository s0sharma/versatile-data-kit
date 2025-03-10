# Copyright 2021-2024 VMware, Inc.
# SPDX-License-Identifier: Apache-2.0
from click.testing import Result
from functional.run import util
from vdk.plugin.test_utils.util_funcs import cli_assert_equal
from vdk.plugin.test_utils.util_funcs import CliEntryBasedTestRunner


def test_run():
    runner = CliEntryBasedTestRunner()

    result: Result = runner.invoke(["run", util.job_path("job-name-directory")])

    cli_assert_equal(0, result)
