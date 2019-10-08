package com.cg.batch.batchlearn;

import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.atomic.AtomicInteger;

import org.springframework.batch.core.ExitStatus;
import org.springframework.batch.core.Job;
import org.springframework.batch.core.Step;
import org.springframework.batch.core.StepExecution;
import org.springframework.batch.core.StepExecutionListener;
import org.springframework.batch.core.configuration.annotation.BatchConfigurer;
import org.springframework.batch.core.configuration.annotation.DefaultBatchConfigurer;
import org.springframework.batch.core.configuration.annotation.JobBuilderFactory;
import org.springframework.batch.core.configuration.annotation.StepBuilderFactory;
import org.springframework.batch.core.configuration.annotation.StepScope;
import org.springframework.batch.core.partition.PartitionHandler;
import org.springframework.batch.core.partition.StepExecutionSplitter;
import org.springframework.batch.core.partition.support.Partitioner;
import org.springframework.batch.core.partition.support.TaskExecutorPartitionHandler;
import org.springframework.batch.core.step.tasklet.Tasklet;
import org.springframework.batch.item.ExecutionContext;
import org.springframework.batch.item.ItemReader;
import org.springframework.batch.item.ItemStreamException;
import org.springframework.batch.item.ItemWriter;
import org.springframework.batch.item.ParseException;
import org.springframework.batch.item.UnexpectedInputException;
import org.springframework.batch.item.support.AbstractItemStreamItemReader;
import org.springframework.batch.repeat.RepeatStatus;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.task.SimpleAsyncTaskExecutor;
import org.springframework.core.task.TaskExecutor;

@Configuration
public class CustomBatchConfigurer {
	@Autowired
	private JobBuilderFactory jobBuilderFactory;
	@Autowired
	private StepBuilderFactory stepBuilderFactory;

	//@Bean
	public Job job() {
		return this.jobBuilderFactory.get("basicJob").start(step1()).build();
	}

	// @Bean
	public Job copyJob() {
		return this.jobBuilderFactory.get("copyJob")
			.start(listFileStep())
			.build();
	}
	
	@Bean
	public TaskExecutor taskExecutor(){
		SimpleAsyncTaskExecutor t = new SimpleAsyncTaskExecutor("spring_batch");
		t.setConcurrencyLimit(2);
		return t;
	}
	
	@Bean
    public Partitioner partitioner() {
		return new Partitioner() {
			
			@Override
			public Map<String, ExecutionContext> partition(int gridSize) {
				Map<String, ExecutionContext> parts = new HashMap<>();
				for (int i = 1; i <= 6; i++) {
					ExecutionContext context = new ExecutionContext();
					context.put("file", "~temp/datafiles/file" + i + ".txt");
					parts.put("part" + i, context);
				}
				return parts;
			}
		};
	}
	
	@Bean
    public PartitionHandler partitionHandler() {
	    	TaskExecutorPartitionHandler tep = new TaskExecutorPartitionHandler();
	    	tep.setGridSize(2);
	    	tep.setTaskExecutor(partitionTaskExecutor());
	    	tep.setStep(fileReaderStep());
	    	return tep;
    }
	
    public TaskExecutor partitionTaskExecutor() {
    		SimpleAsyncTaskExecutor taskExecutor = new SimpleAsyncTaskExecutor("partitionTask");
    		taskExecutor.setConcurrencyLimit(2);
    		return taskExecutor;
    }
	
    @Bean
    public Step fileReaderStep() {
    		return this.stepBuilderFactory.get("fileLoaderstep")
    			.<FileLine, FileLine>chunk(3) 
    			.reader(getFileReader(null))
    			.writer(getFileWriter())
    			.listener(new StepExecutionListener() {
					@Override
					public void beforeStep(StepExecution stepExecution) {
						System.out.println("bs");
					}
					
					@Override
					public ExitStatus afterStep(StepExecution stepExecution) {
						System.out.println(stepExecution.getExecutionContext().get("file"));
						// System.out.println("as");
						return ExitStatus.COMPLETED;
					}
				})
    	        .build();
    }
    
    @Bean
    @StepScope
    public ItemReader<FileLine> getFileReader(@Value("#{stepExecutionContext['file']}") final String file) {
    		return new AbstractItemStreamItemReader<FileLine>() {
				int i = 0;
				{
					System.out.println("new reader " + file);
				}
				@Override
				public void open(ExecutionContext executionContext) throws ItemStreamException {
					// System.out.println(executionContext.get("file"));
				}
				
				@Override
				public FileLine read() throws Exception, UnexpectedInputException, ParseException {
					if (i >= 6) return null;
					return new FileLine("str " + i++);
				}
			};
    }
    
    @Bean
    @StepScope
    public ItemWriter<FileLine> getFileWriter() {
    		return new ItemWriter<FileLine>() {
			AtomicInteger writes = new AtomicInteger();
			@Override
			public void write(List<? extends FileLine> items) throws Exception {
				Thread.sleep(2000);
				System.out.println(Thread.currentThread().getName() + " writer " + items + " " + this.hashCode());
			}
		};
    }
    
	@Bean
    public Step partitionStep() {
        return this.stepBuilderFactory.get("partitionStep")
	    		.partitioner("partition", partitioner()) // partition provider
	    		.partitionHandler(partitionHandler())
	    		.gridSize(2)
    			.build();
    }
	
	@Bean
    public Job printerJob() {
        return this.jobBuilderFactory.get("printerJob")
            .start(partitionStep())
            .build();
    }
	
	// @Bean
	public Step listFileStep() {
		return this.stepBuilderFactory
			.get("listFileStep")
			.chunk(3)
			.reader(new DirectoryFilesReader()) // faultTolerant().skip()...
			.writer(new DirectoryFileWriter())
			.taskExecutor(taskExecutor())
			.listener(new ChunkListenerImpl())
			.build();
	}
	
	@Bean
	public Step step1() {
		return this.stepBuilderFactory.get("step1").tasklet(helloWorldTasklet(null)).build();
	}

	@StepScope
	@Bean
	public Tasklet helloWorldTasklet(@Value("#{jobParameters['name']}") String name) {
		return (contribution, chunkContext) -> {
			System.out.println(String.format("Hello, %s!", name));
			return RepeatStatus.FINISHED;
		};
	}
	
	@Bean
	public BatchConfigurer getBatchConfiguerer() {
		return new DefaultBatchConfigurer() { };
	}
}
