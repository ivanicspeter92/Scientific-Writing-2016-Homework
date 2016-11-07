package com.example.peterivanics.dutycyclingdemo;

import java.util.Calendar;
import java.util.Timer;
import java.util.TimerTask;

import android.location.Location;
import android.location.LocationManager;
import android.util.Log;

/**
 * Created by peter.ivanics on 05/11/2016.
 */

public class DutyCycling {
    private double movementSpeed;
    private double treshold;

    private Location currentLocation = new Location(LocationManager.GPS_PROVIDER);
    private Calendar lastPollingDate;
    private GPSCoordinates coordinates;
    private double estimatedError = 0;

    private Timer timer = new Timer();

    public DutyCycling(double movementSpeed, double treshold) {
        Log.d("CREATION", "Duty cycling initiated!");
        this.movementSpeed = movementSpeed;
        this.treshold = treshold;
    }

    public GPSCoordinates getCoordinates() {
        return this.coordinates;
    }

    public double getDeltaTimeSeconds() {
        return (this.treshold - this.estimatedError) / this.movementSpeed;
    }

    public void start() {
        this.refreshCoordinates();
        Log.d("STATE", "Duty cycling started! Frequency: " + this.getDeltaTimeSeconds());
        this.timer.schedule(new TimerTask() {
            @Override
            public void run() {
                refreshCoordinatesIfTimeHasElapsed();
            }
        }, 0, (int)(this.getDeltaTimeSeconds()) * 1000);
    }

    public void stop(){
        this.timer.cancel();
    }

    private void refreshCoordinatesIfTimeHasElapsed() {
        Log.d("STATE", "Checking if time has elapsed...");
        if (this.areLastCoordinatesExpired()) {
            this.refreshCoordinates();
        } else {
            Log.d("STATE", "No need to refresh coordinates, sleeping...");
        }
    }

    private boolean areLastCoordinatesExpired() {
        Calendar currentDate = Calendar.getInstance();
        currentDate.add(Calendar.SECOND, -1 * (int)this.getDeltaTimeSeconds());

        if (currentDate.after(this.lastPollingDate)) {
            return true;
        }
        return false;
    }

    private void refreshCoordinates() {
        this.coordinates = new GPSCoordinates(this.currentLocation.getLatitude(), this.currentLocation.getLongitude());

        this.refreshTrackingVariables();
        Log.d("STATE", "Coordinates refreshed! New coordinates: (" + this.coordinates.latitude + ", " + this.coordinates.longitude + ")");
    }

    private void refreshTrackingVariables() {
        this.lastPollingDate = Calendar.getInstance();
        //this.movementSpeed = this.currentLocation.getSpeed(); //\TODO
        //this.estimatedError = this.currentLocation.getError(); //\TODO
    }
}
