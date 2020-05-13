package com.cip.app;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.ws.rs.GET;
import javax.ws.rs.Path;

@Path("/api")
public class WebController {
    @GET
    @Path("/ping")
    public String ping() {
        return "ping";
    }
}
