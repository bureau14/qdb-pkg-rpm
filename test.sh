set -eu

DISTRIBUTION=$1
RELEASE=$2
DELAY=$3

CONTAINER_NAME=$DISTRIBUTION.$RELEASE.$BUILD_NUMBER
CONTAINER_ROOTFS=/var/lib/lxc/$CONTAINER_NAME/rootfs

TEST_SUITE="$DISTRIBUTION.$RELEASE"

QDB_ALL=$(ls qdb-all/*.rpm)
QDB_API=$(ls qdb-api/*.rpm)
QDB_SERVER=$(ls qdb-server/*.rpm)
QDB_UTILS=$(ls qdb-utils/*.rpm)
QDB_HTTP=$(ls qdb-web-bridge/*.rpm)

CONTAINER_CONFIG=test_container.conf
cat >$CONTAINER_CONFIG <<END
lxc.mount.entry = $(pwd) mnt none ro,bind 0 0
lxc.network.type = veth
lxc.network.link = lxcbr0
lxc.network.flags = up
lxc.network.hwaddr = 00:16:3e:xx:xx:xx
END

echo "##teamcity[testSuiteStarted name='$TEST_SUITE']"

echo "##teamcity[testStarted name='start' captureStandardOutput='true']"
sudo lxc-create -t download -n $CONTAINER_NAME -f $CONTAINER_CONFIG -- --dist $DISTRIBUTION --release $RELEASE --arch amd64 --force-cache
sudo lxc-start -n $CONTAINER_NAME
echo "Wait $DELAY seconds..."
sleep $DELAY
sudo lxc-attach --clear-env -n $CONTAINER_NAME -- yum install --nogpgcheck -y wget || echo "##teamcity[testFailed name='start' message='Failed to install wget']"
echo "##teamcity[testFinished name='start']"

echo "##teamcity[testStarted name='api.install' captureStandardOutput='true']"
sudo lxc-attach --clear-env -n $CONTAINER_NAME -- rpm -i /mnt/$QDB_API || echo "##teamcity[testFailed name='api.install' message='Failed to install API']"
echo "##teamcity[testFinished name='api.install']"

echo "##teamcity[testStarted name='server.install' captureStandardOutput='true']"
sudo lxc-attach --clear-env -n $CONTAINER_NAME -- rpm -i /mnt/$QDB_SERVER || echo "##teamcity[testFailed name='server.install' message='Failed to install server']"
echo "##teamcity[testFinished name='server.install']"

echo "##teamcity[testStarted name='utils.install' captureStandardOutput='true']"
sudo lxc-attach --clear-env -n $CONTAINER_NAME -- rpm -i /mnt/$QDB_UTILS || echo "##teamcity[testFailed name='utils.install' message='Failed to install utils']"
echo "##teamcity[testFinished name='utils.install']"

echo "##teamcity[testStarted name='web-bridge.install' captureStandardOutput='true']"
sudo lxc-attach --clear-env -n $CONTAINER_NAME -- rpm -i /mnt/$QDB_HTTP || echo "##teamcity[testFailed name='web-bridge.install' message='Failed to install web-bridge']"
echo "##teamcity[testFinished name='web-bridge.install']"

echo "##teamcity[testStarted name='qdbsh.put' captureStandardOutput='true']"
sudo lxc-attach --clear-env -n $CONTAINER_NAME -- qdbsh --user-credentials-file=/etc/qdb/qdbsh_private.key --cluster-public-key=/var/share/qdb/cluster_public.key -c "blob_put hello world" || echo "##teamcity[testFailed name='qdbsh.put' message='Failed to put blob']"
echo "##teamcity[testFinished name='qdbsh.put']"

echo "##teamcity[testStarted name='qdbsh.get' captureStandardOutput='true']"
RESULT=$(sudo lxc-attach --clear-env -n $CONTAINER_NAME -- qdbsh --user-credentials-file=/etc/qdb/qdbsh_private.key --cluster-public-key=/var/share/qdb/cluster_public.key -c "blob_get hello") || echo "##teamcity[testFailed name='qdbsh.get' message='Failed to get blob']"
[ "$RESULT" = "world" ] || echo "##teamcity[testFailed name='qdbsh.get' message='Invalid output from blob_get']"
echo "##teamcity[testFinished name='qdbsh.get']"

echo "##teamcity[testStarted name='qdb-benchmark.put' captureStandardOutput='true']"
sudo lxc-attach --clear-env -n $CONTAINER_NAME -- qdb-benchmark --cluster-public-key-file=/usr/share/qdb/cluster_public.key --user-credentials-file=/etc/qdb/qdbsh_private.key --threads 1 --size 2k --tests qdb_blob_put || echo "##teamcity[testFailed name='qdb-benchmark.put' message='Failed to put blob']"
echo "##teamcity[testFinished name='qdb-benchmark.put']"

echo "##teamcity[testStarted name='web-bridge.wget' captureStandardOutput='true']"
sudo lxc-attach --clear-env -n $CONTAINER_NAME -- wget -qS http://127.0.0.1:8080 2>&1 || echo "##teamcity[testFailed name='web-bridge.wget' message='Failed to wget 127.0.0.1:8080']"
echo "##teamcity[testFinished name='web-bridge.wget']"

echo "##teamcity[testStarted name='reboot' captureStandardOutput='true']"
echo "Stop container..."
sudo lxc-stop -n $CONTAINER_NAME
sudo lxc-wait -n $CONTAINER_NAME -s STOPPED
echo "Start container..."
sudo lxc-start -n $CONTAINER_NAME
sudo lxc-wait -n $CONTAINER_NAME -s RUNNING
echo "Wait $DELAY seconds..."
sleep $DELAY
echo "##teamcity[testFinished name='reboot']"

echo "##teamcity[testStarted name='qdbsh.get.after-reboot' captureStandardOutput='true']"
RESULT=$(sudo lxc-attach --clear-env -n $CONTAINER_NAME -- qdbsh --user-credentials-file=/etc/qdb/qdbsh_private.key --cluster-public-key=/var/share/qdb/cluster_public.key -c "blob_get hello") || echo "##teamcity[testFailed name='qdbsh.get.after-reboot' message='Failed to get blob']"
[ "$RESULT" = "world" ] || echo "##teamcity[testFailed name='qdbsh.get' message='Invalid output from blob_get']"
echo "##teamcity[testFinished name='qdbsh.get.after-reboot']"

echo "##teamcity[testStarted name='web-bridge.wget.after-reboot' captureStandardOutput='true']"
sudo lxc-attach --clear-env -n $CONTAINER_NAME -- wget -qS http://127.0.0.1:8080 2>&1 || echo "##teamcity[testFailed name='web-bridge.wget.after-reboot' message='Failed to wget 127.0.0.1:8080']"
echo "##teamcity[testFinished name='web-bridge.wget.after-reboot']"

echo "##teamcity[testStarted name='api.uninstall' captureStandardOutput='true']"
sudo lxc-attach --clear-env -n $CONTAINER_NAME -- rpm -e qdb-api || echo "##teamcity[testFailed name='api.uninstall' message='Failed to uninstall API']"
echo "##teamcity[testFinished name='api.uninstall']"

echo "##teamcity[testStarted name='server.uninstall' captureStandardOutput='true']"
sudo lxc-attach --clear-env -n $CONTAINER_NAME -- rpm -e qdb-server || echo "##teamcity[testFailed name='server.uninstall' message='Failed to uninstall server']"
echo "##teamcity[testFinished name='server.uninstall']"

echo "##teamcity[testStarted name='utils.uninstall' captureStandardOutput='true']"
sudo lxc-attach --clear-env -n $CONTAINER_NAME -- rpm -e qdb-utils || echo "##teamcity[testFailed name='utils.uninstall' message='Failed to uninstall utils']"
echo "##teamcity[testFinished name='utils.uninstall']"

echo "##teamcity[testStarted name='web-bridge.uninstall' captureStandardOutput='true']"
sudo lxc-attach --clear-env -n $CONTAINER_NAME -- rpm -e qdb-web-bridge || echo "##teamcity[testFailed name='web-bridge.uninstall' message='Failed to uninstall web-bridge']"
echo "##teamcity[testFinished name='web-bridge.uninstall']"


# [ qdb-all tests] Need to be done separately to avoid conflicts
echo "##teamcity[testStarted name='all.install' captureStandardOutput='true']"
sudo lxc-attach --clear-env -n $CONTAINER_NAME -- rpm -i /mnt/$QDB_ALL || echo "##teamcity[testFailed name='all.install' message='Failed to install God package']"
echo "##teamcity[testFinished name='all.install']"

echo "Wait for qdbd to start: $DELAY seconds..."
sleep $DELAY

echo "##teamcity[testStarted name='all.qdbsh.put' captureStandardOutput='true']"
sudo lxc-attach --clear-env -n $CONTAINER_NAME -- qdbsh --user-credentials-file=/etc/qdb/qdbsh_private.key --cluster-public-key=/var/share/qdb/cluster_public.key -c "blob_put alias content" || echo "##teamcity[testFailed name='all.qdbsh.put' message='Failed to put blob']"
echo "##teamcity[testFinished name='all.qdbsh.put']"

echo "##teamcity[testStarted name='all.qdbsh.get' captureStandardOutput='true']"
RESULT=$(sudo lxc-attach --clear-env -n $CONTAINER_NAME -- qdbsh --user-credentials-file=/etc/qdb/qdbsh_private.key --cluster-public-key=/var/share/qdb/cluster_public.key -c "blob_get alias") || echo "##teamcity[testFailed name='all.qdbsh.get' message='Failed to get blob']"
[ "$RESULT" = "content" ] || echo "##teamcity[testFailed name='all.qdbsh.get' message='Invalid output from blob_get']"
echo "##teamcity[testFinished name='all.qdbsh.get']"

echo "##teamcity[testStarted name='all.web-bridge.wget' captureStandardOutput='true']"
sudo lxc-attach --clear-env -n $CONTAINER_NAME -- wget -qS http://127.0.0.1:8080 2>&1 || echo "##teamcity[testFailed name='all.web-bridge.wget' message='Failed to wget 127.0.0.1:8080']"
echo "##teamcity[testFinished name='all.web-bridge.wget']"

echo "##teamcity[testStarted name='reboot' captureStandardOutput='true']"
echo "Stop container..."
sudo lxc-stop -n $CONTAINER_NAME
sudo lxc-wait -n $CONTAINER_NAME -s STOPPED
echo "Start container..."
sudo lxc-start -n $CONTAINER_NAME
sudo lxc-wait -n $CONTAINER_NAME -s RUNNING
echo "Wait $DELAY seconds..."
sleep $DELAY
echo "##teamcity[testFinished name='reboot']"

echo "##teamcity[testStarted name='all.qdbsh.get.after-reboot' captureStandardOutput='true']"
RESULT=$(sudo lxc-attach --clear-env -n $CONTAINER_NAME -- qdbsh --user-credentials-file=/etc/qdb/qdbsh_private.key --cluster-public-key=/var/share/qdb/cluster_public.key -c "blob_get alias") || echo "##teamcity[testFailed name='all.qdbsh.get.after-reboot' message='Failed to get blob']"
[ "$RESULT" = "content" ] || echo "##teamcity[testFailed name='all.qdbsh.get' message='Invalid output from blob_get']"
echo "##teamcity[testFinished name='all.qdbsh.get.after-reboot']"

echo "##teamcity[testStarted name='all.web-bridge.wget.after-reboot' captureStandardOutput='true']"
sudo lxc-attach --clear-env -n $CONTAINER_NAME -- wget -qS http://127.0.0.1:8080 2>&1 || echo "##teamcity[testFailed name='all.web-bridge.wget.after-reboot' message='Failed to wget 127.0.0.1:8080']"
echo "##teamcity[testFinished name='all.web-bridge.wget.after-reboot']"


echo "##teamcity[testStarted name='all.uninstall' captureStandardOutput='true']"
sudo lxc-attach --clear-env -n $CONTAINER_NAME -- rpm -e qdb-all || echo "##teamcity[testFailed name='all.uninstall' message='Failed to uninstall God package']"
echo "##teamcity[testFinished name='all.uninstall']"

# [end of qdb-all tests]


echo "##teamcity[testStarted name='stop' captureStandardOutput='true']"
sudo lxc-destroy -f -n $CONTAINER_NAME
echo "##teamcity[testFinished name='stop']"

echo "##teamcity[testSuiteFinished name='$TEST_SUITE']"