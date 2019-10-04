package com.cg.batch.batchlearn;

import org.springframework.batch.core.Job;
import org.springframework.batch.core.Step;
import org.springframework.batch.core.configuration.annotation.BatchConfigurer;
import org.springframework.batch.core.configuration.annotation.DefaultBatchConfigurer;
import org.springframework.batch.core.configuration.annotation.JobBuilderFactory;
import org.springframework.batch.core.configuration.annotation.StepBuilderFactory;
import org.springframework.batch.core.configuration.annotation.StepScope;
import org.springframework.batch.core.step.tasklet.Tasklet;
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

	@Bean
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
