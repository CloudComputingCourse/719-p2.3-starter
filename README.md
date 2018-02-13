# 719-p2.3-starter
The starter package for 15719 (Spring 2018) Project 2, part 3.
- `submit` is used to run test for grading and submit your solution. Run it as `./submit <code-path> <test-id>`, the arguments are:
  - `<code-path>` is the local directory that contains your driver program and the `run.sh` script. It should contain nothing else.
  - `<test-id>` is the single letter (A, B, C) that identifies each test case described above. Please make sure the number of slave instances match the test specification or your grading will fail.
- `spark_sparse_lr.py` is the starter program that uses the broadcast-collect model for communicating model parameters (i.e. weights).
- `run.sh` is just an example `run.sh` script. You can customize it as long as you believe that may help you solve the problem.
- `get_dataset.sh` is the script that downloads the test case dataset and stores it in HDFS. Run it as `./get_dataset.sh <test-id>`, where `<test-id>` is the single letter (A, B, C) that identifies the test case.
