rm -rf /tmp/hadoop*
#ssh worker1 rm -rf /tmp/hadoop*
#ssh worker2 rm -rf /tmp/hadoop*

hdfs namenode -format

start-dfs.sh

start-master.sh
start-slaves.sh
