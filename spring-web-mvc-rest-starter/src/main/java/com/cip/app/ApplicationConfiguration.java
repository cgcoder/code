package com.cip.app;

import org.glassfish.jersey.server.ResourceConfig;
import org.springframework.context.annotation.Configuration;

@Configuration
public class ApplicationConfiguration extends ResourceConfig {
    public ApplicationConfiguration() {
        register(WebController.class);
    }
}
