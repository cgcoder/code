package org.algods;

import java.util.ArrayList;
import java.util.Deque;
import java.util.LinkedList;
import java.util.List;

public class SegmentTree {

    private List<Integer> list = new ArrayList<Integer>();
    int count = 0;
    private int[] data;

    public SegmentTree(int[] data) {
        build(data);
        this.data = data;
        this.count = data.length;
    }

    public void update(int index, int value) {
        this.update(index, 0, 0, this.count - 1, value);
    }

    public void update(int updateIndex, int index, int start, int end, int value) {
        if (start == end && start == updateIndex) {
            this.list.set(index, value);
            return;
        }
        int mid = (start + end) / 2;
        int lrs = start;
        int lre = mid;
        int rrs = mid + 1;
        int rre = end;
        if (lrs <= updateIndex && lre >= updateIndex) {
            update(updateIndex, 2 * index + 1, lrs, lre, value);
        }
        else {
            update(updateIndex, 2 * index + 2, rrs, rre, value);
        }
        int left = this.list.get(2*index+1);
        int right = this.list.get(2*index+2);
        list.set(index, left+right);
    }

    public int get(int start, int end) {
        return get(0, 0, count - 1, start, end);
    }

    protected int get(int index, int rs, int re, int start, int end) {
        if (start == rs && end == re) {
            return this.list.get(index);
        }

        int rm = (rs+re)/2;
        int lrs = rs;
        int lre = rm;
        int rrs = rm + 1;
        int rre = re;

        if (lrs <= start && lre >= end) {
            return get(2 * index + 1, lrs, lre, start, end);
        }
        else if (rrs <= rre) {
            if (rrs <= start && rre >= end) {
                return get(2*index+2, rrs, rre, start, end);
            }
            else {
                int left = get(2 * index + 1, lrs, lre, start, lre);
                int right = get(2 * index + 2, rrs, rre, rrs, end);
                return left + right;
            }
        }

        throw new IllegalStateException();
    }

    protected void build(int[] data) {
        this.build(data, 0, 0, data.length - 1);
    }

    private void build(int[] data, int index, int start, int end) {
        if (start == end) {
            set(index, data[start]);
            return;
        }
        else {
            int mid = (start + end) / 2;
            build(data, 2 * index + 1, start, mid);
            build(data, 2 * index + 2, mid + 1, end);
            set(index, list.get(2*index+1) + list.get(2*index+2));
        }
    }

    private void set(int index, int data) {
        while (index >= list.size()) {
            list.add(null);
        }
        list.set(index, data);
    }

    public void print() {
        Deque<Integer> q = new LinkedList();
        q.offerLast(0);

        while (!q.isEmpty()) {
            int size = q.size();
            while (size-- > 0) {
                int index = q.pollFirst();
                System.out.print(this.list.get(index) + " ");
                int li = 2*index+1;
                int ri = 2*index+2;
                if (li < this.list.size()) {
                    q.offerLast(li);
                    if (ri < this.list.size()) {
                        q.offerLast(ri);
                    }
                }
            }
            System.out.println("");
        }
    }
}
