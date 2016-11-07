package com.example.peterivanics.dutycyclingdemo;

import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;

public class MainActivity extends AppCompatActivity {
    private DutyCycling cycling;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        this.cycling = new DutyCycling(3.5, 50);
        this.cycling.start();
    }
}
