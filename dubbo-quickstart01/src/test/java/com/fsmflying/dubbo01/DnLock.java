package com.fsmflying.dubbo01;

import java.io.IOException;
import java.util.Collections;
import java.util.List;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.TimeUnit;

import org.apache.zookeeper.CreateMode;
import org.apache.zookeeper.KeeperException;
import org.apache.zookeeper.WatchedEvent;
import org.apache.zookeeper.Watcher;
import org.apache.zookeeper.ZooDefs;
import org.apache.zookeeper.ZooKeeper;
import org.apache.zookeeper.data.Stat;

public class DnLock implements Watcher {
	ZooKeeper zk = null;
	String root = "/dn_lock";
	String path;
	String currentNode;
	String waitNode;
	CountDownLatch latch;

	public DnLock(String host, String path) {

		this.path = path;
		try {
			zk = new ZooKeeper(host, 5000, this);
		} catch (IOException e) {
			e.printStackTrace();
		}

		try {
			Stat stat = zk.exists(root, false);
			if (null == stat) {
				zk.create(root, new byte[0], ZooDefs.Ids.OPEN_ACL_UNSAFE, CreateMode.PERSISTENT);
			}
		} catch (KeeperException e) {
			e.printStackTrace();
		} catch (InterruptedException e) {
			e.printStackTrace();
		}
	}

	public void lock() {
		System.out.println("lock");
//		try {
//			currentNode = zk.create(root + "/" + path, new byte[0], ZooDefs.Ids.OPEN_ACL_UNSAFE,
//					CreateMode.PERSISTENT_SEQUENTIAL);
//			System.out.println("[create]currentNode=" + currentNode);
//		} catch (KeeperException | InterruptedException e) {
//			e.printStackTrace();
//		}
//
//		try {
//			List<String> lockObjNodes = zk.getChildren(root, false);
//			Collections.sort(lockObjNodes);
//			System.out.println("[equals]currentNode=" + currentNode);
//			if (currentNode.equals(root + "/" + lockObjNodes.get(0))) {// 如果当前创建的结点为最结点，表示加锁成功
//				latch = new CountDownLatch(1);
//				latch.await(5, TimeUnit.SECONDS);
//				return;
//			} else {// 否则,表示还有其他的对象已经成功加锁，并使用锁，这时要等待，并监控它的前一个加锁对象码
//
//				String childNode = currentNode.substring(currentNode.lastIndexOf("/") + 1);
//				int num = Collections.binarySearch(lockObjNodes, childNode);
//				if (num == 0)
//					num = 1;
//				waitNode = lockObjNodes.get(num - 1);
//				System.out.println("waitNode:" + waitNode);
//				Stat stat = zk.exists(root + "/" + waitNode, true);
//				if (null != stat) {
//					latch = new CountDownLatch(1);
//					latch.await(5, TimeUnit.SECONDS);
//				}
//
//			}
//
//		} catch (KeeperException | InterruptedException e) {
//			e.printStackTrace();
//		}

	}

	public void unlock() {

		System.out.println("unlock");
//		try {
//			System.out.println("[delete]currentNode=" + currentNode);
//			zk.delete(currentNode, -1);
//			currentNode = null;
//			zk.close();
//		} catch (InterruptedException | KeeperException e) {
//			e.printStackTrace();
//		}
	}

	@Override
	public void process(WatchedEvent event) {
		// TODO Auto-generated method stub

		System.out.println("process");
//		if (latch != null)
//			latch.countDown();
	}
}
