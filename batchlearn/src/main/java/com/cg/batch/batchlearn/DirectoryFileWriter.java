package com.cg.batch.batchlearn;

import java.util.List;

import org.springframework.batch.core.ExitStatus;
import org.springframework.batch.core.StepExecution;
import org.springframework.batch.core.StepExecutionListener;
import org.springframework.batch.item.ExecutionContext;
import org.springframework.batch.item.ItemStreamException;
import org.springframework.batch.item.ItemStreamWriter;
import org.springframework.batch.item.file.FlatFileItemReader;

public class DirectoryFileWriter implements ItemStreamWriter<Object>, StepExecutionListener {

	@Override
	public void open(ExecutionContext executionContext) throws ItemStreamException {
		// TODO Auto-generated method stub
		FlatFileItemReader<Object> reader = null;
	}

	@Override
	public void update(ExecutionContext executionContext) throws ItemStreamException {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void close() throws ItemStreamException {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void write(List<? extends Object> items) throws Exception {
		items.forEach(r -> System.out.println("> " + r.toString()));
		Thread.sleep(2000);
	}

	@Override
	public void beforeStep(StepExecution stepExecution) {
		System.out.println("beforeStep Writer!");
	}

	@Override
	public ExitStatus afterStep(StepExecution stepExecution) {
		System.out.println("afterStep Writer!");
		
		return ExitStatus.COMPLETED;
	}

}
