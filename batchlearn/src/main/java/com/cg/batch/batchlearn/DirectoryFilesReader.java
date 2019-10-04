package com.cg.batch.batchlearn;

import java.util.HashSet;
import java.util.Set;

import org.springframework.batch.core.ExitStatus;
import org.springframework.batch.core.StepExecution;
import org.springframework.batch.core.StepExecutionListener;
import org.springframework.batch.item.ExecutionContext;
import org.springframework.batch.item.ItemStreamException;
import org.springframework.batch.item.ItemStreamReader;
import org.springframework.batch.item.NonTransientResourceException;
import org.springframework.batch.item.ParseException;
import org.springframework.batch.item.UnexpectedInputException;

public class DirectoryFilesReader implements ItemStreamReader<Object>, StepExecutionListener {

	private int count = 0;
	
	private static Set<Object> objects = new HashSet<>();
	
	@Override
	public void close() throws ItemStreamException {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void open(ExecutionContext arg0) throws ItemStreamException {
		
	}

	@Override
	public void update(ExecutionContext arg0) throws ItemStreamException {
		
	}

	@Override
	public Object read() throws Exception, UnexpectedInputException, ParseException, NonTransientResourceException {
		if (count == 50) return null;
		
		System.out.println("hello " + count++);
		return "Hello";
	}

	@Override
	public void beforeStep(StepExecution stepExecution) {
		System.out.println("beforeStep reader");
	}

	@Override
	public ExitStatus afterStep(StepExecution stepExecution) {
		System.out.println("afterStep reader");
		return ExitStatus.COMPLETED;
	}

}
