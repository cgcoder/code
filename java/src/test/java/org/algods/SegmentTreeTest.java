package org.algods;

import org.junit.Test;

import java.util.Arrays;

public class SegmentTreeTest {
    @Test
    public void test() {
        SegmentTree tree = new SegmentTree(new int[] {1,2,3});
        tree.print();
    }

    @Test
    public void testRangeQuery() {
        SegmentTree tree = new SegmentTree(new int[] {1,2,3,4,5});
        System.out.println(tree.get(2,4));
        tree.update(1, 8);
        System.out.println(tree.get(2,4));
        System.out.println(tree.get(0,1));
    }
}
