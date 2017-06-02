package com.fsmflying.dubbo01;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;

import org.apache.zookeeper.KeeperException;
import org.apache.zookeeper.WatchedEvent;
import org.apache.zookeeper.Watcher;
import org.apache.zookeeper.ZooKeeper;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;

public class AssistTests {

	// String a=null;

	// @Before
	public void before(String testName) {
		// a="abc";
	}

	//
	@After
	public void after() {

	}

	@Test
	public void test_00_jvm() throws InterruptedException {

		List<String> arr = new ArrayList<String>();
		arr.add("001");
		arr.add("003");
		arr.add("005");
		arr.add("004");
		arr.add("002");
		// Collections.sort(arr);
		for (String s : arr)
			System.out.println(s);
		int num = Collections.binarySearch(arr, "005");
		System.out.println(num);

	}

	static DnLock lock = new DnLock("192.168.1.104:2181", "kkkk");
	static int counter = 0;
	static final int N = 10;
	static CountDownLatch startSignal = new CountDownLatch(1);
	static CountDownLatch endSignal = new CountDownLatch(N);

	
	public static void main(String[] args) throws InterruptedException {
		
		ExecutorService es = Executors.newCachedThreadPool();
//		CountDownLatch endAllLockSignal = new CountDownLatch(N);
		for (int i = 0; i < N; i++) {
			es.submit(new Runnable() {
				@Override
				public void run() {
					try {
						startSignal.await();
						lock.lock();
						counter++;
						lock.unlock();
//						endSignal.countDown();
					} catch (InterruptedException e) {
						e.printStackTrace();
					}
				}

			});
		}

		startSignal.countDown();

		try {
//			endSignal.await();
			es.awaitTermination(5000, TimeUnit.MICROSECONDS);
			System.out.println("es.isTerminated:"+ es.isTerminated());
			es.shutdown();
			System.out.println("counter=" + counter);
			Thread.sleep(5000);
		} catch (InterruptedException e) {
			e.printStackTrace();
		}

	}

	@Test
	public void test_03_nolock() {
		for (int i = 0; i < N; i++) {
			new Thread(new Runnable() {
				@Override
				public void run() {
					try {
						startSignal.await();
						endSignal.countDown();
						counter++;
					} catch (InterruptedException e) {
					}
				}

			}).start();
		}

		startSignal.countDown();
		try {
			endSignal.await();
			System.out.println("counter=" + counter);
		} catch (InterruptedException e) {
			e.printStackTrace();
		}

	}

	@Test
	public void test_04_deleteNodes() throws IOException, KeeperException, InterruptedException {
		ZooKeeper zk = new ZooKeeper("192.168.1.104:2181", 5000, new Watcher() {
			@Override
			public void process(WatchedEvent event) {
				System.out.println("{path:\"" + event.getPath() + "\",type:\"" + event.getType() + "\"}");
			}
		});

		List<String> listNodes = zk.getChildren("/dn_lock", false);
		for (String node : listNodes) {
			System.out.println("/dn_lock/" + node);
			zk.delete("/dn_lock/" + node,-1);
		}
		zk.close();

	}
}
