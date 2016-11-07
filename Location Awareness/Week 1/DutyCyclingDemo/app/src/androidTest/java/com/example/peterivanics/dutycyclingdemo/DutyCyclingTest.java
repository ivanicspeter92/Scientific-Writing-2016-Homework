package com.example.peterivanics.dutycyclingdemo;

import android.content.Context;
import android.support.test.InstrumentationRegistry;
import android.support.test.runner.AndroidJUnit4;

import org.junit.Test;
import org.junit.runner.RunWith;

import static org.junit.Assert.*;

@RunWith(AndroidJUnit4.class)
public class DutyCyclingTest {

    @Test
    public void givenExampleOne() throws Exception {
        double velocity = 3.5, errorTreshold = 50;

        DutyCycling testObject = new DutyCycling(velocity, errorTreshold);

        assertEquals(14.285, testObject.getDeltaTimeSeconds(), 0.01);
    }

    @Test
    public void givenExampleTwo() throws Exception {
        double velocity = 3.5, errorTreshold = 150;

        DutyCycling testObject = new DutyCycling(velocity, errorTreshold);

        assertEquals(42.85, testObject.getDeltaTimeSeconds(), 0.01);
    }
}
