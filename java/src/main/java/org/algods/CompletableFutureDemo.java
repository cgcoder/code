package org.algods;

import com.sun.xml.internal.ws.util.CompletedFuture;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.ExecutionException;

import static java.lang.Thread.*;

public class CompletableFutureDemo {
    public static void main(String[] args) throws ExecutionException, InterruptedException {
        System.out.println("main " + currentThread().getId());

        List<CompletableFuture<String>> futures = new ArrayList<>();
        for (int j = 0; j < 10; j++) {
            futures.add(CompletableFuture.supplyAsync(() -> {
                for (int i = 0; i < 10; i++) {
                    System.out.println(currentThread().getId() + " " + i);
                    try {
                        sleep(1000);
                    }
                    catch (InterruptedException e) {
                        e.printStackTrace();
                    }
                }
                return "Hello";
            }));
        }
        CompletableFuture.allOf(futures.toArray(new CompletableFuture[0])).get();

    }
}
