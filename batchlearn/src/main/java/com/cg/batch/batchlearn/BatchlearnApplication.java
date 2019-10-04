package com.cg.batch.batchlearn;

import org.springframework.batch.core.configuration.annotation.EnableBatchProcessing;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.jdbc.DataSourceAutoConfiguration;

@SpringBootApplication(scanBasePackages = {"com.cg.batch.batchlearn"})
@EnableBatchProcessing
@EnableAutoConfiguration(exclude = {DataSourceAutoConfiguration.class})
// @Import({CustomBatchConfigurer.class})
public class BatchlearnApplication {

	public static void main(String[] args) {
		// spring.batch.job.names
		// spring.batch.job.enabled
		SpringApplication.run(BatchlearnApplication.class, args);
	}

}
