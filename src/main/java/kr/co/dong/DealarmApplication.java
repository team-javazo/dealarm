package kr.co.dong;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling;

@SpringBootApplication
@EnableScheduling
public class DealarmApplication {
    public static void main(String[] args) {
        SpringApplication.run(DealarmApplication.class, args);
    }
}
